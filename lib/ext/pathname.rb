require 'pathname'

class Pathname
  # Cross-platform way of finding an executable in the $PATH.
  #
  #   Pathname.which('ruby') #=> /usr/bin/ruby
  def self.which(cmd)
    paths = ENV['PATH'].split(File::PATH_SEPARATOR).uniq
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    names = exts.map { |ext| "#{cmd}#{ext}" }
    return do_search(paths, *names) { |f| f.executable? }
  end

  def self.library(lib)
    paths = [
      '/usr/local/lib64',
      '/usr/local/lib',
      '/usr/local/libdata',
      '/opt/local/lib',
      '/usr/lib64',
      '/usr/lib',
      '/usr/X11/lib',
      '/usr/share',
    ].uniq
    names = [lib, "#{lib}.so", "lib#{lib}", "lib#{lib}.so"]

    if detect_os[:platform] == "windows"
      names = [
        lib, "#{lib}.dll", "#{lib}.dll.a",
        "lib#{lib}", "lib#{lib}.dll", "lib#{lib}.dll.a"
      ]
      paths = [
        calling_method_dirname,
        Dir.pwd,
        File.join(ENV["SystemRoot"], "system"),
        File.join(ENV["SystemRoot"], "system32"),
        ENV["SystemRoot"],
      ].compact.uniq
      paths |= ENV['PATH'].split(File::PATH_SEPARATOR).uniq
    end

    return do_search(paths, *names) { |f| f.readable? && f.file? }
  end

  def self.header(hdr)
    paths = [
      "/usr/local/include",
      "/opt/include",
      "/usr/include",
      RbConfig::CONFIG["includedir"],
      RbConfig::CONFIG["oldincludedir"],
    ].compact.uniq
    names = [hdr, hdr + ".h", hdr + ".hpp"]
    return do_search(paths, *names) { |f| f.readable? && f.file? }
  end

  def self.join(*paths)
    new(File.join(*paths))
  end

  def to_file(*args, &block)
    File.open(to_s, *args, &block)
  end

  def to_dir(*args, &block)
    Dir.new(to_s, *args, &block)
  end

=begin
  def to_object(*args, &block)
    if socket?
      if defined?(::UNIXSocket)
        ::UNIXSocket.new(path)
      else
        :socket
      end
    elsif symlink?
      link = Pathname.new(File.readlink(name))
      link = Pathname.join(File.dirname(to_s), link) if link !~ /\A#{SEPARATOR}/
#      {:symlink => classify_file(link)}
      link.to_object(*args, &block)
    elsif directory?
      (readable?) ? Dir.new(to_s, *args, &block) : :unreadable_directory
    elsif file?
      (readable?) ? File.open(to_s, *args, &block) : :unreadable_file
    elsif blockdev?
      :block_device
    elsif chardev?
      :char_device
    end
  rescue Errno::ECONNREFUSED
    :unreadable_socket
  rescue Errno::EPROTOTYPE
    :socket
  rescue Errno::EACCES
    :unreadable_item
  end
=end
  alias_method :exists?, :exist?

  private

  def self.do_search(paths, *try_names, &block)
    try_names.flatten!
    paths.each do |path|
      pn = Pathname.new(path)
      try_names.each do |name|
        file = pn + name
        return file if yield(file)
      end
    end
    nil
  end
end
