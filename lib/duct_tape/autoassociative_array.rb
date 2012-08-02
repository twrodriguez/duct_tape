module Containers
  class AutoassociativeArray
    def initialize(*args)
      @values = []
      @columns = Hash.new { |hsh,key| hsh[key] = {} }
      @hash = Hash.new { |hsh,key| hsh[key] = [] }
      insert(args) unless args.empty?
      self
    end

    def insert(*args)
      @values |= [args]
      args.size.times do |i|
        @columns[i][@values[-1][i]] = @values[-1]
        @hash[@values[-1][i]].push(@values[-1])
      end
      self
    end

    def partial_match(*args)
      ret = []
      (1..args.size).reverse_each do |i|
        break unless ret.empty?
        args.combination(i) do |subset|
          ret |= self[*subset]
          break unless ret.empty?
        end
      end
      (ret && ret.one? ? ret[0] : ret)
    end

    def [](*args)
      ret = @hash[args.first]
      args[1..-1].each do |k|
        ret &= @hash[k]
        break if ret.empty?
      end
      (ret && ret.one? ? ret[0] : ret)
    end

    def by_column(col, key)
      (@columns.has_key?(col) && @columns[col].has_key?(key)) ? @columns[col][key] : nil
    end

    def empty?
      @values.empty?
    end

    def length
      @values.size
    end
    alias_method :size, :length

    def method_missing(*args, &block)
      ret = @values.__send__(*args, &block)
      rebuild_hash
      ret
    end

    def clear
      @hash.clear
      @values.clear
      @columns.clear
      self
    end

    def inspect
      @values.inspect
    end

    def to_s
      @values.to_s
    end

    def <<(ary)
      insert(*ary)
    end

    private

    def rebuild_hash
      @hash.clear
      @columns.clear
      @values.each_with_index do |ary,idx|
        type_assert(ary, Array)
        ary.size.times do |i|
          @columns[i][@values[idx][i]] = @values[idx]
          @hash[@values[idx][i]].push(@values[idx])
        end
      end
      self
    end
  end
end
