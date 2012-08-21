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
    raise NotImplementedError, "Method `#{calling_method}' has not been implemented", caller[2..-1]
  end

  def automatic_require(full_path=nil)
    some_not_included = true
    arg_passed = !full_path.nil?
    type_assert(full_path, String, Array, nil)

    # Discover filename and directory of function that called automatic_require
    c = caller.first
    caller_dir = Dir.pwd
    caller_file_basename = nil
    if c.rindex(/:\d+(:in `.*')?$/)
      caller_file = $`
      unless /\A\((.*)\)/ =~ caller_file # eval, etc.
        caller_dir = File.dirname(caller_file)
        caller_file_basename = File.basename(caller_file, ".rb")
      end
    end

    # If nothing was passed, use the basename without ".rb" as the require path
    if full_path.nil?
      full_path = Pathname.join([caller_dir, caller_file_basename].compact)
    end

    # Discover files
    files = []
    [*full_path].each do |path|
      try_these = [
        Pathname.new(path),
        Pathname.join([caller_dir, path].compact),
        Pathname.join([caller_dir, caller_file_basename, path].compact)
      ].uniq
      try_these.each do |possibility|
        possibility = possibility.expand_path
        if possibility.exist?
          if possibility.file?
            files |= [possibility.to_s]
          elsif possibility.directory?
            files |= Dir[possibility + "*.rb"]
          end
        end
      end
    end
    if files.empty? && arg_passed
      raise RuntimeError, "No files found to require for #{full_path.inspect}", caller
    end

    # Require files & return the successful order
    successful_require_order = []
    retry_loop = 0
    last_err = nil
    while some_not_included and retry_loop <= (files.size ** 2) do
      begin
        some_not_included = false
        for f in files do
          val = require f
          some_not_included ||= val
          successful_require_order << f if val
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
      warn "Couldn't auto-include all files in #{full_path.inspect}"
      warn "#{last_err}"
      raise last_err
    end
    successful_require_order
  end

  def type_assert(var, *klasses)
    klasses.each { |k| return if k === var }
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
        %<arch %s>, # Linux
        %<lscpu %s | grep -i "Architecture" | awk '{print $2}'>, # Linux Alternative
        %<uname -p %s>, # BSD-like
        %<uname -m %s>, # BSD-like Alternate
        %<reg query "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Environment" %s>, # Windows
        %<sysinfo %s | grep -o "kernel_\\w*">, # Haiku
      ]
      arch_str = nil
      cmds.each do |cmd|
        begin
          arch_str = case `#{cmd % stderr_redirect}`.strip.downcase
            when /sparc|sun4u/;          "sparc"
            when /ppc|powerpc/;          "powerpc"
            when /mips/;                 "mips"
            when /s390/;                 "s390x"
            when /ia64|itanium/;         "itanium"
            when /(x|x?(?:86_)|amd)64/;  "x86_64"
            when /(i[3-6]?|x)86|ia32/;   "i386"
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
        %<cat /proc/cpuinfo %s | grep processor | wc -l>, # Linux
        %<lscpu %s | grep -i "^CPU(s):" | awk '{print $2}'>, # Linux Alternative
        %<sysctl -a %s | egrep -i "hw.ncpu" | awk '{print $2}'>, # FreeBSD
        %<psrinfo %s | wc -l>, # Solaris
        %<reg query "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Environment" %s | findstr /C:"NUMBER_OF_PROCESSORS">, # Windows
        %<sysinfo %s | grep -i "CPU #[0-9]*:" | wc -l>, # Haiku
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

    # Physical Memory Size Miner
    mem_size_miner = lambda do |stderr_redirect|
      stderr_redirect ||= "2> /dev/null"
      cmds = [
        %<free -ob %s | grep "Mem:" | awk '{print $2}'>, # Linux
        %<sysctl -a %s | grep hw.physmem | awk '{print $2}'>, # FreeBSD
        %<sysinfo %s | grep -i "bytes\\s*free" | grep -o "[0-9]*)" | grep -o "[0-9]*">, # Haiku
        %<top -d1 -q %s | grep "Mem" | awk '{print $2}'>, # Solaris
        %<systeminfo %s | findstr /C:"Total Physical Memory">, # Windows
      ]
      mem_size = 0
      cmds.each do |cmd|
        begin
          size = `#{cmd % stderr_redirect}`.strip.gsub(/,/, "")
          if size =~ /Total Physical Memory/
            size = size.strip.split(":")[-1].split.join
          end
          unless size.empty?
            mem_size = size.to_i
            if size =~ /(K|M|G|T|P|E)B?$/i
              case $1.upcase
              when "K"; mem_size *= 1024
              when "M"; mem_size *= 1048576
              when "G"; mem_size *= 1073741824
              when "T"; mem_size *= 1099511627776
              when "P"; mem_size *= 1125899906842624
              when "E"; mem_size *= 1152921504606846976
              end
            end
            break
          end
        rescue Errno::ENOENT, NoMethodError
        end
      end
      mem_size
    end

    # Mac Miner
    mac_miner = lambda do
      version = `sw_vers -productVersion`.match(/\d+\.\d+\.\d+/)[0]
      @@os_features.merge!({
        :platform => "darwin",
        :os_distro => "Mac OSX",
        :os_version => version,
        :os_nickname => case version
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
        :arch => proc_arch_miner[nil],
        :n_cpus => proc_count_miner[nil],
        :ram => mem_size_miner[nil],
      })
      if Pathname.which("brew")
        @@os_features[:install_cmd] = "brew install"
      elsif Pathname.which("port")
        @@os_features[:install_cmd] = "port install"
      else
        @@os_features[:install_method] = "build"
      end
      @@os_features
    end

    # Linux Miner
    linux_miner = lambda do
      # Ensure LSB is installed
      if not Pathname.which("lsb_release")
        pkg_mgrs = {
          "apt-get" => "install -y lsb",                # Debian/Ubuntu/Linux Mint/PCLinuxOS
          "up2date" => "-i lsb",                        # RHEL/Oracle
          "yum" => "install -y lsb",                    # CentOS/Fedora/RHEL/Oracle
          "zypper" => "--non-interactive install lsb",  # OpenSUSE/SLES
          "pacman" => "-S --noconfirm lsb-release",     # ArchLinux
          "urpmi" => "--auto lsb-release",              # Mandriva/Mageia
          "emerge" => "lsb_release",                    # Gentoo
          "slackpkg" => "",                             # Slackware NOTE - doesn't have lsb
        }
        ret = false
        pkg_mgrs.each do |mgr,args|
          if Pathname.which(mgr)
            if mgr == "slackpkg" && File.exists?("/etc/slackware-version")
              ret = true
            else
              ret = system("sudo #{mgr} #{args}")
            end
            break if ret
          end
        end
        unless ret
          $stderr.puts "Unknown Package manager in use (what ARE you using??)"
        end
      end

      arch_family = proc_arch_miner[nil]
      pkg_arch = arch_family
      install_method = "install"
      if File.exists?("/etc/slackware-version") || Pathname.which("slackpkg")
        # Slackware
        nickname = File.read("/etc/slackware-version").strip
        version = nickname.split[1..-1].join(" ")
        major_release = version.to_i
        distro = "Slackware"
        pkg_fmt = major_release < 13 ? "tgz" : "txz"
        install = "slackpkg -batch=on -default_answer=y install"
        local_install = "installpkg"
      elsif File.exists?("/etc/oracle-release") || File.exists?("/etc/enterprise-release")
        if File.exists?("/etc/oracle-release")
          nickname = File.read("/etc/oracle-release").strip
        else
          nickname = File.read("/etc/enterprise-release").strip
        end
        version = nickname.match(/\d+(\.\d+)?/)[0]
        major_release = version.to_i
        distro, pkg_fmt, install, local_install = "Oracle", "rpm", "up2date -i", "rpm -Uvh"
      else
        version = `lsb_release -r 2> /dev/null`.strip.split[1..-1].join(" ")
        major_release = version.to_i
        nickname = `lsb_release -c 2> /dev/null`.strip.split[1..-1].join(" ")
        lsb_release_output = `lsb_release -a 2> /dev/null`.chomp
        distro, pkg_fmt, install, local_install = case lsb_release_output
          when /(debian|ubuntu|mint)/i
            pkg_arch = "amd64" if arch_family == "x86_64"
            [$1, "deb", "apt-get install -y", "dpkg -i"]
          when /(centos|fedora)/i
            [$1, "rpm", "yum install -y", "yum localinstall -y"]
          when /oracle/i
            ["Oracle", "rpm", "up2date -i", "rpm -Uvh"]
          when /redhat|rhel/i
            ["RHEL", "rpm", "up2date -i", "rpm -Uvh"]
          when /open\s*suse/i
            ["OpenSUSE", "rpm", "zypper --non-interactive install", "rpm -Uvh"]
          when /suse.*enterprise/i
            ["SLES", "rpm", "zypper --non-interactive install", "rpm -Uvh"]
          when /archlinux/i
            ["ArchLinux", "pkg.tar.xz", "pacman -S --noconfirm", "pacman -U --noconfirm"]
          when /(mandriva|mageia)/i
            [$1, "rpm", "urpmi --auto ", "rpm -Uvh"]
          when /pc\s*linux\s*os/i
            ["PCLinuxOS", "rpm", "apt-get install -y", "rpm -Uvh"]
          when /gentoo/i
            ["Gentoo", "tgz", "emerge", ""]
          else
            install_method = "build"
            [`lsb_release -d 2> /dev/null`.strip.split[1..-1].join(" ")]
        end
      end
      ret = {
        :platform => "linux",
        :os_distro => distro,
        :pkg_format => pkg_fmt,
        :pkg_arch => pkg_arch,
        :os_version => version,
        :install_method => install_method,
        :install_cmd => install,
        :local_install_cmd => local_install,
        :os_nickname => nickname,
        :hostname => `hostname`.chomp,
        :arch => arch_family,
        :n_cpus => proc_count_miner[nil],
        :ram => mem_size_miner[nil],
      }
      ret.reject! { |k,v| v.nil? }
      @@os_features.merge!(ret)
    end

    # Solaris Miner
    solaris_miner = lambda do
      distro = `uname -a`.match(/(open\s*)?(solaris)/i)[1..-1].compact.map { |s| s.capitalize }.join
      version = `uname -r`.strip
      nickname = "#{distro} #{version.split('.')[-1]}"
      if distro == "OpenSolaris"
        nickname = File.read("/etc/release").match(/OpenSolaris [a-zA-Z0-9.]\+/i)[0].strip
      end
      @@os_features.merge!({
        :platform => "solaris",
        :os_distro => distro,
        :os_version => version,
        :install_method => "install",
        :install_cmd => "pkg install",
        :os_nickname => nickname,
        :hostname => `hostname`.chomp,
        :arch => proc_arch_miner[nil],
        :n_cpus => proc_count_miner[nil],
        :ram => mem_size_miner[nil],
      })
    end

    # *BSD Miner
    bsd_miner = lambda do
      distro = `uname -s`.strip
      version = `uname -r`.strip
      @@os_features.merge!({
        :platform => "bsd",
        :os_distro => distro,
        :os_version => version,
        :install_method => "install",
        :install_cmd => "pkg_add -r",
        :os_nickname => "#{distro} #{version}",
        :hostname => `hostname`.chomp,
        :arch => proc_arch_miner[nil],
        :n_cpus => proc_count_miner[nil],
        :ram => mem_size_miner[nil],
      })
    end

    # BeOS Miner
    beos_miner = lambda do
      version = `uname -r`.strip
      distro = `uname -s`.strip
      @@os_features.merge!({
        :platform => "beos",
        :os_distro => distro,
        :os_version => version,
        :install_method => "build",
        :os_nickname => "#{distro} #{version}",
        :hostname => `hostname`.chomp,
        :arch => proc_arch_miner[nil],
        :n_cpus => proc_count_miner[nil],
        :ram => mem_size_miner[nil],
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
        :os_distro => nickname.split(/\s+/).reject { |s| s =~ /microsoft|windows/i }.join(" "),
        :hostname => hostname,
        :os_nickname => nickname,
        :os_version => version,
        :platform => "windows",
        :install_method => "install",
        :install_cmd => "install",
        :arch => proc_arch_miner["2> nul"],
        :n_cpus => proc_count_miner["2> nul"],
        :ram => mem_size_miner["2> nul"],
      })
    end

    case ::RbConfig::CONFIG['host_os'].downcase
    when /darwin/;      mac_miner[]
    when /mswin|mingw/; windows_miner[]
    when /linux/;       linux_miner[]
    when /bsd/;         bsd_miner[]
    when /solaris/;     solaris_miner[]
    else
      case `uname -s`.chomp.downcase
      when /linux/;     linux_miner[]
      when /darwin/;    mac_miner[]
      when /solaris/;   solaris_miner[]
      when /bsd/;       bsd_miner[]
      when /dragonfly/; bsd_miner[]
      when /haiku/;     beos_miner[]
      when /beos/;      beos_miner[]
      end
    end

    @@os_features.freeze
  end

  # Detect the interpreter we're running on.
  def detect_interpreter
    @@interpreter ||= nil
    return @@interpreter if @@interpreter

    var = ::RbConfig::CONFIG['RUBY_INSTALL_NAME'].downcase
    if defined?(::RUBY_ENGINE)
      var << " " << ::RUBY_ENGINE.downcase
    end
    @@interpreter = case var
      when /jruby/;     "jruby"
      when /macruby/;   "macruby"
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
    @@interpreter_language ||= case detect_interpreter
      when "jruby";             "java"
      when "macruby";           "objective-c"
      when "rubinius";          "c++"
      when "maglev";            "smalltalk"
      when "ironruby";          ".net"
      when /rubyee|goruby|mri/; "c"
    end
  end

  # Detect the most likely candidate for a public-facing IPv4 Address
  def detect_reachable_ip
    if RUBY_VERSION >= "1.9.2"
      require 'socket'
      possible_ips = Socket.ip_address_list.reject { |ip| !ip.ipv4? || ip.ipv4_loopback? }
      return possible_ips.first
    end
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
      if Pathname.which("ifconfig")
        ip_output = `ifconfig -a 2> /dev/null`.chomp
      elsif File.executable?("/sbin/ifconfig")
        ip_output = `/sbin/ifconfig -a 2> /dev/null`.chomp
      else
        ip_output = `ip addr 2> /dev/null`.chomp
      end
      possible_ips = ip_output.scan(/inet (?:addr:)?([0-9\.]+)/).flatten
      possible_ips.reject! { |ip| ip == "127.0.0.1" }
      return possible_ips.first
    end
  end

  # Probe the platform for information
  def detect_platform
    @@platform_features ||= {
      :interpreter => detect_interpreter,
      :interpreter_language => detect_interpreter_language,
      :ipv4 => detect_reachable_ip,
      :ruby_version => RUBY_VERSION,
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
