require 'pathname'

class File
  def self.classify_file(name)
    path = Pathname.new(name).expand_path
    if path.socket?
      if defined?(::UNIXSocket)
        ::UNIXSocket.new(path)
      else
        :socket
      end
    elsif path.symlink?
      link = readlink(name)
      link = File.join(File.dirname(name), link) if link !~ /\A#{SEPARATOR}/
#      {:symlink => classify_file(link)}
      classify_file(link)
    elsif directory?(name)
      readable?(name) ? Dir.new(name) : :unreadable_directory
    elsif file?(name)
      readable?(name) ? (open(name) { |f| f }) : :unreadable_file
    elsif blockdev?(name)
      :block_device
    elsif chardev?(name)
      :char_device
    end
  rescue Errno::ECONNREFUSED
    :unreadable_socket
  rescue Errno::EPROTOTYPE
    :socket
  rescue Errno::EACCES
    :unreadable_item
  end

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
