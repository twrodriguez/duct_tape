require 'pathname'

class Pathname
  # Cross-platform way of finding an executable in the $PATH.
  #
  #   Pathname.which('ruby') #=> /usr/bin/ruby
  def self.which(cmd)
    paths = ENV['PATH'].split(File::PATH_SEPARATOR).uniq
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    names = form_name_list(cmd, {:extensions => exts})
    return do_search(paths, *names) { |f| f.executable? }
  end

  def self.library(lib)
    paths = [
      '/usr/local/lib64',
      '/usr/local/lib',
      '/usr/local/libdata',
      '/opt/local/lib',
      '/usr/lib/x86_64-linux-gnu',
      '/usr/lib64',
      '/usr/lib',
      '/usr/X11/lib',
      '/usr/share',
    ]
    prefixes = [
      "lib"
    ]
    extensions = [
      "",
      ".so"
    ]

    if detect_os[:platform] == "windows"
      extensions = [
        "",
        ".dll",
        ".dll.a"
      ]
      paths = [
        calling_method_dirname,
        Dir.pwd,
        File.join(ENV["SystemRoot"], "system"),
        File.join(ENV["SystemRoot"], "system32"),
        ENV["SystemRoot"],
      ].compact.uniq
      paths |= ENV['PATH'].split(File::PATH_SEPARATOR).uniq
    elsif detect_os[:platform] == "darwin"
      extensions << ".dylib"
    end
    names = form_name_list(lib, {:prefixes => prefixes, :extensions => extensions})

    return do_search(paths, *names) do |f|
      f.readable? && f.file? && extensions.any? { |ext| f =~ %r{#{Regexp.escape(ext)}\z} }
    end
  end

  def self.header(hdr)
    paths = [
      "/usr/local/include",
      "/opt/include",
      "/usr/include",
      RbConfig::CONFIG["includedir"],
      RbConfig::CONFIG["oldincludedir"],
    ].compact.uniq
    extensions = [
      ".h",
      ".hh",
      ".hxx",
      ".hpp"
    ]
    names = form_name_list(hdr, {:extensions => extensions})
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

  def self.form_name_list(name, opts={})
    exts = opts[:exts] || opts[:extensions] || []
    pfxs = opts[:pfxs] || opts[:prefixes] || []
    exts.delete("")
    pfxs.delete("")
    exts.unshift("")
    pfxs.unshift("")

    ret = []
    (pfxs * exts).each { |pfx,ext| ret << [pfx, name, ext].join("") }
    ret
  end
  private_class_method :form_name_list

  def self.do_search(paths, *try_names, &block)
    try_names.flatten!
    paths.each do |path|
      pn = Pathname.new(path)
      # Handle globs
      globbed = try_names.map do |name|
        if name["*"]
          Dir.glob(pn + name)
        else
          name
        end
      end
      globbed.flatten!
      globbed.each do |name|
        file = pn + name
        return file if yield(file)
      end
    end
    nil
  end
  private_class_method :do_search
end
