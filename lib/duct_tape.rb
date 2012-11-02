require 'rubygems'
require 'facets'
Dir[__DIR__("ext", "*.rb")].each { |f| require f }

if gem_installed?('algorithms')
  require 'algorithms'
  automatic_require "algorithms"
end

automatic_require
