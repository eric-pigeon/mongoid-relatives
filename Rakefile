require "bundler/gem_tasks"
require "rake"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new("spec") do |spec|
    spec.pattern = "spec/**/*_spec.rb"
end

task :console do
  require 'irb'
  require 'irb/completion'
  require 'mongoid'
  require 'mongoid-relatives'
  Mongoid.load!(File.expand_path('spec/mongoid.yml', File.dirname(__FILE__)), :test)
  Dir["./spec/app/models/*.rb"].each {|f| require f}
  ARGV.clear
  IRB.start
end

task :default => :spec

