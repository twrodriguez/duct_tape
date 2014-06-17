require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Array#deep_merge
#
describe Array, "#deep_merge" do
  it "remains unchanged" do
    ary = [1,2,3,4,5]
    ary.deep_merge([6,7,8])
    expect(ary).to eq([1,2,3,4,5])
  end

  it "merges flat arrays properly" do
    ary = [1,2,3,4,5]
    val = ary.deep_merge([4,5,6])
    expect(val).to eq([1,2,3,4,5,6])
    expect((val.__id__ == ary.__id__)).to be_false
  end

  it "merges nested arrays properly" do
    ary = [1,2,[3,4,5]]
    val = ary.deep_merge([3,4,[5,6,7]])
    expect(val).to eq([1,2,[3,4,5,6,7],3,4])
    expect((val.__id__ == ary.__id__)).to be_false
  end
end

#
# Array#deep_merge!
#
describe Array, "#deep_merge!" do
  it "changes" do
    ary = [1,2,3,4,5]
    val = ary.deep_merge!([6,7,8])
    expect(ary).to eq([1,2,3,4,5,6,7,8])
    expect((val.__id__ == ary.__id__)).to be_true
  end

  it "returns nil if nothing was changed" do
    ary = [1,2,3,4,5]
    val = ary.deep_merge!([4,5])
    expect(val).to be_nil
  end

  it "returns self if it changed" do
    ary = [1,2,3,4,5]
    val = ary.deep_merge!([4,5,6])
    expect(val).to eq([1,2,3,4,5,6])
    expect((val.__id__ == ary.__id__)).to be_true
  end

  it "merges flat arrays properly" do
    ary = [1,2,3,4,5]
    ary.deep_merge!([4,5,6])
    expect(ary).to eq([1,2,3,4,5,6])
  end

  it "merges nested arrays properly" do
    ary = [1,2,[3,4,5]]
    ary.deep_merge!([3,4,[5,6,7]])
    expect(ary).to eq([1,2,[3,4,5,6,7],3,4])
  end
end

#
# Array#*
#
describe Array, "#*" do
  it "remains unchanged" do
    ary = [1,2,3]
    val1 = ary * 2; val2 = ary * ","; val3 = ary * ary
    expect(ary).to eq([1,2,3])
    expect((val1.__id__ == ary.__id__)).to be_false
    expect((val2.__id__ == ary.__id__)).to be_false
    expect((val3.__id__ == ary.__id__)).to be_false
  end

  it "concats correctly" do
    ary = [1,2,3]

    expect((ary * 0)).to eq([])
    expect((ary * 1)).to eq([1,2,3])
    expect((ary * 2)).to eq([1,2,3,1,2,3])
  end

  it "joins correctly" do
    ary = [1,2,3]

    expect((ary * "")).to eq("123")
    expect((ary * ",")).to eq("1,2,3")
  end

  it "cross-multiplies correctly" do
    ary = [0,1]

    expect((ary * [])).to eq([])
    expect((ary * [0])).to eq([[0,0],[1,0]])
    expect((ary * ary)).to eq([[0,0],[0,1],[1,0],[1,1]])
    expect((ary * [0,1,2])).to eq([[0,0],[0,1],[0,2],[1,0],[1,1],[1,2]])
  end
end

#
# Array#**
#
describe Array, "#**" do
  it "remains unchanged" do
    ary = [0,1]
    val = ary ** 2
    expect(ary).to eq([0,1])
    expect((val.__id__ == ary.__id__)).to be_false
  end

  it "multiplies correctly" do
    ary = [0,1]
    expect((ary ** -1)).to eq([])
    expect((ary ** 0)).to eq([])
    expect((ary ** 1)).to eq([[0],[1]])
    expect((ary ** 2)).to eq([[0,0],[0,1],[1,0],[1,1]])
    expect((ary ** 3)).to eq([[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]])
  end
end

#
# Array#uniq_by
#
describe Array, "#uniq_by" do
  it "remains unchanged" do
    ary = [0,0]
    val = ary.uniq_by { |i| i }
    expect(ary).to eq([0,0])
    expect((val.__id__ == ary.__id__)).to be_false
  end

  it "filters by the return value of the block" do
    ary = [0,1]
    val = ary.uniq_by { |i| true }
    expect(val).to eq([0])
  end
end

#
# Array#unanimous?
#
describe Array, "#unanimous?" do
  it "remains unchanged" do
    ary = [0,0]
    val = ary.unanimous?
    expect(ary).to eq([0,0])
    expect((val.__id__ == ary.__id__)).to be_false
  end

  it "returns true and false with no argument and no block" do
    expect([0,0].unanimous?).to be_true
    expect([0,1].unanimous?).to be_false
  end

  it "returns true and false with an argument and no block" do
    expect([0,0].unanimous?(0)).to be_true
    expect([0,0].unanimous?(1)).to be_false
  end

  it "returns true and false with no argument and with a block" do
    expect([0,0].unanimous? { |i| i == 1 }).to be_true
    expect([0,1].unanimous? { |i| i == 1 }).to be_false
  end

  it "returns true and false with an argument and a block" do
    expect([0,0].unanimous?(false) { |i| i.odd? }).to be_true
    expect([0,0].unanimous?(true) { |i| i.odd? }).to be_false
  end
end

#
# Array#to_h
#
describe Array, "#to_h" do
  it "remains unchanged" do
    ary = [0,0]
    val = ary.to_h
    expect(ary).to eq([0,0])
    expect((val.__id__ == ary.__id__)).to be_false
  end

  it "converts flat arrays" do
    expect(%w{a b c}.to_h).to eq({0=>"a", 1=>"b", 2=>"c"})
    expect(%w{a b}.to_h).to eq({0=>"a", 1=>"b"})
    expect(['a'].to_h).to eq({0=>"a"})
    expect([].to_h).to eq({})
  end

  it "converts an array of pairs" do
    expect([[1,2], [3,4]].to_h).to eq({1=>2, 3=>4})
    expect([[1,2]].to_h).to eq({1=>2})
  end

  it "converts an array of hashes (without conflicts)" do
    expect([{1=>2}, {3=>4}].to_h).to eq({1=>2, 3=>4})
    expect([{1=>2}].to_h).to eq({1=>2})
  end

  it "converts an array of hashes (with conflicts)" do
    expect([{1=>2}, {3=>4, 1=>5}].to_h).to eq({1=>[2,5], 3=>4})
    expect([{1=>2}].to_h).to eq({1=>2})
  end

  it "converts an array of hashes with common name and value keys" do
    ary = [{"name" => 1, "value" => 2}, {"name" => 3, "value" => 4}]
    expect(ary.to_h).to eq({1=>2, 3=>4})

    ary = [{:name => 1, :value => 2}, {:name => 3, :value => 4}]
    expect(ary.to_h).to eq({1=>2, 3=>4})

    ary = [{:x => 1, :y => 2}, {:x => 3, :y => 4}]
    expect(ary.to_h(:x, :y)).to eq({1=>2, 3=>4})

    ary = [{:x => 1, :y => 2}, {:x => 3, :y => 4}]
    expect(ary.to_h("x", "y")).to eq({1=>2, 3=>4})
  end

  it "converts a hash-turned-array back to the original hash" do
    hsh = {1=>{2=>3}}
    val = hsh.to_a.to_h
    expect(hsh).to eq(val)
    expect((val.__id__ == hsh.__id__)).to be_false
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
