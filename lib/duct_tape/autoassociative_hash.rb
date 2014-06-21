module Containers
  class AutoassociativeHash
    def initialize(&block)
      @mapping_block = block_given? ? block : nil
      @auto_array = Containers::AutoassociativeArray.new
      @hash = {}
      @values = {}
      self
    end

    def [](key)
      mapped_key = @mapping_block ? @mapping_block[key] : key
      match = @auto_array.partial_match(*mapped_key)
      @values[match]
    end

    def []=(key, val)
      mapped_key = @mapping_block[key]
      @hash[key] = val
      @auto_array.insert(*mapped_key)
      @values[mapped_key] = val
    end

    def empty?
      @hash.empty?
    end

    def length
      @hash.size
    end
    alias_method :size, :length

    def clear
      @hash.clear
      @values.clear
      @auto_array.clear
      self
    end

    def inspect
      @hash.inspect
    end

    def to_s
      @hash.to_s
    end

    def dup
      ret = self.class.new(&@mapping_block)
      @hash.each { |key,val| ret[key] = val }
      ret
    end
  end
end
