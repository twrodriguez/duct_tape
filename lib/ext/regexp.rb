class Regexp
  def inverse
    if @inverse
      %r{#{@inverse}}
    else
      ret = %r{\A(?:(?!#{source}).)+\z}
      ret.instance_exec(source) { |src| @inverse = src }
      ret
    end
  end
end
