module Kernel
  private

  def this_method
    (caller[0..-1].detect { |c| c =~ /`([^']*)'/ } && $1).to_sym
  rescue NoMethodError
    nil
  end

  def calling_method
    (caller[1..-1].detect { |c| c =~ /`([^']*)'/ } && $1).to_sym
  rescue NoMethodError
    nil
  end

  def tty?
    # TODO For win32: GetUserObjectInformation
    # TODO For .Net: System.Environment.UserInteractive
    $stdout.isatty && ((ENV["COLUMNS"] || `stty size 2>&1`.chomp.split(/ /).last).to_i > 0)
  end

  def tty_width
    (tty? ? (ENV["COLUMNS"] || `stty size`.chomp.split(/ /).last).to_i : nil)
  end

  def assert_tty
    raise "FATAL: This `#{calling_method}' requires an interactive tty" unless tty?
  end

  def not_implemented(message=nil)
    raise NotImplementedError.new("Method `#{calling_method}' has not been implemented")
  end

  def automatic_require(full_path, progress=nil)
    some_not_included = true
    files = Dir[File.join(File.expand_path(full_path), "**", "*.rb")]
    retry_loop = 0
    last_err = nil
    while some_not_included and retry_loop <= (files.size ** 2) do
      begin
        some_not_included = false
        for f in files do
          val = require f
          some_not_included ||= val
        end
      rescue NameError => e
        last_err = e
        raise unless "#{e}" =~ /uninitialized constant/i
        some_not_included = true
        files.push(files.shift)
      end
      retry_loop += 1
    end
    if some_not_included
      warn "Couldn't auto-include all files in #{File.expand_path(full_path)}"
      warn "#{last_err}"
      raise last_err
    end
  end

  def type_assert(var, klass, *classes)
    classes = [klass, *classes]
    classes.each do |c|
      unless c.is_a?(Class) or c.is_a?(Module)
        raise TypeError.new("can't convert #{c} into Class or Module")
      end
    end
    unless classes.reduce(false) { |b,c| b || var.is_a?(c) }
      list = ""
      if classes.size > 1
        list = "#{classes[0...-1].join(", ")} or #{classes[-1]}"
      elsif classes.size == 1
        list = "#{classes[0]}"
      else
        raise ArgumentError.new("no Class or Module passed")
      end
      te = TypeError.new("can't convert #{var.inspect}:#{var.class} into #{list}")
      te.set_backtrace(caller)
      raise te
    end
  end

  alias_method :silence_warnings, :disable_warnings

  # Detect the platform we're running on.
  def detect_platform
    case RUBY_PLATFORM.downcase
    when /darwin/; :mac
    when /mswin/;  :windows
    when /linux/;  :linux
    else;          :unknown
    end
  end
end
