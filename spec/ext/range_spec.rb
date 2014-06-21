require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Range#chunk
#
describe Range, "#chunk" do
  it "should have the method defined" do
    expect(Range.method_defined?(:chunk)).to be(true)
  end

  pending "More tests"
end
