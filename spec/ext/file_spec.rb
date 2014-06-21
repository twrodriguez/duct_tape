require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# File.relative_path
#
describe File, ".relative_path" do
  it "should have the method defined" do
    expect(File.respond_to?(:relative_path)).to be(true)
  end

  pending "More tests"
end

#
# File.absolute_path
#
describe File, ".absolute_path" do
  it "should have the method defined" do
    expect(File.respond_to?(:absolute_path)).to be(true)
  end

  pending "More tests"
end
