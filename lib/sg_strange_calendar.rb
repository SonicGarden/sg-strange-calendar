class SgStrangeCalendar
  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    rows = ["#{@year}#{' Su Mo Tu We Th Fr Sa' * 5} Su Mo"]
    1.upto(12) do |m|
      first_date = Date.new(@year, m, 1)
      last_date = Date.new(@year, m, -1)
      month = first_date.strftime('%b')
      days = Array.new(first_date.wday, '  ')
      first_date.upto(last_date) do |date|
        days.push(date == @today ? "[#{date.day}]" : date.day.to_s.rjust(2))
      end
      row = "#{month}  #{days.join(' ')}"
              .sub(/(\[\d\]) (\d)/, '\1\2')
              .sub(/(\d) (\[\d\d\])/, '\1\2')
              .sub(/(\[\d\])  (\d)/, '\1 \2')
      rows << row
    end
    rows.join("\n")
  end
end
