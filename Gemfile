source "http://rubygems.org"

group :development do
  gem "yard"
  gem "jeweler"
  gem "rspec"
  gem "rake"

  gem (RUBY_VERSION >= "1.9" ? "simplecov" : "rcov")
end

group :mkrf do
  # JRuby can have issues compiling algorithms' extensions
  # Maglev, IronRuby, and MacRuby are untested
  RUBY_ENGINE = "ruby" unless defined? RUBY_ENGINE
  gem 'algorithms' unless RUBY_ENGINE =~ /jruby|maglev|ir|macruby/i
end

gem "facets", ">=2.9.3"
gem "backports"
gem "bundler"
