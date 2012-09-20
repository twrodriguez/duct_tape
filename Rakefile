require 'rubygems'
require 'rake'
require 'jeweler'

version = File.read(File.expand_path("../VERSION",__FILE__)).strip
Jeweler::Tasks.new do |gem|
  gem.name = "duct_tape"
  gem.summary = "A bunch of useful patches for core Ruby classes"
  gem.description = "A general-purpose utility library for Ruby"
  gem.email = ["tw.rodriguez@gmail.com"]
  gem.homepage = "http://github.com/twrodriguez/duct_tape"
  gem.authors = ["Tim Rodriguez"]
  gem.extensions = 'ext/mkrf_conf.rb'
  gem.required_ruby_version = '>= 1.8.7'
  gem.license = 'Simplified BSD'
  gem.version = version
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
end
