require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Dir.relative_path
#
describe Dir, ".relative_path" do
  it "should have the method defined" do
    expect(Dir.respond_to?(:relative_path)).to be(true)
  end

  pending "More tests"
end

#
# Dir.absolute_path
#
describe Dir, ".absolute_path" do
  it "should have the method defined" do
    expect(Dir.respond_to?(:absolute_path)).to be(true)
  end

  pending "More tests"
end

#
# Dir.empty?
#
describe Dir, ".empty?" do
  it "should have the method defined" do
    expect(Dir.respond_to?(:empty?)).to be(true)
  end

  pending "More tests"
end

#
# Dir#children
#
describe Dir, "#children" do
  it "should have the method defined" do
    expect(Dir.method_defined?(:children)).to be(true)
  end

  pending "More tests"
end

#
# Dir#/
#
describe Dir, "#/" do
  it "should have the method defined" do
    expect(Dir.method_defined?(:/)).to be(true)
  end

  pending "More tests"
end
