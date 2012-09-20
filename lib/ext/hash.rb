class Hash
  # Merges self with another second, recursively.
  #
  # This code was lovingly stolen from some random gem:
  # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
  #
  # Thanks to whoever made it.
  #
  # Modified to provide same functionality with Arrays

  def deep_merge(second)
    target = deep_dup
    target.deep_merge!(second.deep_dup)
    target
  end

  # From: http://www.gemtacular.com/gemdocs/cerberus-0.2.2/doc/classes/Hash.html
  # File lib/cerberus/utils.rb, line 42
  # Modified to provide same functionality with Arrays

  def deep_merge!(second)
    return nil unless second
    type_assert(second, Hash)
    second.each_pair do |k,v|
      if self[k].is_a?(Array) and second[k].is_a?(Array)
        self[k].deep_merge!(second[k])
      elsif self[k].is_a?(Hash) and second[k].is_a?(Hash)
        self[k].deep_merge!(second[k])
      else
        self[k] = second[k]
      end
    end
  end

  def to_h
    self
  end
  alias_method :to_hash, :to_h

  def select_keys(other, &block)
    target = dup
    target.select_keys!(other, &block)
    target
  end
  alias_method :&, :select_keys

  def select_keys!(other, &block)
    type_assert(other, Array, Hash)
    unless block_given?
      other = other.keys if Hash === other
      block = proc { |k| !other.include?(k) }
    end
    self.reject! { |key,val| !block[key] }
  end

  def reject_keys(other, &block)
    target = dup
    target.reject_keys!(other, &block)
    target
  end
  alias_method :-, :reject_keys

  def reject_keys!(other, &block)
    type_assert(other, Array, Hash)
    unless block_given?
      other = other.keys if Hash === other
      block = proc { |k| other.include?(k) }
    end
    self.reject! { |key,val| block[key] }
  end

  def chunk(max_length=nil, &block)
    if ::RUBY_VERSION >= "1.9" && block_given?
      super(&block)
    else
      each_slice(max_length).to_a.map! { |ary| ary.to_h }
    end
  end

  def not_empty?(arg)
    !empty?
  end
end
