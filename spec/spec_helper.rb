$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
if RUBY_VERSION >= "1.9"
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'duct_tape'

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
