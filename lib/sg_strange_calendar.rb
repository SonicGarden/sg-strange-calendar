class SgStrangeCalendar
  def initialize(year, today = nil)
    @horizontal = HorizontalGenerator.new(year, today)
    @vertical = VerticalGenerator.new(year, today)
  end

  def generate(vertical: false)
    generator = vertical ? @vertical : @horizontal
    generator.generate_calendar
  end

  class Generator
    WDAYS = %w[Su Mo Tu We Th Fr Sa].cycle.take(37)

    def initialize(year, today)
      @year = year
      @today = today
    end

    def generate_calendar
      generate_data.map.with_index do |(first_col, *values), i|
        i.zero? ? build_header_row(first_col, values) : build_body_row(first_col, values)
      end.join("\n")
    end

    private

    def generate_data
      dates_by_month = 1.upto(12).map do |m|
        first_date = Date.new(@year, m, 1)
        last_date = Date.new(@year, m, -1)
        blank_days = Array.new(first_date.wday)
        [first_date, *blank_days, *first_date..last_date]
      end
      [[@year, *WDAYS]] + dates_by_month
    end

    def build_header_row(year, values)
      labels = values.map(&format_header_label)
      [year, *labels].join(' ')
    end

    def build_body_row(first_col, dates)
      formatted_first_col = format_first_col(first_col).ljust(4)
      days = dates.map do |date|
        day = @today && date == @today ? "[#{date.day}" : date&.day
        day.to_s.rjust(date_width)
      end
      row = [formatted_first_col, *days].join
      insert_right_bracket(row).rstrip
    end

    def to_month(date) = date.strftime('%b')

    def insert_right_bracket(row) = row.sub(/(\[\d+) ?/, '\1]')
  end

  class HorizontalGenerator < Generator
    private

    def date_width = 3

    def format_header_label = ->(wday) { wday }

    def format_first_col(first_date) = to_month(first_date)
  end

  class VerticalGenerator < Generator
    private

    def generate_data
      wdays, *dates_by_month = super
      wdays.zip(*dates_by_month)
    end

    def date_width = 4

    def format_header_label = ->(first_date) { to_month(first_date) }

    def format_first_col(wday) = wday
  end
end
