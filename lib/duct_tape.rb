require 'rubygems'
require 'facets'
Dir[File.join(File.dirname(__FILE__), "ext", "*.rb")].each { |f| require f }

if detect_interpreter_language =~ /^c/i
  require 'algorithms'
  Dir[File.join(File.dirname(__FILE__), "algorithms", "*.rb")].each { |f| require f }
end

Dir[File.join(File.dirname(__FILE__), "duct_tape", "*.rb")].each { |f| require f }
