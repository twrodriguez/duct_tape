class String
  def uncolorize
    self.gsub(/\e\[0[;0-9]*m/, "")
  end

  def colorized?
    self =~ /\e\[0[;0-9]*m/ && true || false
  end

  def word_wrap(width=(tty_width || 80).to_i)
    ret = dup
    ret.word_wrap!(width)
    ret
  end

  def word_wrap!(width=(tty_width || 80).to_i)
    self.gsub!(/(.{1,#{width}})( +|$\n?)|(.{1,#{width}})/, "\\1\\3\n")
  end

  def chunk(max_length)
    type_assert(max_length, Integer)
    chars.each_slice(max_length).to_a.map! { |ary| ary.join("") }
  end

  def %(arg)
    if ::RUBY_VERSION <= "1.8.7" && arg.is_a?(Hash)
      return gsub(/%\{(\w+)\}/) do |s|
        if arg.has_key?($1.to_sym)
          arg[$1.to_sym]
        else
          raise KeyError.new("key{#{$1}} not found")
        end
      end
    elsif arg.is_a?(Array)
      return Kernel.sprintf(self, *arg)
    else
      return Kernel.sprintf(self, arg)
    end
  end

  # Transform self to a Date
  def to_date
    Date.parse(self)
  end

  # Transform self to a Time
  def to_time
    Time.parse(self)
  end

  def to_const
    split("::").inject(::Object) { |k,c| k.const_get(c) }
  end
end
