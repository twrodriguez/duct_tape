require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Pathname.which
#
describe Pathname, ".which" do
  it "finds executables correctly" do
    %w{which}.each do |cmd|
      pname = Pathname.which(cmd)
      expect(pname.to_s).to eq(`which #{cmd}`.chomp)
    end
  end
end

#
# Pathname.library
#
describe Pathname, ".library" do
  it "should have the method defined" do
    expect(Pathname.respond_to?(:library)).to be(true)
  end

  pending "More tests"
end

#
# Pathname.header
#
describe Pathname, ".header" do
  it "should have the method defined" do
    expect(Pathname.respond_to?(:header)).to be(true)
  end

  pending "More tests"
end

#
# Pathname.join
#
describe Pathname, ".join" do
  it "should have the method defined" do
    expect(Pathname.respond_to?(:join)).to be(true)
  end

  pending "More tests"
end

#
# Pathname#to_file
#
describe Pathname, "#to_file" do
  it "should have the method defined" do
    expect(Pathname.method_defined?(:to_file)).to be(true)
  end

  pending "More tests"
end

#
# Pathname#to_dir
#
describe Pathname, "#to_dir" do
  it "should have the method defined" do
    expect(Pathname.method_defined?(:to_dir)).to be(true)
  end

  pending "More tests"
end

#
# Pathname#exist?
#
describe Pathname, "#exist?" do
  it "should have the method defined" do
    expect(Pathname.method_defined?(:exist?)).to be(true)
  end

  pending "More tests"
end

#
# Pathname.form_name_list
#
describe Pathname, ".form_name_list" do
  it "should have the method defined" do
    method_name = :form_name_list
    method_name = method_name.to_s if RUBY_VERSION < "1.9"
    expect(Pathname.private_methods.include?(method_name)).to be(true)
  end

  pending "More tests"
end

#
# Pathname.do_search
#
describe Pathname, ".do_search" do
  it "should have the method defined" do
    method_name = :do_search
    method_name = method_name.to_s if RUBY_VERSION < "1.9"
    expect(Pathname.private_methods.include?(method_name)).to be(true)
  end

  pending "More tests"
end
