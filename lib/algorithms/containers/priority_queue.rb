module Containers
  class PriorityQueue
    def to_a
      @heap.to_a
    end

    def each(*args, &block)
      @heap.each(*args, &block)
    end
  end
end
