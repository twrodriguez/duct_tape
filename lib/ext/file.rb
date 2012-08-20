class File
  # Cross-platform way of finding an executable in the $PATH.
  #
  #   which('ruby') #=> /usr/bin/ruby
  def self.which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(PATH_SEPARATOR).each do |path|
      exts.each do |ext|
        exe = join(path, "#{cmd}#{ext}")
        return exe if executable?(exe)
      end
    end
    return nil
  end

  # Given an absolute path, determine the relative path based on pwd
  def self.relative_path(abs_path)
    Dir.relative_path(abs_path)
  end

  def self.absolute_path(path)
    Dir.absolute_path(path)
  end

  def relative_path
    Dir.relative_path(self.path)
  end

  def absolute_path
    Dir.absolute_path(self.path)
  end

  def dirname
    File.dirname(self.path)
  end

  def basename(*args)
    File.basename(self.path, *args)
  end

  def writable?
    File.writable?(self.path)
  end

  def readable?
    File.readable?(self.path)
  end
end
