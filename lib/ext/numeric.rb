class Numeric
  def years; days * 365; end
  def weeks; days * 7; end
  def days; hours * 24; end
  def hours; minutes * 60; end
  def minutes; self * 60; end
  def seconds; self; end;
  def mseconds; self / 1000.0; end;
  def useconds; self / 1000000.0; end

  alias_method :year, :years
  alias_method :week, :weeks
  alias_method :day, :days
  alias_method :hour, :hours
  alias_method :minute, :minutes
  alias_method :second, :seconds
  alias_method :msecond, :mseconds
  alias_method :usecond, :useconds

  def pb; tb * 1024; end
  def tb; gb * 1024; end
  def gb; mb * 1024; end
  def mb; kb * 1024; end
  def kb; self * 1024; end

  alias_method :PB, :pb
  alias_method :TB, :tb
  alias_method :GB, :gb
  alias_method :MB, :mb
  alias_method :KB, :kb

  alias_method :petabytes, :pb
  alias_method :terabytes, :tb
  alias_method :gigabytes, :gb
  alias_method :megabytes, :mb
  alias_method :kilobytes, :kb

  alias_method :petabyte, :pb
  alias_method :terabyte, :tb
  alias_method :gigabyte, :gb
  alias_method :megabyte, :mb
  alias_method :kilobyte, :kb

  # Convert to degrees
  def rad_to_deg
    self * Math::PI / 180
  end

  # Convert to radians
  def deg_to_rad
    self * 180 / Math::PI
  end

  #Transform self to a string formatted time (HH:MM) Ex: 14.5 => “14:30“
  def hour_to_s(delimiter=':')
    hour  = self.to_i
    min   = "%02d" % (self.abs * 60 % 60).to_i
    "#{hour}#{delimiter}#{min}"
  end

  # Return the square root of self
  def sqrt
    Math.sqrt(self)
  end

  # Calculate the rank of self based on provided min and max
  def rank(min, max)
    s, min, max = self.to_f, min.to_f, max.to_f
    min == max ? 0.0 : (s - min) / (max - min)
  end

  # Calculate the percentage of self on n
  def percentage_of(n, t=100)
    n == 0 ? 0.0 : self / n.to_f * t
  end
  alias_method :percent_of, :percentage_of
end
