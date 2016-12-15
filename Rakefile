require "bundler/gem_tasks"
require "rspec/core/rake_task"


# Don't push the gem to rubygems
ENV["gem_push"] = "false"

Rake::Task["release"].enhance do
  spec = Gem::Specification::load(Dir.glob("*.gemspec").first)
  sh "gem push pkg/#{spec.name}-#{spec.version}.gem --host https://gems.listia.io"
end
