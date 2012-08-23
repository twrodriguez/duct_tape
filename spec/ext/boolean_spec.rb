require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# TrueClass#is_a? Boolean
#
describe TrueClass, "#is_a? Boolean" do
  it "is a Boolean" do
    true.should be_a_kind_of Boolean
  end
end

#
# FalseClass#is_a? Boolean
#
describe FalseClass, "#is_a? Boolean" do
  it "is a Boolean" do
    false.should be_a_kind_of Boolean
  end
end
