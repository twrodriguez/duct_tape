class Array
  # Returns a copy of self deep_merged with another array
  def deep_merge(second)
    target = deep_dup
    target.deep_merge!(second.deep_dup)
    target
  end

  # Deep_merge self with another array
  def deep_merge!(second)
    return nil unless second
    type_assert(second, Array)
    second.each_index do |k|
      if self[k].is_a?(Array) and second[k].is_a?(Array)
        self[k].deep_merge!(second[k])
      elsif self[k].is_a?(Hash) and second[k].is_a?(Hash)
        self[k].deep_merge!(second[k])
      else
        self << second[k] if exclude?(second[k])
      end
    end
  end

  # 3 Forms:
  # Multiplied by an Integer, returns a single array with the repeated contents of self
  # Multiplied by a String, returns self.join
  # Multiplied by an Array, returns the set-wise cross-product of the two Arrays
  def *(second)
    ret = []
    case second
    when Integer
      second.times { |i| ret += dup }
    when String
      return join(second)
    when Array
      each { |x| second.each { |y| ret << [x,y].flatten } }
    else
      raise TypeError.new("can't convert #{second.class} into Integer")
    end
    return ret
  end

  # Returns the set-wise n-th power of self. (The length of the return value
  # is equal to: self.length ** n)
  # e.g [0,1] ** 0  #=> []
  # e.g [0,1] ** 1  #=> [[0], [1]]
  # e.g [0,1] ** 2  #=> [[0, 0], [0, 1], [1, 0], [1, 1]]
  # e.g [0,1] ** 3  #=> [[0, 0, 0], [0, 0, 1], [0, 1, 0], [0, 1, 1],
  #                 #    [1, 0, 0], [1, 0, 1], [1, 1, 0], [1, 1, 1]]
  def **(n)
    type_assert(n, Integer)
    ret = []
    if n > 1
      ret = dup
      (n - 1).times {
        temp = []
        ret.each { |x| each { |y| temp << [x,y].flatten } }
        ret = temp
      }
    elsif n == 1
      ret = map { |item| [item] }
    end
    return ret
  end

  # Returns a new Array rejecting objects based on if the block-mapped
  # values are unique 
  def uniq_by(&block)
    ret = dup
    ret.uniq_by!(&block)
    ret
  end

  # 3 Forms:
  # TODO
  def unanimous?(arg=nil, &block)
    ret = true
    cmp = (arg.nil? ? (block_given? ? block[first] : first) : arg)
    each_with_index do |elem,index|
      next if index == 0 && arg.nil?
      ret &&= (block_given? ? (cmp == block[elem]) : (cmp == elem))
      break unless ret
    end
    ret
  end

  # Converts certain Arrays to Hashes:
  # ["a","b","c"].to_h                  #=> {0=>"a", 1=>"b", 2=>"c"}
  # [[1,2], [3,4]].to_h                 #=> {1=>2, 3=>4}
  # [{1 => 2}, {3 => 4}].to_h           #=> {1=>2, 3=>4}
  # [{"name" => 1, "value" => 2},
  #  {"name" => 3, "value" => 4}].to_h  #=> {1=>2, 3=>4}
  # [{1 => 2, 3 => 4}, {1 => 4}].to_h   #=> {1=>[2, 4], 3=>4}
  def to_h(name_key="name", value_key="value")
    #raise "Elements are not unique!" unless self == uniq
    ret = {}
    collisions = Hash.new { |hsh,key| hsh[key] = 0 }
    each_with_index do |elem,index|
      temp = {}
      if elem.is_a?(Hash)
        temp = elem
        if elem[name_key] and elem[value_key] and elem.length == 2
          temp = {elem[name_key] => elem[value_key]}
        elsif elem[name_key.to_s] and elem[value_key.to_s] and elem.length == 2
          temp = {elem[name_key.to_s] => elem[value_key.to_s]}
        elsif elem[name_key.to_sym] and elem[value_key.to_sym] and elem.length == 2
          temp = {elem[name_key.to_sym] => elem[value_key.to_sym]}
        end
      elsif elem.is_a?(Array)
        if elem.length == 2
          temp[elem.first] = elem.last
        elsif elem.length > 2
          temp[elem.first] = elem[1..-1]
        else
          temp[index] = elem.first
        end
      else
        temp[index] = elem
      end
      temp.each do |k,v|
        if ret.has_key?(k)
          if collisions[k] == 0
            if ret[k] != v
              collisions[k] += 1
              ret[k] = [ret[k], v]
            end
          elsif ret[k].exclude?(v)
            collisions[k] += 1
            ret[k] << v
          end
        else
          ret[k] = v
        end
      end
    end
    ret
  end
  alias_method :to_hash, :to_h

  # Creates a hash with keys equal to the contents of self and values equal to the
  # mapped array's values
  def map_to_h(&block)
    [self, map(&block)].transpose.to_h
  end

  # Chunks an array into segments of maximum length
  # [1,2,3,4,5,6,7,8,9,10].chunk(3) #=> [[1,2,3], [4,5,6], [7,8,9], [10]]
  def chunk(max_length, &block)
    if ::RUBY_VERSION >= "1.9" && block_given?
      super
    else
      type_assert(max_length, Integer)
      ret = []
      (self.length.to_f / max_length.to_i).ceil.times do |i|
        ret << self[(max_length*i)...(max_length*(i+1))]
      end
      ret
    end
  end

  def not_empty?(arg)
    !empty?
  end

  #
  # Statistics from:
  # http://github.com/christianblais/utilities.git
  #

  # Add each object of the array to each other in order to get the sum, as long as all objects respond to + operator
  def sum
    flatten.compact.inject(:+)
  end
  
  # Calculate squares of each item
  def squares
    map { |i| i ** 2 }
  end
  
  # Return a new array containing the rank of each value
  # Ex: [1, 2, 2, 8, 9] #=> [0.0, 1.5, 1.5, 3.0, 4.0]
  def ranks(already_sorted=false)
    a = already_sorted ? self : sort
    map { |i| (a.index(i) + a.rindex(i)) / 2.0 }
  end
  
  # Calculate square roots of each item
  def sqrts
    map { |i| Math.sqrt(i) }
  end
  
  # Calculate the arithmetic mean of the array, as long as all objects respond to / operator
  def mean
    a = flatten.compact
    (a.size > 0) ? a.sum.to_f / a.size : 0.0
  end
  alias_method :average, :mean

  # TODO - Geometric mean
  
  # Calculate the number of occurences for each element of the array
  def frequencies
    inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  end
  
  # Return the variance of self
  def variance(population=false)
    m = mean.to_f
    map { |v| (v - m).square }.sum / (size - (population ? 0 : 1))
  end
  
  # Return the (sample|population) standard deviation of self
  # If population is set to true, then we consider the dataset as the complete population
  # Else, we consider the dataset as a sample, so we use the sample standard deviation (size - 1)
  def standard_deviation(population=false)
    size > 1 ? Math.sqrt(variance(population)) : 0.0
  end
  alias_method :std_dev, :standard_deviation
  
  # Return the median of sorted self
  def median(already_sorted=false)
    return nil if empty?
    a = already_sorted ? self : sort
    m_pos = size / 2
    size % 2 == 1 ? a[m_pos] : (a[m_pos-1] + a[m_pos]).to_f / 2
  end
  alias_method :second_quartile, :median
  
  # Return the first quartile of self
  def first_quartile(already_sorted=false)
    return nil if size < 4
    a = already_sorted ? self : sort
    a[0..((size / 2) - 1)].median(true)
  end
  alias_method :lower_quartile, :first_quartile
  
  # Return the last quartile of self
  def last_quartile(already_sorted=false)
    return nil if size < 4
    a = already_sorted ? self : sort
    a[((size / 2) + 1)..-1].median(true)
  end
  alias_method :upper_quartile, :last_quartile
  
  # Return an array containing the first, the second and the last quartile of self
  def quartiles(already_sorted=false)
    a = already_sorted ? self : sort
    [a.first_quartile(true), a.median(true), a.last_quartile(true)]
  end
  
  # Calculate the interquartile range of self
  def interquartile_range(already_sorted=false)
    return nil if size < 4
    a = already_sorted ? self : sort
    a.last_quartile - a.first_quartile
  end
  
  # Return a hash of modes with their corresponding occurences
  def modes
    fre = frequencies
    max = fre.values.max
    fre.select { |k, f| f == max }
  end
  
  # Return the midrange of sorted self
  def midrange(already_sorted=false)
    return nil if empty?
    a = already_sorted ? self : sort
    (a.first + a.last) / 2.0
  end
  
  # Return the statistical range of sorted self
  def statistical_range(already_sorted=false)
    return nil if empty?
    a = already_sorted ? self : sort
    (a.last - a.first)
  end
  
  # Return all statistics from self in a simple hash
  def statistics(already_sorted=false)
    sorted = sort
    
    {
      :first => self.first,
      :last => self.last,
      :size => self.size,
      :sum => self.sum,
      :squares => self.squares,
      :sqrts => self.sqrts,
      :min => self.min,
      :max => self.max,
      :mean => self.mean,
      :frequencies => self.frequencies,
      :variance => self.variance,
      :standard_deviation => self.standard_deviation,
      :population_variance => self.variance(true),
      :population_standard_deviation => self.standard_deviation(true),
      :modes => self.modes,
      
      # Need to be sorted...
      :ranks => sorted.ranks(true),
      :median => sorted.median(true),
      :midrange => sorted.midrange(true),
      :statistical_range => sorted.statistical_range(true),
      :quartiles => sorted.quartiles(true),
      :interquartile_range => sorted.interquartile_range(true)
    }
  end
  alias_method :stats, :statistics
end
