require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# URI::Generic#relative_path?
#
describe URI::Generic, "#relative_path?" do
  it "should have the method defined" do
    expect(URI::Generic.method_defined?(:relative_path?)).to be(true)
  end

  pending "More tests"
end

#
# URI::Generic#absolute_path?
#
describe URI::Generic, "#absolute_path?" do
  it "should have the method defined" do
    expect(URI::Generic.method_defined?(:absolute_path?)).to be(true)
  end

  pending "More tests"
end

#
# URI::Generic#relative_scheme?
#
describe URI::Generic, "#relative_scheme?" do
  it "should have the method defined" do
    expect(URI::Generic.method_defined?(:relative_scheme?)).to be(true)
  end

  pending "More tests"
end

#
# URI::Generic#origin
#
describe URI::Generic, "#origin" do
  it "should have the method defined" do
    expect(URI::Generic.method_defined?(:origin)).to be(true)
  end

  pending "More tests"
end
