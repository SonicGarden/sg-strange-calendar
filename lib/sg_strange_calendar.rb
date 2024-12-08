class SgStrangeCalendar
  MONTH_NAMES = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

  def initialize(year, today = nil)
    @year = year
  end

  def generate(vertical: false)
    lines = []
    lines << "#{@year} Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo"
    (1..12).each do |month|
      line = []
      line << MONTH_NAMES[month - 1] + " "
      first_day = Date.new(@year, month, 1)
      (first_day.cwday % 7).times {line << "  "}
      last_day = Date.new(@year, month, -1)
      (1..last_day.day).each {|day| line << day.to_s.rjust(2)}
      lines << line.join(" ")
    end
    lines.join("\n")
  end
end
