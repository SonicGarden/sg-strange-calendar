require 'date'
class SgStrangeCalendar  
  def initialize(year, today = nil)
    @year = year
    @today = today
    @calendar = generate_calendar_hash(year)
  end

  def generate(vertical: false)
    
  end

  def generate_calendar_hash(year)
    result = {}

    Date.new(year, 1, 1).step(Date.new(year, 12, 31)).each do |date|
      month = date.strftime('%b') # Jan, Feb, ...
      weekday = date.strftime('%a') # Mo, Tu, ...

      result[month] ||= {}
      result[month][date.day] = weekday
    end

    result
  end
end

c = SgStrangeCalendar.new(2024)
puts c.generate
