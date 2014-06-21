require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Symbol#<=>
#
describe Symbol, "#<=>" do
  it "should have the method defined" do
    expect(Symbol.method_defined?(:<=>)).to be(true)
  end

  pending "More tests"
end
