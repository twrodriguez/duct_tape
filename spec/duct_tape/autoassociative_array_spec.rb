require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Containers::AutoassociativeArray#initialize
#
describe Containers::AutoassociativeArray, "#initialize" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Containers::AutoassociativeArray#insert
#
describe Containers::AutoassociativeArray, "#insert" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Containers::AutoassociativeArray#<<
#
describe Containers::AutoassociativeArray, "#<<" do
  it "remains unchanged" do
    # TODO
  end
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
    aa.partial_match(1,4,5).should eq([3,4,5])
  end

  it "returns all of the matches with the most query matches" do
    aa = Containers::AutoassociativeArray.new
    aa << [1,2,3] << [2,3,4] << [3,4,5]
    aa.partial_match(1,5).should eq([[1,2,3], [3,4,5]])
    aa.partial_match(1,3,5).should eq([[1,2,3], [3,4,5]])
    aa.partial_match(2,4).should eq([2,3,4])
  end

  it "returns the matches with the most query matches with the most matches" do
    aa = Containers::AutoassociativeArray.new
    aa << [1,2,3] << [2,3,4] << [3,4,5]
    aa.partial_match(1,4).should eq([[2,3,4], [3,4,5]])
    aa.partial_match(2,5).should eq([[1,2,3], [2,3,4]])
  end
end

#
# Containers::AutoassociativeArray#[]
#
describe Containers::AutoassociativeArray, "#[]" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Containers::AutoassociativeArray#by_column
#
describe Containers::AutoassociativeArray, "#by_column" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Containers::AutoassociativeArray#empty?
#
describe Containers::AutoassociativeArray, "#empty?" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Containers::AutoassociativeArray#length
#
describe Containers::AutoassociativeArray, "#length" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Containers::AutoassociativeArray#size
#
describe Containers::AutoassociativeArray, "#size" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Containers::AutoassociativeArray#clear
#
describe Containers::AutoassociativeArray, "#clear" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Containers::AutoassociativeArray#inspect
#
describe Containers::AutoassociativeArray, "#inspect" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Containers::AutoassociativeArray#to_s
#
describe Containers::AutoassociativeArray, "#to_s" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Containers::AutoassociativeArray#dup
#
describe Containers::AutoassociativeArray, "#dup" do
  it "remains unchanged" do
    # TODO
  end
end
