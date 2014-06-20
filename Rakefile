require 'rubygems'
require 'rake'
require 'jeweler'

VERSION_FILE = File.expand_path("../VERSION", __FILE__)
VERSION_STRING = File.read(VERSION_FILE).strip
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
  gem.version = VERSION_STRING
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

if RUBY_VERSION < "1.9"
  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rcov = true
  end
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
end

desc "Check syntax for all project files"
task :syntax do
  types = {
    "yaml" => [{
      :cmd => %q{ruby -ryaml -e "begin; YAML::load(IO.read('%s')); rescue Exception => e; raise if e.is_a?(SyntaxError); end"}
    }],
    "json" => [{
      :check => %q{gem list | grep "json"},
      :cmd => %q{ruby -rrubygems -rjson -e "JSON.parse(IO.read('%s'))"}
    }],
    "css" => [{
      :cmd => %q{lessc "%s"},
    }],
    #"less" => [{:cmd => %q{lessc "%s"}}],
    "js" => [{
      :cmd => %q{js -C "%s"},
    }, {
      :cmd => %q{uglifyjs "%s"},
    }],
    "py" => [{
      :cmd => %q{python -m py_comile "%s"},
    }, {
      :cmd => %q{pypy -m py_comile "%s"},
    }],
    "rb" => [{
      :cmd => %q{ruby -c "%s"}
    }],
    "rake" => [{
      :cmd => %q{ruby -c "%s"}
    }],
    "sh" => [{
      :cmd => %q{bash -n "%s"}
    }],
  }

  types.each do |type,method_array|
    types[type].each_with_index do |method_hsh,idx|
      types[type][idx][:check] ||= "which #{types[type][idx][:cmd]}"
    end
  end

  err = test("e", File.join("", "dev", "null")) ? File.join("", "dev", "null") : "nul"
  syntax_error_found = false

  Dir[File.join("**", "*")].each do |filename|
    extname = File.extname(filename).gsub(".", "")

    if types.has_key?(extname)
      if method_hsh = types[extname].detect { |hsh| !(`#{hsh[:check]} 2> #{err}`.strip.empty?) }
        `#{method_hsh[:cmd] % filename} 1> #{err}`
        if $?.to_i != 0
          syntax_error_found = true
          warn "Syntax Error found for '#{filename}'!"
        end
      end
    end
  end

  if syntax_error_found
    fail "Syntax Errors found!"
  else
    puts "Everything seems alright. Try running tests!"
  end
end

desc "Increment patch version"
task :bump_patch_version do
  puts "Old Version: #{VERSION_STRING}"
  File.open(VERSION_FILE, "w") do |f|
    f.write(VERSION_STRING.sub!(/^(\d+)\.(\d+)\.(\d+)$/) { |s| "#{$1}.#{$2}.#{$3.to_i + 1}" })
  end
  commit_msg = "New Version: #{VERSION_STRING}"
  sh "git commit -m #{commit_msg.inspect} #{(VERSION_FILE).to_s.inspect}"
  sh "git checkout -- #{(VERSION_FILE).to_s.inspect}"
end

desc "Increment minor version"
task :bump_minor_version do
  puts "Old Version: #{VERSION_STRING}"
  File.open(VERSION_FILE, "w") do |f|
    f.write(VERSION_STRING.sub!(/^(\d+)\.(\d+)\.(\d+)$/) { |s| "#{$1}.#{$2.to_i + 1}.0" })
  end
  commit_msg = "New Version: #{VERSION_STRING}"
  sh "git commit -m #{commit_msg.inspect} #{(VERSION_FILE).to_s.inspect}"
  sh "git checkout -- #{(VERSION_FILE).to_s.inspect}"
end

desc "Increment major version"
task :bump_major_version do
  puts "Old Version: #{VERSION_STRING}"
  File.open(VERSION_FILE, "w") do |f|
    f.write(VERSION_STRING.sub!(/^(\d+)\.(\d+)\.(\d+)$/) { |s| "#{$1.to_i + 1}.0.0" })
  end
  commit_msg = "New Version: #{VERSION_STRING}"
  sh "git commit -m #{commit_msg.inspect} #{(VERSION_FILE).to_s.inspect}"
  sh "git checkout -- #{(VERSION_FILE).to_s.inspect}"
end

desc "Finalize release (tag & increment version)"
task :release do
  puts "Tagging release version: #{VERSION_STRING}"
  sh "git tag v#{VERSION_STRING}"
  sh "git push --tags"
  Rake::Task[:bump_patch_version].invoke
end

task :default => :spec
