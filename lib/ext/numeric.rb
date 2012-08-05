class Numeric
  def years;    self * 31536000;  end
  def weeks;    self * 604800;    end
  def days;     self * 86400;     end
  def hours;    self * 3600;      end
  def minutes;  self * 60;        end
  def seconds;  self;             end
  def mseconds; self / 1000.0;    end
  def useconds; self / 1000000.0; end

  alias_method :year, :years
  alias_method :week, :weeks
  alias_method :day, :days
  alias_method :hour, :hours
  alias_method :minute, :minutes
  alias_method :second, :seconds
  alias_method :msecond, :mseconds
  alias_method :usecond, :useconds

  def eb; self * 1152921504606846976; end
  def pb; self * 1125899906842624;    end
  def tb; self * 1099511627776;       end
  def gb; self * 1073741824;          end
  def mb; self * 1048576;             end
  def kb; self * 1024;                end

  alias_method :EB, :eb
  alias_method :PB, :pb
  alias_method :TB, :tb
  alias_method :GB, :gb
  alias_method :MB, :mb
  alias_method :KB, :kb

  alias_method :exabytes,  :eb
  alias_method :petabytes, :pb
  alias_method :terabytes, :tb
  alias_method :gigabytes, :gb
  alias_method :megabytes, :mb
  alias_method :kilobytes, :kb

  alias_method :exabyte,  :eb
  alias_method :petabyte, :pb
  alias_method :terabyte, :tb
  alias_method :gigabyte, :gb
  alias_method :megabyte, :mb
  alias_method :kilobyte, :kb

  # Convert to degrees
  def to_degrees
    self * Math::PI / 180
  end

  # Convert to radians
  def to_radians
    self * 180 / Math::PI
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
