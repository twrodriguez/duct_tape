require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Hash#deep_merge
#
describe Hash, "#deep_merge" do
  it "should have the method defined" do
    expect(Hash.method_defined?(:deep_merge)).to be(true)
  end

  pending "More tests"
end

#
# Hash#deep_merge!
#
describe Hash, "#deep_merge!" do
  it "should have the method defined" do
    expect(Hash.method_defined?(:deep_merge!)).to be(true)
  end

  pending "More tests"
end

#
# Hash#chunk
#
describe Hash, "#chunk" do
  it "should have the method defined" do
    expect(Hash.method_defined?(:chunk)).to be(true)
  end

  pending "More tests"
end

#
# Hash#not_empty?
#
describe Hash, "#not_empty?" do
  it "should have the method defined" do
    expect(Hash.method_defined?(:not_empty?)).to be(true)
  end

  pending "More tests"
end

#
# Hash#select_keys
#
describe Hash, "#select_keys" do
  it "should have the method defined" do
    expect(Hash.method_defined?(:select_keys)).to be(true)
  end

  pending "More tests"
end

#
# Hash#select_keys!
#
describe Hash, "#select_keys!" do
  it "should have the method defined" do
    expect(Hash.method_defined?(:select_keys!)).to be(true)
  end

  pending "More tests"
end

#
# Hash#reject_keys
#
describe Hash, "#reject_keys" do
  it "should have the method defined" do
    expect(Hash.method_defined?(:reject_keys)).to be(true)
  end

  pending "More tests"
end

#
# Hash#reject_keys!
#
describe Hash, "#reject_keys!" do
  it "should have the method defined" do
    expect(Hash.method_defined?(:reject_keys!)).to be(true)
  end

  pending "More tests"
end

#
# Hash#to_h
#
describe Hash, "#to_h" do
  it "should have the method defined" do
    expect(Hash.method_defined?(:to_h)).to be(true)
  end

  it "should not create a new instance" do
    a = {1=>2}
    b = a.to_h
    b[2] = 3
    expect(a).to eq(b)
  end
end
