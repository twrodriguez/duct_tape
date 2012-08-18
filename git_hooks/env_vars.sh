#!/bin/bash -e

#
# Determine Platform
#
uname_output=`uname -s`
if [[ "$uname_output" =~ "Linux" ]]; then
  my_platform="linux"
elif [[ "$uname_output" =~ "Darwin" ]]; then
  my_platform="darwin"
elif [[ "$uname_output" =~ "Solaris" || "$uname_output" =~ "SunOS" ]]; then
  my_platform="solaris"
elif [[ "$uname_output" =~ "BSD" || "$uname_output" =~ "DragonFly" ]]; then
  my_platform="bsd"
elif [[ "$uname_output" =~ "Haiku" ]]; then
  my_platform="beos"
else
  echo "ERROR: Unknown Platform '$uname_output'"
  exit 1
fi

#
# Determine CPU info
#
if [[ -e "/proc/cpuinfo" ]]; then
  # Linux
  num_cpus=`cat /proc/cpuinfo | grep processor | wc -l`
elif [[ -n `which lscpu 2> /dev/null` ]]; then
  # Linux Alternative
  num_cpus=`lscpu | grep -i "CPU(s):" | awk '{print $2}'`
elif [[ -n `which psrinfo 2> /dev/null` ]]; then
  # Solaris
  num_cpus=`psrinfo | wc -l`
elif [[ -n `which sysinfo 2> /dev/null` ]]; then
  # Haiku/BeOS
  num_cpus=`sysinfo | grep -i "CPU #[0-9]*:" | wc -l`
elif [[ -n `which sysctl 2> /dev/null` ]]; then
  # BSD
  num_cpus=`sysctl -a 2> /dev/null | egrep -i 'hw.ncpu' | awk '{print $2}'`
fi

if [[ -n `which arch 2> /dev/null` ]]; then
  # Linux
  my_arch=`arch`
elif [[ -n `which lscpu 2> /dev/null` ]]; then
  # Linux Alternative
  my_arch=`lscpu | grep -i "Architecture" | awk '{print $2}'`
elif [[ -n `which sysinfo 2> /dev/null` ]]; then
  # Haiku/BeOS
  my_arch=`sysinfo | grep -o "kernel_\\w*"`
else
  # BSD/Solaris
  my_arch=`uname -p 2> /dev/null`
  [[ -n "$my_arch" ]] || my_arch=`uname -m 2> /dev/null`
fi

if [[ -n `echo $my_arch | grep -i "sparc\\|sun4u"` ]]; then
  my_arch_family="sparc"
elif [[ -n `echo $my_arch | grep -i "^ppc\\|powerpc"` ]]; then
  my_arch_family="powerpc"
elif [[ "$my_arch" =~ mips ]]; then
  my_arch_family="mips"
elif [[ -n `echo $my_arch | grep -i "ia64\\|itanium"` ]]; then
  my_arch_family="itanium"
elif [[ "$my_arch" =~ 64 ]]; then
  my_arch_family="x86_64"
elif [[ -n `echo $my_arch | grep -i "\\(i[3-6]\\?\\|x\\)86\\|ia32"` ]]; then
  my_arch_family="i386"
elif [[ "$my_arch" =~ arm ]]; then
  my_arch_family="arm"
fi

#
# Setup Build Env
#
if [[ -z `echo "$PATH" | grep "/usr/local/bin"` ]]; then
  export PATH=/usr/local/sbin:/usr/local/bin:$PATH
fi
if [[ "$PATH" =~ "rvm/bin" ]]; then
  if [[ `whoami` == "root" ]]; then
    rvm_home=/usr/local/rvm
  else
    rvm_home=$HOME/.rvm
  fi
  export PATH=$PATH:$rvm_home/bin # Add RVM to PATH for scripting
fi

if [[ "$my_platform" == "linux" ]]; then

  # PLEASE tell me you have lsb_release installed.
  if [[ -z `which lsb_release 2> /dev/null` ]]; then
    if [[ -n `which apt-get 2> /dev/null` ]]; then    # Debian/Ubuntu/Linux Mint?
      sudo apt-get install -y lsb
    elif [[ -n `which yum 2> /dev/null` ]]; then      # CentOS/Fedora?
      sudo yum install -y lsb
    elif [[ -n `which up2date 2> /dev/null` ]]; then  # RHEL?
      sudo up2date -i lsb
    elif [[ -n `which zypper 2> /dev/null` ]]; then   # OpenSUSE/SLES?
      sudo zypper --non-interactive install lsb
    elif [[ -n `which pacman 2> /dev/null` ]]; then   # ArchLinux?
      sudo pacman -S --noconfirm lsb
    elif [[ -n `which slackpkg 2> /dev/null` ]]; then # Slackware?
      sudo slackpkg install lsb
    elif [[ -n `which urpmi 2> /dev/null` ]]; then    # Mandriva?
      sudo urpmi --auto lsb-release
    elif [[ -n `which emerge 2> /dev/null` ]]; then   # Gentoo?
      sudo emerge lsb_release
    else
      echo "ERROR: Unknown Package manager in use (what ARE you using??)"
      exit 1
    fi
  fi

  my_method="install"
  my_major_release=`lsb_release -r 2> /dev/null | awk '{print $2}' | grep -o "[0-9]\+" | head -1`
  my_nickname=`lsb_release -c 2> /dev/null | awk '{print $2}'`
  my_pkg_arch="$my_arch_family"
  lsb_release_output=`lsb_release -a 2> /dev/null`
  if [[ -n `echo $lsb_release_output | grep -i "debian"` ]]; then
    my_distro="debian"
    my_pkg_fmt="deb"
    my_install="apt-get install -y"
    my_local_install="dpkg -i"
    if [[ "$my_arch_family" == "x86_64" ]]; then my_pkg_arch="amd64"; fi
  elif [[ -n `echo $lsb_release_output | grep -i "ubuntu"` ]]; then
    my_distro="ubuntu"
    my_pkg_fmt="deb"
    my_install="apt-get install -y"
    my_local_install="dpkg -i"
    if [[ "$my_arch_family" == "x86_64" ]]; then my_pkg_arch="amd64"; fi
  elif [[ -n `echo $lsb_release_output | grep -i "mint"` ]]; then
    my_distro="mint"
    my_pkg_fmt="deb"
    my_install="apt-get install -y"
    my_local_install="dpkg -i"
    if [[ "$my_arch_family" == "x86_64" ]]; then my_pkg_arch="amd64"; fi
  elif [[ -n `echo $lsb_release_output | grep -i "centos"` ]]; then
    my_distro="centos"
    my_pkg_fmt="rpm"
    my_install="yum install -y"
    my_local_install="yum localinstall -y"
  elif [[ -n `echo $lsb_release_output | grep -i "fedora"` ]]; then
    my_distro="fedora"
    my_pkg_fmt="rpm"
    my_install="yum install -y"
    my_local_install="yum localinstall -y"
  elif [[ -n `echo $lsb_release_output | grep -i "redhat\|rhel"` ]]; then
    my_distro="rhel"
    my_pkg_fmt="rpm"
    my_install="up2date -i"
    my_local_install="rpm -Uvh"
  elif [[ -n `echo $lsb_release_output | grep -i "open\s*suse"` ]]; then
    my_distro="opensuse"
    my_pkg_fmt="rpm"
    my_install="zypper --non-interactive install"
    my_local_install="rpm -Uvh"
  elif [[ -n `echo $lsb_release_output | grep -i "suse" | grep -i "enterprise"` ]]; then
    my_distro="sles"
    my_pkg_fmt="rpm"
    my_install="zypper --non-interactive install"
    my_local_install="rpm -Uvh"
  elif [[ -n `echo $lsb_release_output | grep -i "arch"` ]]; then
    my_distro="arch"
    my_pkg_fmt="pkg.tar.xz"
    my_install="pacman -S --noconfirm"
    my_local_install="pacman -U --noconfirm"
  elif [[ -n `echo $lsb_release_output | grep -i "slack"` ]]; then
    my_distro="slackware"
    if [[ "$my_major_release" -lt "13" ]]; then
      my_pkg_fmt="tgz"
    else
      my_pkg_fmt="txz"
    fi
    my_install="slackpkg install --yes" # TODO - Correct?
    my_local_install="installpkg"
  elif [[ -n `echo $lsb_release_output | grep -i "mandriva"` ]]; then
    my_distro="mandriva"
    my_pkg_fmt="rpm"
    my_install="urpmi --auto "
    my_local_install="urpmi --auto"
  elif [[ -n `echo $lsb_release_output | grep -i "gentoo"` ]]; then
    my_distro="gentoo"
    my_pkg_fmt="tgz"
    my_install="emerge"
    my_local_install=""
  else
    echo "Warning: Unsupported Linux Distribution, any packages will be compiled from source"
    my_method="build"
    my_distro=`lsb_release -d 2> /dev/null`
  fi

elif [[ "$my_platform" == "darwin" ]]; then

  my_distro="Mac OSX"
  my_install=""

  if [[ -z `which brew 2> /dev/null` ]]; then # Homebrew
    my_method="install"
    my_install="brew install"
  elif [[ -z `which port 2> /dev/null` ]]; then # MacPorts
    my_method="install"
    my_install="port install"
  else
    my_method="build"
  fi
  my_major_release=`sw_vers -productVersion | grep -o "[0-9]\+\.[0-9]\+" | head -1`
  case "$my_major_release" in
    "10.0") my_nickname="Cheetah";;
    "10.1") my_nickname="Puma";;
    "10.2") my_nickname="Jaguar";;
    "10.3") my_nickname="Panther";;
    "10.4") my_nickname="Tiger";;
    "10.5") my_nickname="Leopard";;
    "10.6") my_nickname="Snow Leopard";;
    "10.7") my_nickname="Lion";;
    "10.8") my_nickname="Mountain Lion";;
    *)
      echo "Unknown Version of OSX Detected: $my_major_release"
      my_nickname="Unknown"
      ;;
  esac

  my_pkg_fmt=""
  my_local_install=""

elif [[ "$my_platform" == "solaris" ]]; then

  my_major_release=`uname -r | grep -o "[0-9]\+" | head -2 | tail -1`
  if [[ -n `uname -a | grep -i "open\s*solaris"` ]]; then
    my_distro="OpenSolaris"
    my_nickname="$my_distro `cat /etc/release | grep -o "OpenSolaris [a-zA-Z0-9.]\\+"`"
  else
    my_distro="Solaris"
    my_nickname="$my_distro $my_major_release"
  fi
  my_method="install"
  # NOTE - `pfexec pkg set-publisher -O http://pkg.openindiana.org/legacy opensolaris.org`
  # NOTE - SUNWruby18, SUNWgcc, SUNWgnome-common-devel
  my_install="pkg install"

  my_pkg_fmt=""
  my_local_install=""

elif [[ "$my_platform" == "bsd" ]]; then

  my_distro=`uname -s`
  my_pkg_fmt="tgz"
  my_nickname="$my_distro `uname -r`"
  my_major_release=`uname -r | grep -o "[0-9]\+" | head -1`
  my_method="install"
  # NOTE - `portsnap fetch extract` to update snapshot
  my_install="pkg_add -r"

  my_local_install=""

elif [[ "$my_platform" == "beos" ]]; then

  my_distro=`uname -s`
  my_major_release=`uname -r | grep -o "[0-9]\+" | head -1`
  my_method="build"
  my_nickname="$my_distro $my_major_release"

  my_pkg_fmt=""
  my_local_install=""
  my_install=""

fi
