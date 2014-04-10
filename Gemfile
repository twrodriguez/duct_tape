source "http://rubygems.org"

group :development do
  gem "yard"
  gem "jeweler"
  gem "rspec"

  gem (RUBY_VERSION >= "1.9" ? "simplecov" : "rcov")
end

group :mkrf do
  gem "facets", "> 2.9.3", :git => 'git://github.com/twrodriguez/facets.git', :branch => 'extend_patch_2_9_3'

  # JRuby can have issues compiling algorithms' extensions
  # Maglev, IronRuby, and MacRuby are untested
  RUBY_ENGINE = "ruby" unless defined? RUBY_ENGINE
  gem 'algorithms' unless RUBY_ENGINE =~ /jruby|maglev|ir|macruby/i
end

gem "backports"
gem "bundler"
gem "rake"
