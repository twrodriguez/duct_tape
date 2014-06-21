require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Regexp#invert
#
describe Regexp, "#invert" do
  it "should have the method defined" do
    expect(Regexp.method_defined?(:invert)).to be(true)
  end

  pending "More tests"
end
