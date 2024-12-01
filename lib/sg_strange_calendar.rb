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
      generate_data.map.with_index do |(head, *tail), i|
        i.zero? ? build_header_row(head, tail) : build_body_row(head, tail)
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

    def to_month(date)
      date.strftime('%b')
    end

    def format_day(date)
      day = @today && date == @today ? "[#{date.day}" : date&.day
      day.to_s.rjust(3)
    end

    def insert_right_bracket(row)
      row.sub(/(\[\d+) ?/, '\1]')
    end
  end

  class HorizontalGenerator < Generator
    private

    def build_header_row(year, wdays)
      [year, *wdays].join(' ')
    end

    def build_body_row(first_date, dates)
      month = to_month(first_date)
      days = dates.map { |date| format_day(date) }
      row = ["#{month} ", *days].join
      insert_right_bracket(row)
    end
  end

  class VerticalGenerator < Generator
    private

    def generate_data
      wdays, *dates_by_month = super
      wdays.zip(*dates_by_month)
    end

    def build_header_row(year, first_dates)
      months = first_dates.map { |date| to_month(date) }
      [year, *months].join(' ')
    end

    def build_body_row(wday, dates)
      days = dates.map { |date| format_day(date) }
      row = ["#{wday}  ", *days].join(' ')
      insert_right_bracket(row).rstrip
    end
  end
end
