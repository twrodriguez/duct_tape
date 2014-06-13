require 'rubygems'
require 'backports'
require 'facets/kernel'
require 'facets/enumerable'
require 'facets/array'
require 'facets/dir'
require 'facets/file'
require 'facets/hash'
require 'facets/numeric'
require 'facets/range'
require 'facets/regexp'
require 'facets/string'
require 'facets/symbol'
require 'facets/time'
require 'facets/uri'

Dir[__DIR__("ext", "*.rb")].each { |f| require f }

if gem_installed?('algorithms')
  require 'algorithms'
  automatic_require "algorithms"
end

automatic_require
