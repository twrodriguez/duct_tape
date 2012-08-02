class Range
  # Converts to an array, then chunks into segments of maximum length
  # (1..10).chunk(3) #=> [[1,2,3], [4,5,6], [7,8,9], [10]]
  def chunk(max_length)
    each_slice(max_length).to_a
  end
end
