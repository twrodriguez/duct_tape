class Dir
  # Given an absolute path, determine the relative path based on pwd
  def self.relative_path(abs_path)
    abs_path = absolute_path(abs_path)
    ary1 = abs_path.split(File::SEPARATOR)
    ary2 = Dir.pwd.split(File::SEPARATOR)
    pairs = (ary2 + ([nil] * (ary1.size - ary2.size))).zip(ary1)
    common = pairs.take_while { |a,b| a == b }.map { |a,b| a }
    pairs.reject! { |a,b| a == b }
    path_ary = pairs.map { |p,a| p ? ".." : nil }.compact
    if path_ary.empty? || path_ary.include?("..")
      path_ary += ary1.zip(common).drop_while { |a,b| a == b }.map { |a,b| a }
    end
    File.join(*path_ary)
  end

  def self.absolute_path(path)
    File.expand_path(path) == path ? path : File.expand_path(path)
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
    entries.map_to_h do |name|
      name = File.join(absolute_path, name)
      if File.file?(name)
        File.new(name)
      elsif File.directory?(name)
        Dir.new(name)
      elsif File.socket?(name)
        :socket
      elsif File.symlink?(name)
        {:symlink => File.readlink(name)} # TODO - follow symlinks
      end
    end
  end

  def /(path)
    path_ary = path.split(File::SEPARATOR)
    if ret = children[path_ary[0]]
      if path_ary.size > 1
        if ret.is_a?(Dir)
          return ret / File.join(*path_ary[1..-1])
        end
      else
        return ret
      end
    end
    nil
  end

  def files
    children.reject { |k,v| !(File === v) }.values
  end

  def directories
    children.reject { |k,v| !(Dir === v) }.values
  end
end
