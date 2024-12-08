class SgStrangeCalendar
  MONTH_NAMES = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

  def initialize(year, today = nil)
    @year = year
  end

  def generate(vertical: false)
    lines = []
    lines << "#{@year} Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo"
    (1..12).each do |month|
      month_name = MONTH_NAMES[month - 1]
      first_day = Date.new(@year, month, 1)
      space = "   " * (first_day.cwday % 7)
      last_day = Date.new(@year, month, -1)
      days = (1..last_day.day).map {|day| day.to_s.rjust(2)}.join(" ")
      lines << month_name + "  " + space + days
    end
    lines.join("\n")
  end
end
