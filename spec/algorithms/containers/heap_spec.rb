require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

#
# Containers::Heap#to_a
#
describe Containers::Heap, "#to_a" do
  it "should have the method defined" do
    expect(Containers::Heap.method_defined?(:to_a)).to be(true)
  end

  it "remains unchanged" do
    # TODO
  end

  pending "More tests"
end

#
# Containers::Heap#each
#
describe Containers::Heap, "#each" do
  it "should have the method defined" do
    expect(Containers::Heap.method_defined?(:each)).to be(true)
  end

  it "remains unchanged" do
    # TODO
  end

  pending "More tests"
end
