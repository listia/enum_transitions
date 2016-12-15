# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enum_transitions/version'

Gem::Specification.new do |spec|
  spec.name          = "enum_transitions"
  spec.version       = EnumTransitions::VERSION
  spec.authors       = ["Ngan Pham", "Xenor Chang"]
  spec.email         = ["ngan@listia.com", "xenor@listia.com"]

  spec.summary       = %q{Make Rails enum transitionable.}
  spec.description   = %q{Make Rails enum transitionable.}
  spec.homepage      = "https://github.com/listia/enum_transitions"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://gems.listia.io"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 4.1", "< 4.3"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-rails", "~> 3.5"
  spec.add_development_dependency "byebug", "~> 9.0.6"
  spec.add_development_dependency "sqlite3"
end
