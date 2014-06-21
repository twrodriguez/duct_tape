require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

#
# Kernel#this_method
#
describe Kernel, "#this_method" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:this_method)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#calling_method
#
describe Kernel, "#calling_method" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:calling_method)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#calling_method_file
#
describe Kernel, "#calling_method_file" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:calling_method_file)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#calling_method_dirname
#
describe Kernel, "#calling_method_dirname" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:calling_method_dirname)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#tty?
#
describe Kernel, "#tty?" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:tty?)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#tty_width
#
describe Kernel, "#tty_width" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:tty_width)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#not_implemented
#
describe Kernel, "#not_implemented" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:not_implemented)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#automatic_require
#
describe Kernel, "#automatic_require" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:automatic_require)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#type_assert
#
describe Kernel, "#type_assert" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:type_assert)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#detect_os
#
describe Kernel, "#detect_os" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:detect_os)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#detect_hardware
#
describe Kernel, "#detect_hardware" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:detect_hardware)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#detect_interpreter
#
describe Kernel, "#detect_interpreter" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:detect_interpreter)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#detect_interpreter_language
#
describe Kernel, "#detect_interpreter_language" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:detect_interpreter_language)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#detect_reachable_ip
#
describe Kernel, "#detect_reachable_ip" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:detect_reachable_ip)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#detect_platform
#
describe Kernel, "#detect_platform" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:detect_platform)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#required_if_used
#
describe Kernel, "#required_if_used" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:required_if_used)).to be(true)
  end

  pending "More tests"
end

#
# Kernel#gem_installed?
#
describe Kernel, "#gem_installed?" do
  it "should have the method defined" do
    expect(Kernel.private_method_defined?(:gem_installed?)).to be(true)
  end

  pending "More tests"
end
