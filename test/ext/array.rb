#
# Array#deep_merge
#
describe Array, "#deep_merge" do
  it "remains unchanged" do
    ary = [1,2,3,4,5]
    ary.deep_merge([6,7,8])
    ary.should eq([1,2,3,4,5])
  end

  it "merges flat arrays properly" do
    ary = [1,2,3,4,5]
    val = ary.deep_merge([4,5,6])
    val.should eq([1,2,3,4,5,6])
    (val.hash == ary.hash).should be_false
  end

  it "merges nested arrays properly" do
    ary = [1,2,[3,4,5]]
    val = ary.deep_merge([3,4,[5,6,7]])
    val.should eq([1,2,[3,4,5,6,7],3,4])
    (val.hash == ary.hash).should be_false
  end
end

#
# Array#deep_merge!
#
describe Array, "#deep_merge!" do
  it "changes" do
    ary = [1,2,3,4,5]
    val = ary.deep_merge!([6,7,8])
    ary.should eq([1,2,3,4,5,6,7,8])
    (val.hash == ary.hash).should be_true
  end

  it "returns nil if nothing was changed" do
    ary = [1,2,3,4,5]
    val = ary.deep_merge!([4,5])
    val.should be_nil
  end

  it "returns self if it changed" do
    ary = [1,2,3,4,5]
    val = ary.deep_merge!([4,5,6])
    val.should eq([1,2,3,4,5,6])
    (val.hash == ary.hash).should be_true
  end

  it "merges flat arrays properly" do
    ary = [1,2,3,4,5]
    ary.deep_merge!([4,5,6])
    ary.should eq([1,2,3,4,5,6])
  end

  it "merges nested arrays properly" do
    ary = [1,2,[3,4,5]]
    ary.deep_merge!([3,4,[5,6,7]])
    ary.should eq([1,2,[3,4,5,6,7],3,4])
  end
end

#
# Array#*
#
describe Array, "#*" do
  it "remains unchanged" do
    ary = [1,2,3]
    val1 = ary * 2; val2 = ary * ","; val3 = ary * ary
    ary.should eq([1,2,3])
    (val1.hash == ary.hash).should be_false
    (val2.hash == ary.hash).should be_false
    (val3.hash == ary.hash).should be_false
  end

  it "concats correctly" do
    ary = [1,2,3]

    (ary * 0).should eq([])
    (ary * 1).should eq([1,2,3])
    (ary * 2).should eq([1,2,3,1,2,3])
  end

  it "joins correctly" do
    ary = [1,2,3]

    (ary * "").should eq("123")
    (ary * ",").should eq("1,2,3")
  end

  it "cross-multiplies correctly" do
    ary = [0,1]

    (ary * []).should eq([])
    (ary * [0]).should eq([[0,0],[1,0]])
    (ary * ary).should eq([[0,0],[0,1],[1,0],[1,1]])
    (ary * [0,1,2]).should eq([[0,0],[0,1],[0,2],[1,0],[1,1],[1,2]])
  end
end

#
# Array#**
#
describe Array, "#**" do
  it "remains unchanged" do
    ary = [0,1]
    val = ary ** 2
    ary.should eq([0,1])
    (val.hash == ary.hash).should be_false
  end

  it "multiplies correctly" do
    ary = [0,1]
    (ary ** -1).should eq([])
    (ary ** 0).should eq([])
    (ary ** 1).should eq([[0],[1]])
    (ary ** 2).should eq([[0,0],[0,1],[1,0],[1,1]])
    (ary ** 3).should eq([[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]])
  end
end

#
# Array#uniq_by
#
describe Array, "#uniq_by" do
  it "remains unchanged" do
    ary = [0,0]
    val = ary.uniq_by { |i| i }
    ary.should eq([0,0])
    (val.hash == ary.hash).should be_false
  end

  it "filters by the return value of the block" do
    ary = [0,1]
    val = ary.uniq_by { |i| true }
    val.should eq([0])
  end
end

#
# Array#unanimous?
#
describe Array, "#unanimous?" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#to_h
#
describe Array, "#to_h" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#map_to_h
#
describe Array, "#map_to_h" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#chunk
#
describe Array, "#chunk" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#not_empty?
#
describe Array, "#not_empty?" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#sum
#
describe Array, "#sum" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#product
#
describe Array, "#product" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#squares
#
describe Array, "#squares" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#ranks
#
describe Array, "#ranks" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#sqrts
#
describe Array, "#sqrts" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#mean
#
describe Array, "#mean" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#frequencies
#
describe Array, "#frequencies" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#variance
#
describe Array, "#variance" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#std_dev
#
describe Array, "#std_dev" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#median
#
describe Array, "#median" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#first_quartile
#
describe Array, "#first_quartile" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#last_quartile
#
describe Array, "#last_quartile" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#quartiles
#
describe Array, "#quartiles" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#interquartile_range
#
describe Array, "#interquartile_range" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#modes
#
describe Array, "#modes" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#midrange
#
describe Array, "#midrange" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Array#statistical_range
#
describe Array, "#statistical_range" do
  it "remains unchanged" do
    # TODO
  end
end
