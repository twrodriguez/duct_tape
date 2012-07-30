require 'date'

class DateTime < Date
  def to_time
    Time.parse(self.to_s)
  end
end
