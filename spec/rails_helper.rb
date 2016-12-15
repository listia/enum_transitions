# This file is copied to spec/ when you run 'rails generate rspec:install'
require "pathname"
ROOT_PATH = Pathname.new(__FILE__).join("../..").expand_path
$LOAD_PATH.unshift(ROOT_PATH.join("lib").to_s)

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"

Rails.backtrace_cleaner.remove_silencers!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[ROOT_PATH.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Disable the should syntax compeletely; we use the expect syntax only.
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    silence_stream(STDOUT) do
      load("#{Rails.root}/db/schema.rb")
    end
  end
end
