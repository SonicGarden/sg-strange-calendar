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
    WDAYS = (%w[Su Mo Tu We Th Fr Sa] * 6).take(37)

    def initialize(year, today)
      @year = year
      @today = today
    end

    private

    def generate_data
      dates = 1.upto(12).map do |m|
        first_date = Date.new(@year, m, 1)
        last_date = Date.new(@year, m, -1)
        blank_days = Array.new(first_date.wday)
        [first_date, *blank_days, *first_date..last_date]
      end
      [[@year, *WDAYS]] + dates
    end
  end

  class HorizontalGenerator < Generator
    def generate_calendar
      horizontal_dates = generate_data
      horizontal_dates.map.with_index do |(head, *tail), i|
        i.zero? ? build_horizontal_header(head, tail) : build_horizontal_body(head, tail)
      end.join("\n")
    end

    private

    def build_horizontal_header(year, wdays)
      [year, *wdays].join(' ')
    end

    def build_horizontal_body(first_date, dates)
      month = first_date.strftime('%b')
      days = dates.map do |date|
        day = @today && date == @today ? "[#{date.day}" : date&.day
        day.to_s.rjust(2)
      end
      row = [month.to_s.ljust(4), *days].join(' ')
      row.sub(/ (\[\d\d)/, '\1').sub(/(\[\d+) ?/, '\1]')
    end
  end

  class VerticalGenerator < Generator
    def generate_calendar
      generate_data.map.with_index do |(head, *tail), i|
        i.zero? ? build_vertical_header(head, *tail) : build_vertical_body(head, *tail)
      end.join("\n")
    end

    private

    def generate_data
      wdays, *dates = super
      wdays.zip(*dates)
    end

    def build_vertical_header(year, *dates)
      months = dates.map { |date| date.strftime('%b') }
      [year, *months].join(' ')
    end

    def build_vertical_body(wday, *dates)
      days = dates.map do |date|
        day = @today && date == @today ? "[#{date.day}" : date&.day
        day.to_s.rjust(3)
      end
      row = ["#{wday}  ", *days].join(' ')
      row.sub(/(\[\d+) ?/, '\1]').rstrip
    end
  end
end
