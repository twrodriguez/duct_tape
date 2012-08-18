require 'rubygems'
require 'facets'
Dir[__DIR__("ext", "*.rb")].each { |f| require f }

if detect_interpreter_language =~ /^c/i
  require 'algorithms'
  automatic_require "algorithms"
end

automatic_require
