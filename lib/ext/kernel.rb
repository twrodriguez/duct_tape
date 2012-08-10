require 'rbconfig'

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

  def automatic_require(full_path)
    # TODO - memorize order to make future iterations faster
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
        raise unless "#{e}" =~ /uninitialized constant|undefined method/i
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

  # Detect the OS we're running on.
  def detect_os
    case ::RbConfig::CONFIG['host_os'].downcase
    when /darwin/;      "mac"
    when /mswin|mingw/; "windows"
    when /linux/;       "linux"
    end
  end

  # Detect the interpreter we're running on.
  def detect_interpreter
    var = ""
    if ::Object::const_defined?("RUBY_ENGINE")
      var = ::Object::RUBY_ENGINE.downcase
    else
      var = ::RbConfig::CONFIG['RUBY_INSTALL_NAME'].downcase
    end
    # TODO - MacRuby
    case var
    when /jruby/;     "jruby"
    when /rbx/;       "rubinius"
    when /maglev/;    "maglev"
    when /ir/;        "ironruby"
    when "ruby";
      if GC.respond_to?(:copy_on_write_friendly=) && RUBY_VERSION < "1.9"
                      "ree"
      elsif var.repond_to?(:shortest_abbreviation) && RUBY_VERSION >= "1.9"
                      "goruby"
      else
                      "mri"
      end
    end
  end

  # Detect the Language we're running on.
  def detect_interpreter_language
    case detect_interpreter
    when "jruby";           "java"
    when "rubinius";        "c++"
    when "maglev";          "smalltalk"
    when "ironruby";        ".net"
    when /ree|goruby|mri/;  "c"
    end
  end

  # Detect the most likely candidate for a public-facing IPv4 Address
  def detect_reachable_ip
    if detect_os == "windows"
      output = `ipconfig`
      ip_regex = /IPv4.*?([0-9]+(?:\.[0-9]+){3})/i
      gateway_regex = /Gateway[^0-9]*([0-9]+(?:\.[0-9]+){3})?/i
      possible_ips = output.grep(ip_regex).zip(output.grep(gateway_regex))
      possible_ips.map! do |ip,gateway|
        [ip.match(ip_regex)[1], gateway.match(gateway_regex)[1]]
      end
      possible_ips.reject! { |ip,gateway| ip == "127.0.0.1" || gateway.nil? }
      return possible_ips[0][0]
    elsif ENV['SSH_CONNECTION']
      return ENV['SSH_CONNECTION'].split(/\s+/)[-2]
    else
      possible_ips = `ifconfig | grep -o "inet \(addr:\)\?[0-9\.]*" | grep -o "[0-9\.]*$"`.split(/\n/)
      possible_ips.reject! { |ip| ip == "127.0.0.1" }
      return possible_ips.first
    end
  end

  # Gems that are required only when a module or class is used
  def required_if_used(*args)
    unless @required_gems
      [:included, :extended, :inherited].each do |method_name|
        define_method(method_name) do |klass|
          super if defined?(super)
          @required_gems.each { |gem| require gem.to_s }
        end
      end
    end
    @required_gems ||= []
    @required_gems |= args
  end
end
