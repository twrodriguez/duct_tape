module Containers
  class FuzzyHash
    def initialize(&block)
      @mapping_proc = block_given? ? block : lambda { |key| [*key] }
      @auto_array = Containers::AutoassociativeArray.new
      @hash = {}
      @values = {}
      self
    end

    def [](key)
      mapped_key = @mapping_proc[key]
      type_assert(mapped_key, Array)
      match = @auto_array.partial_match(*mapped_key)
      @values[match[0]]
    end

    def []=(key, val)
      mapped_key = @mapping_proc[key]
      type_assert(mapped_key, Array)
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
      ret = self.class.new(&@mapping_proc)
      @hash.each { |key,val| ret[key] = val }
      ret
    end
  end
end
