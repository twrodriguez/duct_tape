require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# DateTime#to_time
#
describe DateTime, "#to_time" do
  it "should have the method defined" do
    expect(DateTime.method_defined?(:to_time)).to be(true)
  end

  pending "More tests"
end
