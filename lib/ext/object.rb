class Object
  def deep_dup
    Marshal.load(Marshal.dump(self))
  end

  def just_my_methods
    ret = self.methods
    (self.class.ancestors - [self.class]).each { |klass|
      if Module === klass
        ret -= klass.methods
      elsif Class === klass
        ret -= klass.new.methods
      end
    }
    ret
  end
end
