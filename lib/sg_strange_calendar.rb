require 'date'
class SgStrangeCalendar  
  def initialize(year, today = nil)
    @year = year
    @today = today
    @calendar = generate_calendar_hash(year)
  end

  def generate(vertical: false)
    result = "2024 Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo"
    @calendar.each_value do |cal|
      result += print_month()
    end
  end

  def generate_calendar_hash(year)
    result = {}

    Date.new(year, 1, 1).step(Date.new(year, 12, 31)).each do |date|
      month = date.strftime('%b') # ex: Jan
      weekday = date.strftime('%a')[0, 2] # ex: Mo

      result[month] ||= {}
      result[month][date.day] = weekday
    end

    result
  end

  def print_month()
    # hogehoge
  end
end

c = SgStrangeCalendar.new(2024)
c.generate
