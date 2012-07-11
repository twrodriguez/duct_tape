class Time
  def self.duration(num, usecs=false)
    type_assert(num, Numeric)
    secs  = num.to_i
    mins  = secs / 60
    hours = mins / 60
    days  = hours / 24

    secs  = num if usecs

    day_str = (days == 1 ? "day" : "days")
    hour_str = (hours % 24 == 1 ? "hour" : "hours")
    min_str = (mins % 60 == 1 ? "minute" : "minutes")
    sec_str = (secs % 60 == 1 ? "second" : "seconds")

    str_ary = []
    str_ary << "#{days} #{day_str}" if days > 0
    str_ary << "#{hours % 24} #{hour_str}" if hours > 0
    str_ary << "#{mins % 60} #{min_str}" if mins > 0
    str_ary << "#{secs % 60} #{sec_str}" if secs > 0
    str_ary.join(" and ")
  end

  # Transform a Time to a DateTime
  def to_datetime
    DateTime.parse(self.to_s)
  end
end
