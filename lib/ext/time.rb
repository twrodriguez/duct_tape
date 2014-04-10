class Time
  def self.duration(num, usecs=false)
    type_assert(num, Numeric)
    secs  = num.to_i
    mins  = secs / 60
    hours = mins / 60
    days  = hours / 24
    weeks  = days / 7
    months  = days / 30
    years  = days / 365

    secs  = num if usecs

    year_str = (years == 1 ? "year" : "years")
    month_str = (months == 1 ? "month" : "months")
    week_str = (weeks == 1 ? "week" : "weeks")
    day_str = (days == 1 ? "day" : "days")
    hour_str = (hours % 24 == 1 ? "hour" : "hours")
    min_str = (mins % 60 == 1 ? "minute" : "minutes")
    sec_str = (secs % 60 == 1 ? "second" : "seconds")

    str_ary = []
    str_ary << "#{years} #{year_str}" if years > 0
    str_ary << "#{months % 12} #{month_str}" if months > 0
    str_ary << "#{weeks % 4} #{week_str}" if weeks > 0
    str_ary << "#{days % 7} #{day_str}" if days > 0
    str_ary << "#{hours % 24} #{hour_str}" if hours > 0
    str_ary << "#{mins % 60} #{min_str}" if mins > 0
    str_ary << "#{secs % 60} #{sec_str}" if secs > 0
    if str_ary.size > 2
      [str_ary[0..-2].join(", "), str_ary[-1]].join(", and ")
    else
      str_ary.join(" and ")
    end
  end

  # Transform a Time to a DateTime
  def to_datetime
    DateTime.parse(self.to_s)
  end
end
