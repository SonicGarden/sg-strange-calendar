class SgStrangeCalendar
  def initialize(year, today = nil)
    @year = year
  end

  def generate(vertical: false)
    rows = ["#{@year}#{' Su Mo Tu We Th Fr Sa' * 5} Su Mo"]
    1.upto(12) do |m|
      first_date = Date.new(@year, m, 1)
      last_date = Date.new(@year, m, -1)
      month = first_date.strftime('%b')
      days = Array.new(first_date.wday, '  ')
      first_date.upto(last_date) do |date|
        days << date.day.to_s.rjust(2)
      end
      rows << "#{month}  #{days.join(' ')}"
    end
    rows.join("\n")
  end
end
