class File
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
end
