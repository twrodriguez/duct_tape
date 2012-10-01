require 'pathname'

class Dir
  # Determine the relative path based on pwd
  def self.relative_path(abs_path, from=Dir.pwd)
    Pathname.new(abs_path).expand_path.relative_path_from(Pathname.new(from)).to_s
  end

  def self.absolute_path(path)
    Pathname.new(path).expand_path.to_s
  end

  def self.empty?(dir)
    entries(dir).join == "..."
  end

  def relative_path
    Dir.relative_path(self.path)
  end

  def empty?
    Dir.empty?(self)
  end

  def absolute_path
    Dir.absolute_path(self.path)
  end

  def children
    entries.map_to_h { |name| Pathname.join(absolute_path, name) }
  end
  alias_method :to_h, :children

  def [](*path)
    pathname = Pathname.new(File.join(path.flatten))
    return nil unless pathname.exist?
    pathname
  end

  def /(path)
    self[path]
  end

  def files
    entries.reject { |v| !(File.file?(v)) }
  end

  def directories
    entries.reject { |v| !(File.directory?(v)) }
  end

  def writable?
    File.writable?(self.path)
  end

  def readable?
    File.readable?(self.path)
  end
end
