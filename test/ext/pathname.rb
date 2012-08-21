#
# Pathname.which
#
describe Pathname, ".which" do
  it "finds executables correctly" do
    %w{which}.each do |cmd|
      pname = Pathname.which(cmd)
      pname.to_s.should eq(`which #{cmd}`.chomp)
    end
  end
end
