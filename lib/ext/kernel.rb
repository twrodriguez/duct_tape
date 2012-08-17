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

  def type_assert(var, *klasses)
    klasses.each { |k| return if var.is_a?(k) }
    raise TypeError, "can't convert #{var.inspect}:#{var.class} into #{klasses.join(' or ')}", caller
  end

  alias_method :silence_warnings, :disable_warnings

  # Detect the OS we're running on.
  def detect_os
    @@os_features ||= nil
    return @@os_features if @@os_features
    @@os_features ||= {}

    # Processor Architecture Miner
    proc_arch_miner = lambda do |stderr_redirect|
      stderr_redirect ||= "2> /dev/null"
      cmds = [
        %+arch %s+,
        %+lscpu %s | grep -i "Architecture" | awk '{print $2}'+,
        %+uname -p %s+,
#        %+systeminfo %s | findstr /B /C:"System Type:"+,
        %+reg query "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Environment" %s+
      ]
      arch_str = nil
      cmds.each do |cmd|
        begin
          arch_str = case `#{cmd % stderr_redirect}`.strip.downcase
            when /sparc/;                "sparc"
            when /ppc|powerpc/;          "powerpc"
            when /ia64/;                 "ia64"
            when /ia32/;                 "ia32"
            when /(x|x?(?:86_)|amd)64/;  "x86_64"
            when /(i[3-6]?|x)86/;        "i386"
            when /arm/;                  "arm"
          end
          break if arch_str
        rescue Errno::ENOENT => e
        end
      end
      arch_str
    end

    # Processor (core) Count Miner
    proc_count_miner = lambda do |stderr_redirect|
      stderr_redirect ||= "2> /dev/null"
      cmds = [
        %+cat /proc/cpuinfo %s | grep processor | wc -l+,
        %+lscpu %s | grep -i "^CPU(s):" | awk '{print $2}'+,
        %+sysctl -a %s | egrep -i "hw.ncpu" | awk '{print $2}'+, # FreeBSD
        %+psrinfo %s | wc -l+, # Solaris
        %+reg query "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Environment" %s | findstr /C:"NUMBER_OF_PROCESSORS"+
      ]
      n_cpus = 0
      cmds.each do |cmd|
        begin
          n_cpus = `#{cmd % stderr_redirect}`.strip.match(/\d+$/)[0].to_i
          break if n_cpus > 0
        rescue Errno::ENOENT, NoMethodError
        end
      end
      n_cpus
    end

    # Mac Miner
    mac_miner = lambda do
      version = `sw_vers -productVersion`.match(/\d+\.\d+\.\d+/)[0]
      @@os_features.merge!({
        :platform => "darwin",
        :distro => "Mac OSX",
        :version => version,
        :nickname => case version
          when /^10.0/; "Cheetah"
          when /^10.1/; "Puma"
          when /^10.2/; "Jaguar"
          when /^10.3/; "Panther"
          when /^10.4/; "Tiger"
          when /^10.5/; "Leopard"
          when /^10.6/; "Snow Leopard"
          when /^10.7/; "Lion"
          when /^10.8/; "Mountain Lion"
          else; "Unknown Version of OSX"
        end,
        :install_method => "install",
        :hostname => `hostname`.chomp,
        :arch => proc_arch_miner["2> /dev/null"],
        :n_cpus => proc_count_miner["2> /dev/null"],
      })
      if `which brew 2> /dev/null`.chomp.empty?
        @@os_features[:install_cmd] = "brew install"
      elsif `which port 2> /dev/null`.chomp.empty?
        @@os_features[:install_cmd] = "port install"
      else
        @@os_features[:install_method] = "build"
      end
    end

    # Linux Miner
    linux_miner = lambda do
      # Ensure LSB is installed
      if `which lsb_release 2> /dev/null`.chomp.empty?
        pkg_mgrs = {
          "apt-get" => "install -y lsb",                # Debian/Ubuntu/Linux Mint
          "yum" => "install -y lsb",                    # CentOS/Fedora
          "up2date" => "-i lsb",                        # RHEL
          "zypper" => "--non-interactive install lsb",  # OpenSUSE/SLES
          "pacman" => "-S --noconfirm lsb",             # ArchLinux
          "slackpkg" => "install --yes lsb",            # Slackware
          "urpmi" => "--auto lsb-release",              # Mandriva
          "emerge" => "lsb_release",                    # Gentoo
        }
        ret = false
        pkg_mgrs.each do |mgr,args|
          unless `which #{mgr} 2> /dev/null`.chomp.empty?
            ret = system("sudo #{mgr} #{args}")
            break
          end
        end
        unless ret
          STDERR.puts "Unknown Package manager in use (what ARE you using??)"
        end
      end

      arch_family = proc_arch_miner["2> /dev/null"]
      install_method = "install"
      version = `lsb_release -r 2> /dev/null | awk '{print $2}'`.chomp
      major_release = version.to_i
      nickname = `lsb_release -c 2> /dev/null | awk '{print $2}'`.chomp
      pkg_arch = arch_family
      lsb_release_output = `lsb_release -a 2> /dev/null`.chomp
      distro, pkg_fmt, install, local_install = case lsb_release_output
        when /(debian|ubuntu|mint)/i
          pkg_arch = "amd64" if arch_family == "x86_64"
          [$1, "deb", "apt-get install -y", "dpkg -i"]
        when /(centos|fedora)/i
          [$1, "rpm", "yum install -y", "yum localinstall -y"]
        when /redhat|rhel/i
          ["RHEL", "rpm", "up2date -i", "rpm -Uvh"]
        when /open\s*suse/i
          ["OpenSUSE", "rpm", "zypper --non-interactive install", "rpm -Uvh"]
        when /suse.*enterprise/i
          ["SLES", "rpm", "zypper --non-interactive install", "rpm -Uvh"]
        when /arch/i
          ["ArchLinux", "pkg.tar.xz", "pacman -S --noconfirm", "pacman -U --noconfirm"]
        when /slack/i
          ["Slackware", (major_release < 13 ? "tgz" : "txz"), "slackpkg install --yes", "installpkg"]
        when /mandriva/i
          ["Mandriva", "rpm", "urpmi --auto ", "urpmi --auto"]
        when /gentoo/i
          ["Gentoo", "tgz", "emerge", ""]
        else
          install_method = "build"
          [`lsb_release -d 2> /dev/null`]
      end
      ret = {
        :platform => "linux",
        :distro => distro,
        :pkg_format => pkg_fmt,
        :pkg_arch => pkg_arch,
        :version => version,
        :install_method => install_method,
        :install_cmd => install,
        :local_install_cmd => local_install,
        :nickname => nickname,
        :hostname => `hostname`.chomp,
        :arch => arch_family,
        :n_cpus => proc_count_miner["2> /dev/null"],
      }
      ret.reject! { |k,v| v.nil? }
      @@os_features.merge!(ret)
    end

    # Solaris Miner
    solaris_miner = lambda do
      version = `uname -r`.strip
      distro = `uname -a`.match(/(open\s*)?(solaris)/i)[1..-1].compact.map { |s| s.capitalize }.join
      @@os_features.merge!({
        :platform => "solaris",
        :distro => distro,
        :version => version,
        :install_method => "install",
        :install_cmd => "pkg_add -r",
        :nickname => version,
        :hostname => `hostname`.chomp,
        :arch => proc_arch_miner["2> /dev/null"],
        :n_cpus => proc_count_miner["2> /dev/null"],
      })
    end

    # FreeBSD Miner
    freebsd_miner = lambda do
      version = `uname -r`.strip
      @@os_features.merge!({
        :platform => "bsd",
        :distro => "FreeBSD",
        :version => version,
        :install_method => "install",
        :install_cmd => "pkg_add -r",
        :nickname => version,
        :hostname => `hostname`.chomp,
        :arch => proc_arch_miner["2> /dev/null"],
        :n_cpus => proc_count_miner["2> /dev/null"],
      })
    end

    # Windows Miner
    windows_miner = lambda do
      sysinfo = `reg query "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion"`.chomp

      hostname = `reg query "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\ComputerName\\ComputerName"`.chomp
      hostname = hostname.match(/^\s*ComputerName\s+\w+\s+(.*)/i)[1].strip

      version = sysinfo.match(/^\s*CurrentVersion\s+\w+\s+(.*)/i)[1].strip << "."
      version << sysinfo.match(/^\s*CurrentBuildNumber\s+\w+\s+(.*)/i)[1].strip

      nickname = sysinfo.match(/^\s*ProductName\s+\w+\s+(.*)/i)[1].strip
      nickname = "Microsoft #{nickname}" unless nickname =~ /^Microsoft/

      try_boot_ini = `type C:\\boot.ini 2> nul | findstr /C:"WINDOWS="`.chomp
      unless try_boot_ini.empty?
        nickname = try_boot_ini.match(/WINDOWS="([^"]+)"/i)[1].strip
      end
      @@os_features.merge!({
        :distro => nickname.split(/\s+/).reject { |s| s =~ /microsoft|windows/i }.join(" "),
        :hostname => hostname,
        :nickname => nickname,
        :version => version,
        :platform => "windows",
        :install_method => "install",
        :install_cmd => "install",
        :arch => proc_arch_miner["2> nul"],
        :n_cpus => proc_count_miner["2> nul"],
      })
    end

    case ::RbConfig::CONFIG['host_os'].downcase
    when /darwin/;      mac_miner[]
    when /mswin|mingw/; windows_miner[]
    when /linux/;       linux_miner[]
    when /freebsd/;     freebsd_miner[]
    when /solaris/;     solaris_miner[]
    else
      case `uname -s`.chomp.downcase
      when /linux/;     linux_miner[]
      when /darwin/;    mac_miner[]
      when /solaris/;   solaris_miner[]
      when /freebsd/;   freebsd_miner[]
      end
    end

    @@os_features.freeze
  end

  # Detect the interpreter we're running on.
  def detect_interpreter
    @@interpreter ||= nil
    return @@interpreter if @@interpreter

    var = ""
    if ::Object::const_defined?("RUBY_ENGINE")
      var = ::Object::RUBY_ENGINE.downcase
    else
      var = ::RbConfig::CONFIG['RUBY_INSTALL_NAME'].downcase
    end
    # TODO - MacRuby
    @@interpreter = case var
      when /jruby/;     "jruby"
      when /rbx/;       "rubinius"
      when /maglev/;    "maglev"
      when /ir/;        "ironruby"
      when /ruby/
        if GC.respond_to?(:copy_on_write_friendly=) && RUBY_VERSION < "1.9"
                        "rubyee"
        elsif var.respond_to?(:shortest_abbreviation) && RUBY_VERSION >= "1.9"
                        "goruby"
        else
                        "mri"
        end
      else; nil
    end
  end

  # Detect the Language we're running on.
  def detect_interpreter_language
    case detect_interpreter
    when "jruby";             "java"
    when "rubinius";          "c++"
    when "maglev";            "smalltalk"
    when "ironruby";          ".net"
    when /rubyee|goruby|mri/; "c"
    end
  end

  # Detect the most likely candidate for a public-facing IPv4 Address
  def detect_reachable_ip
    if detect_os[:platform] == "windows"
      output = `ipconfig`
      ip_regex = /IP(?:v4)?.*?([0-9]+(?:\.[0-9]+){3})/i
      gateway_regex = /Gateway[^0-9]*([0-9]+(?:\.[0-9]+){3})?/i
      ip_matches = output.split(/\n/).select { |s| s =~ ip_regex }
      gateway_matches = output.split(/\n/).select { |s| s =~ gateway_regex }
      possible_ips = ip_matches.zip(gateway_matches)
      possible_ips.map! do |ip,gateway|
        [ip.match(ip_regex)[1], gateway.match(gateway_regex)[1]]
      end
      possible_ips.reject! { |ip,gateway| ip == "127.0.0.1" || gateway.nil? }
      return possible_ips[0][0]
    elsif ENV['SSH_CONNECTION']
      return ENV['SSH_CONNECTION'].split(/\s+/)[-2]
    else
      possible_ips = `ifconfig | grep -o "inet \\(addr:\\)\\?[0-9\\.]*" | grep -o "[0-9\\.]*$"`.split(/\n/)
      possible_ips.reject! { |ip| ip == "127.0.0.1" }
      return possible_ips.first
    end
  end

  # Probe the platform for information
  def detect_platform
    @@platform_features ||= {
      :interpreter => detect_interpreter,
      :interpreter_language => detect_interpreter_language,
      :ip => detect_reachable_ip
    }.merge(detect_os)
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
