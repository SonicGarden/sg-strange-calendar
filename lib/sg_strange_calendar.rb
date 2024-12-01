class SgStrangeCalendar
  YEAR_WIDTH = 4
  WDAYS = %w[Su Mo Tu We Th Fr Sa].cycle.take(37)

  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    header, *body_dates = generate_table(vertical)
    header_row = header.join(' ')
    body_rows = build_body_rows(body_dates, vertical)
    [header_row, *body_rows].join("\n")
  end

  private

  def generate_table(vertical)
    dates_by_month = 1.upto(12).map do |m|
      first_date = Date.new(@year, m, 1)
      last_date = Date.new(@year, m, -1)
      blank_days = Array.new(first_date.wday)
      month = first_date.strftime('%b')
      [month, *blank_days, *first_date..last_date]
    end
    wdays = [@year, *WDAYS]
    vertical ? wdays.zip(*dates_by_month) : [wdays, *dates_by_month]
  end

  def build_body_rows(body_dates, vertical)
    day_width = vertical ? 4 : 3
    body_dates.map do |first_col, *dates|
      build_body_row(first_col, dates, day_width)
    end
  end

  def build_body_row(first_col, dates, day_width)
    days = dates.map do |date|
      day = add_left_bracket?(date) ? "[#{date.day}" : date&.day
      day.to_s.rjust(day_width)
    end
    row = [first_col.ljust(YEAR_WIDTH), *days].join
    insert_right_bracket(row).rstrip
  end

  def add_left_bracket?(date)
    @today && date == @today
  end

  def insert_right_bracket(row)
    row.sub(/(\[\d+) ?/, '\1]')
  end
end
