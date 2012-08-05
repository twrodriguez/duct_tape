require File.join(File.dirname(__FILE__), '..', 'lib', 'duct_tape.rb')

Dir[File.join(File.dirname(__FILE__), "**", "*.rb")].each { |f| require f }
