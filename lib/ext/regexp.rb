class Regexp
  def inverse
    %r{\A(?:(?!#{source}).)+\z}
  end
end
