require 'date'

class SgStrangeCalendar
  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    builder = vertical ? VerticalBuilder : HorizontalBuilder
    builder.new(@year, @today).build
  end

  class Builder
    WDAYS = %w[Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo].freeze
    MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze
    BLANK = ' '.freeze

    private_constant :WDAYS, :MONTHS, :BLANK

    def initialize(year, today)
      @year = year
      @today = today
    end

    def build
      calendar = rows.map.with_index do |line, i|
        [ths[i].ljust(4), *line].join(' ').gsub(/\s(\[\d+\])(?:\s|\z)/) { $1 }.rstrip
      end
      [header.join(' '), *calendar].join("\n")
    end

    private

    def days_in(month)
      begining_of_month, end_of_month = Date.new(@year, month, 1), Date.new(@year, month, -1)
      array = [*begining_of_month..end_of_month].map do |date|
        date == @today ? "[#{date.day}]".rjust(length + 2) : date.day.to_s.rjust(length)
      end
      forward_blanks = Array.new(begining_of_month.wday, BLANK.rjust(length))
      array.unshift(*forward_blanks)
      array.fill(BLANK.rjust(length), array.size...WDAYS.size)
    end

    def header = raise NotImplementedError
    def ths = raise NotImplementedError
    def length = raise NotImplementedError
    def rows = raise NotImplementedError
  end

  class HorizontalBuilder < Builder
    private

    def header = @header ||= [@year.to_s, *WDAYS.dup]
    def ths = @ths ||= MONTHS.dup
    def length = 2
    def rows = @rows ||= [*1..12].map(&method(:days_in))
  end

  class VerticalBuilder < Builder
    private

    def header = @header ||= [@year.to_s, *MONTHS.dup]
    def ths = @ths ||= WDAYS.dup
    def length = 3
    def rows = @rows ||= [*1..12].map(&method(:days_in)).transpose
  end

  private_constant :Builder, :HorizontalBuilder, :VerticalBuilder
end
