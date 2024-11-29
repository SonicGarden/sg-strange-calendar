class SgStrangeCalendar
  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    vertical ? generate_vertical : generate_horizontal
  end

  private

  def generate_horizontal
    rows = ["#{@year}#{' Su Mo Tu We Th Fr Sa' * 5} Su Mo"]
    1.upto(12) do |m|
      first_date = Date.new(@year, m, 1)
      last_date = Date.new(@year, m, -1)
      month = first_date.strftime('%b')
      days = Array.new(first_date.wday, '  ')
      first_date.upto(last_date) do |date|
        days.push(date == @today ? "[#{date.day}" : date.day.to_s.rjust(2))
      end
      rows << "#{month}  #{days.join(' ')}".sub(/ (\[\d\d)/, '\1').sub(/(\[\d+) ?/, '\1]')
    end
    rows.join("\n")
  end

  def generate_vertical
    horizontal = Array.new(12) do |i|
      first_date = Date.new(@year, i + 1, 1)
      last_date = Date.new(@year, i + 1, -1)
      empty_days = Array.new(first_date.wday)
      [*empty_days, *first_date..last_date]
    end
    wdays = %w[Su Mo Tu We Th Fr Sa] * 5 + %w[Su Mo]
    vertical = wdays.zip(*horizontal)
    rows = ["#{@year} Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"]
    vertical.each do |wday, *dates|
      days = dates.map do |date|
        (@today && date == @today ? "[#{date.day}" : date&.day).to_s.rjust(3)
      end
      rows << ["#{wday}  ", *days].join(' ').rstrip.sub(/(\[\d+) ?/, '\1]')
    end
    rows.join("\n")
  end
end
