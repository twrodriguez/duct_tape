require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Numeric#units
#
describe Numeric, "units" do
  it "chronological sizes" do
    3.years.should eq(3*365*24*60*60)
    3.weeks.should eq(3*7*24*60*60)
    3.days.should eq(3*24*60*60)
    3.hours.should eq(3*60*60)
    3.minutes.should eq(3*60)
    3.mseconds.should eq(3 / 1000.0)
    3.useconds.should eq(3 / 1000000.0)
  end

  it "byte sizes" do
    3.eb.should eq(3*(2**60))
    3.pb.should eq(3*(2**50))
    3.tb.should eq(3*(2**40))
    3.gb.should eq(3*(2**30))
    3.mb.should eq(3*(2**20))
    3.kb.should eq(3*(2**10))
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
