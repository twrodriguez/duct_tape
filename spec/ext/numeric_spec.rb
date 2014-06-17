require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Numeric#units
#
describe Numeric, "units" do
  it "chronological sizes" do
    expect(3.years).to eq(3*365*24*60*60)
    expect(3.weeks).to eq(3*7*24*60*60)
    expect(3.days).to eq(3*24*60*60)
    expect(3.hours).to eq(3*60*60)
    expect(3.minutes).to eq(3*60)
    expect(3.mseconds).to eq(3 / 1000.0)
    expect(3.useconds).to eq(3 / 1000000.0)
  end

  it "byte sizes" do
    expect(3.eb).to eq(3*(2**60))
    expect(3.pb).to eq(3*(2**50))
    expect(3.tb).to eq(3*(2**40))
    expect(3.gb).to eq(3*(2**30))
    expect(3.mb).to eq(3*(2**20))
    expect(3.kb).to eq(3*(2**10))
  end
end

#
# Numeric#to_degrees
#
describe Numeric, "#to_degrees" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Numeric#to_radians
#
describe Numeric, "#to_radians" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Numeric#rank
#
describe Numeric, "#rank" do
  it "remains unchanged" do
    # TODO
  end
end

#
# Numeric#percentage_of
#
describe Numeric, "#percentage_of" do
  it "remains unchanged" do
    # TODO
  end
end
