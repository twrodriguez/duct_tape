module Containers
  class Heap
    def to_a
      @stored.to_a.sort { |a,b|
        (@compare_fn[a[0],b[0]] ? -1 : 1)
      }.map { |k,v| v.map { |f| f.value } }.flatten
    end

    def each(*args, &block)
      to_a.each(*args, &block)
    end
  end
end
