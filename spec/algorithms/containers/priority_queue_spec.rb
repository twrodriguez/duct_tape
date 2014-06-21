require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

#
# Containers::PriorityQueue#to_a
#
describe Containers::PriorityQueue, "#to_a" do
  it "should have the method defined" do
    expect(Containers::PriorityQueue.method_defined?(:to_a)).to be(true)
  end

  it "remains unchanged" do
    # TODO
  end

  pending "More tests"
end

#
# Containers::PriorityQueue#each
#
describe Containers::PriorityQueue, "#each" do
  it "should have the method defined" do
    expect(Containers::PriorityQueue.method_defined?(:each)).to be(true)
  end

  it "remains unchanged" do
    # TODO
  end

  pending "More tests"
end
