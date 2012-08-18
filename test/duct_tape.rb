require File.join(File.dirname(__FILE__), '..', 'lib', 'duct_tape.rb')

Dir[__DIR__("**", "*.rb")].each { |f| require f }
