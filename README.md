# EnumTransitions

Rails provides [ActiveRecord::Enum](http://api.rubyonrails.org/classes/ActiveRecord/Enum.html) which is great for state machines. The only problem is that it doesn't provide built-in validations for transitions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'enum_transitions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enum_transitions

## Usage

For example, let's say you have a `Car` model:

```ruby
class Car < ApplicationRecord
  enum state: [ :parked, :drive, :reverse ]

  enum_transitions state: {
    parked: [ :drive, :reverse ],
    drive: :parked,
    reverse: :parked
  }
end
```

Then when you call the transition methods (provided by `ActiveRecord::Enum`), an error will raise if the transition is invalid:

```ruby
car = Car.create!
car.drive! #=> car.state == :drive
car.reverse! #=> raises EnumTransitions::InvalidTransition

car.transitions_to_reverse? #=> false
car.transitions_to_parked? #=> true
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/listia/enum_transitions.

