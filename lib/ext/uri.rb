require 'pathname'
require 'uri'

class URI::Generic
  def relative_path?
    relative? && !path.empty? && Pathname.new(path).relative?
  end

  def absolute_path?
    relative? && Pathname.new(path).absolute?
  end

  def relative_scheme?
    scheme.nil? && (!host.nil? || !path.empty?)
  end

  def origin
    ret = (scheme ? "#{scheme}://" : "//")
    ret += hostname
    ret += (port && port != default_port ? ":#{port}" : "")
  end
end
