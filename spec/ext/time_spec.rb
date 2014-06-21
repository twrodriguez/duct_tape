require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Time.duration
#
describe Time, ".duration" do
  it "should have the method defined" do
    expect(Time.respond_to?(:duration)).to be(true)
  end

  pending "More tests"
end

#
# Time#to_datetime
#
describe Time, "#to_datetime" do
  it "should have the method defined" do
    expect(Time.method_defined?(:to_datetime)).to be(true)
  end

  pending "More tests"
end
