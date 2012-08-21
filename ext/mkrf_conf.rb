require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb'
require 'rbconfig'

begin
  Gem::Command.build_args = ARGV
rescue NoMethodError
end

inst = Gem::DependencyInstaller.new
begin
  engine = ::RbConfig::CONFIG['RUBY_INSTALL_NAME']
  if defined?(RUBY_ENGINE)
    engine << " " << RUBY_ENGINE
  end
  # JRuby can have issues compiling algorithms' extensions
  # Maglev, IronRuby, and MacRuby are untested
  if engine !~ /jruby|maglev|ir|macruby/i
    inst.install "algorithms"
  end
rescue
  exit(1)
end

# create dummy rakefile to indicate success
f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
f.write("task :default\n")
f.close
