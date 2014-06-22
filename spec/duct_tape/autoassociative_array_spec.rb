require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Containers::AutoassociativeArray#initialize
#
describe Containers::AutoassociativeArray, "#initialize" do
  pending "More tests"
end

#
# Containers::AutoassociativeArray#insert
#
describe Containers::AutoassociativeArray, "#insert" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:insert)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#<<
#
describe Containers::AutoassociativeArray, "#<<" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:<<)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#partial_match
#
describe Containers::AutoassociativeArray, "#partial_match" do
  it "remains unchanged" do
    # TODO
  end

  it "returns the matches with the most query matches" do
    aa = Containers::AutoassociativeArray.new
    aa << [1,2,3] << [2,3,4] << [3,4,5]
    expect(aa.partial_match(1,4,5)).to eq([[3,4,5]])
  end

  it "returns all of the matches with the most query matches" do
    aa = Containers::AutoassociativeArray.new
    aa << [1,2,3] << [2,3,4] << [3,4,5]
    expect(aa.partial_match(1,5)).to eq([[1,2,3], [3,4,5]])
    expect(aa.partial_match(1,3,5)).to eq([[1,2,3], [3,4,5]])
    expect(aa.partial_match(2,4)).to eq([[2,3,4]])
  end

  it "returns the matches with the most query matches with the most matches" do
    aa = Containers::AutoassociativeArray.new
    aa << [1,2,3] << [2,3,4] << [3,4,5]
    expect(aa.partial_match(1,4)).to eq([[2,3,4], [3,4,5]])
    expect(aa.partial_match(2,5)).to eq([[1,2,3], [2,3,4]])
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#[]
#
describe Containers::AutoassociativeArray, "#[]" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:[])).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#by_column
#
describe Containers::AutoassociativeArray, "#by_column" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:by_column)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#empty?
#
describe Containers::AutoassociativeArray, "#empty?" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:empty?)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#length
#
describe Containers::AutoassociativeArray, "#length" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:length)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#size
#
describe Containers::AutoassociativeArray, "#size" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:size)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#clear
#
describe Containers::AutoassociativeArray, "#clear" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:clear)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#inspect
#
describe Containers::AutoassociativeArray, "#inspect" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:inspect)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#to_s
#
describe Containers::AutoassociativeArray, "#to_s" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:to_s)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#dup
#
describe Containers::AutoassociativeArray, "#dup" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.method_defined?(:dup)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#rebuild_hash
#
describe Containers::AutoassociativeArray, "#rebuild_hash" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.private_method_defined?(:rebuild_hash)).to be(true)
  end

  pending "More tests"
end

#
# Containers::AutoassociativeArray#match_impl
#
describe Containers::AutoassociativeArray, "#match_impl" do
  it "should have the method defined" do
    expect(Containers::AutoassociativeArray.private_method_defined?(:match_impl)).to be(true)
  end

  pending "More tests"
end
