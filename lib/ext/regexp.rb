class Regexp
  def invert
    if @inverse
      %r{#{@inverse}}
    else
      ret = %r{\A(?:(?!#{source}).)+\z}
      ret.instance_exec(source) { |src| @inverse = src }
      ret
    end
  end
  alias_method :inverse, :invert
end
