require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Object#deep_dup
#
describe Object, "#deep_dup" do
  it "should have the method defined" do
    expect(Object.method_defined?(:deep_dup)).to be(true)
  end

  pending "More tests"
end

#
# Object#just_my_methods
#
describe Object, "#just_my_methods" do
  it "should have the method defined" do
    expect(Object.method_defined?(:just_my_methods)).to be(true)
  end

  pending "More tests"
end
