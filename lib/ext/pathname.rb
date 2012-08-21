require 'pathname'

class Pathname
  # Cross-platform way of finding an executable in the $PATH.
  #
  #   Pathname.which('ruby') #=> /usr/bin/ruby
  def self.which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      pathname = Pathname.new(path)
      exts.each do |ext|
        exe = pathname + "#{cmd}#{ext}"
        return exe if exe.executable?
      end
    end
    return nil
  end

  def self.join(*paths)
    new(File.join(*paths))
  end
end
