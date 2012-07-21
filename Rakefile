require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  version = File.read(File.expand_path("../VERSION",__FILE__)).strip
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "duct_tape"
    gemspec.summary = "A bunch of useful patches for core classes"
    gemspec.description = "A bunch of useful patches for core classes"
    gemspec.email = ["tw.rodriguez@gmail.com"]
    gemspec.homepage = "http://github.com/twrodriguez/duct_tape"
    gemspec.authors = ["Tim Rodriguez"]
    gemspec.add_development_dependency('jeweler')
    gemspec.add_development_dependency('bundler')
    gemspec.add_development_dependency('rspec')
    gemspec.add_dependency('facets')
    gemspec.add_dependency('algorithms')
    gemspec.required_ruby_version = '>= 1.8.7'
    gemspec.license = 'Simplified BSD'
    gemspec.version = version
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: 'gem install jeweler' or 'bundle' "
end
