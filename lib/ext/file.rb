require 'pathname'

class File

  def self.relative_path(abs_path, pwd=Dir.pwd)
    Dir.relative_path(abs_path, pwd)
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

  def executable?
    File.executable?(self.path)
  end
end
