module Containers
  class Heap
    def to_a
      ret = @stored.to_a
      ret.sort! { |a,b| (@compare_fn[a[0],b[0]] ? -1 : 1) }
      ret.map! { |k,v| v.map { |f| f.value } }
      ret.flatten!
      ret
    end

    def each(*args, &block)
      to_a.each(*args, &block)
    end
  end
end
