require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# String#uncolorize
#
describe String, "#uncolorize" do
  it "should have the method defined" do
    expect(String.method_defined?(:uncolorize)).to be(true)
  end

  pending "More tests"
end

#
# String#colorized?
#
describe String, "#colorized?" do
  it "should have the method defined" do
    expect(String.method_defined?(:colorized?)).to be(true)
  end

  pending "More tests"
end

#
# String#word_wrap
#
describe String, "#word_wrap" do
  it "should have the method defined" do
    expect(String.method_defined?(:word_wrap)).to be(true)
  end

  pending "More tests"
end

#
# String#word_wrap!
#
describe String, "#word_wrap!" do
  it "should have the method defined" do
    expect(String.method_defined?(:word_wrap!)).to be(true)
  end

  pending "More tests"
end

#
# String#chunk
#
describe String, "#chunk" do
  it "should have the method defined" do
    expect(String.method_defined?(:chunk)).to be(true)
  end

  pending "More tests"
end

#
# String#%
#
describe String, "#%" do
  it "should have the method defined" do
    expect(String.method_defined?(:%)).to be(true)
  end

  pending "More tests"
end

#
# String#to_date
#
describe String, "#to_date" do
  it "should have the method defined" do
    expect(String.method_defined?(:to_date)).to be(true)
  end

  pending "More tests"
end

#
# String#to_time
#
describe String, "#to_time" do
  it "should have the method defined" do
    expect(String.method_defined?(:to_time)).to be(true)
  end

  pending "More tests"
end

#
# String#to_const
#
describe String, "#to_const" do
  it "should have the method defined" do
    expect(String.method_defined?(:to_const)).to be(true)
  end

  pending "More tests"
end
