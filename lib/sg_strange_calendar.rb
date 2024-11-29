class SgStrangeCalendar
  WDAYS = (%w[Su Mo Tu We Th Fr Sa] * 6).take(37)

  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    vertical ? generate_vertical : generate_horizontal
  end

  private

  def generate_horizontal
    header = "#{@year} #{WDAYS.join(' ')}"
    body = 1.upto(12).map do |m|
      first_date = Date.new(@year, m, 1)
      last_date = Date.new(@year, m, -1)
      month = first_date.strftime('%b')
      days = Array.new(first_date.wday, '  ')
      days += first_date.upto(last_date).map do |date|
        date == @today ? "[#{date.day}" : date.day.to_s.rjust(2)
      end
      row = "#{month}  #{days.join(' ')}"
      row.sub(/ (\[\d\d)/, '\1').sub(/(\[\d+) ?/, '\1]')
    end
    [header, *body].join("\n")
  end

  def generate_vertical
    horizontal_dates = Array.new(12) do |i|
      first_date = Date.new(@year, i + 1, 1)
      last_date = Date.new(@year, i + 1, -1)
      blank_days = Array.new(first_date.wday)
      [*blank_days, *first_date..last_date]
    end
    vertical_dates = WDAYS.zip(*horizontal_dates)

    header = "#{@year} Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
    body = vertical_dates.map do |wday, *dates|
      days = dates.map do |date|
        day = @today && date == @today ? "[#{date.day}" : date&.day
        day.to_s.rjust(3)
      end
      row = ["#{wday}  ", *days].join(' ')
      row.sub(/(\[\d+) ?/, '\1]').rstrip
    end
    [header, *body].join("\n")
  end
end
