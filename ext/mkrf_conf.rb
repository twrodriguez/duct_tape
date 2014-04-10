require 'rbconfig'
require 'bundler'

system("bundle install --system --without development")

=begin
require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb'

begin
  Gem::Command.build_args = ARGV
rescue NoMethodError
end

inst = Gem::DependencyInstaller.new
engine = ::RbConfig::CONFIG['RUBY_INSTALL_NAME']
if defined?(RUBY_ENGINE)
  engine << " " << RUBY_ENGINE
end
# JRuby can have issues compiling algorithms' extensions
# Maglev, IronRuby, and MacRuby are untested
if engine !~ /jruby|maglev|ir|macruby/i
  begin
    require 'algorithms'
  rescue LoadError
    puts "No JRuby, Maglev, IronRuby, or MacRuby detected, installing 'algorithms'..."
    inst.install "algorithms"
  end
end

begin
  require 'facets'
rescue LoadError
  inst.install "facets"
end

if Facets::VERSION <= "2.9.3"
end
#gem "facets", "> 2.9.3", :git => 'git://github.com/twrodriguez/facets.git', :branch => 'extend_patch_2_9_3'

if RUBY_VERSION >= "1.9"
  #inst.install "simplecov"
else
  #inst.install "rcov"
end
=end

# create dummy rakefile to indicate success
f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
f.write("task :default\n")
f.close
