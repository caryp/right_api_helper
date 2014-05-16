require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Run functional tests. Requires RightScale account information in knife.rb file."
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
end
