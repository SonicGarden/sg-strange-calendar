require_relative 'calendar/year'

class SgStrangeCalendar
  def initialize(year, today = nil)
    @year = Calendar::Year.new(value: year, today:)
  end

  def generate(vertical: false)
    @year.generate(vertical:)
  end
end
