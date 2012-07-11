class Dir
  # Given an absolute path, determine the relative path based on pwd
  def self.relative_path(abs_path)
    unless File.expand_path(abs_path) == abs_path
      abs_path = File.expand_path("./#{abs_path}")
    end
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

  def self.empty?(dir)
    entries(dir).join == "..."
  end

  def relative_path
    Dir.relative_path(self)
  end

  def empty?
    Dir.empty?(self)
  end
end
