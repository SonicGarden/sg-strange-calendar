require 'date'

class SgStrangeCalendar
  WDAYS = %w[Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo].freeze
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze
  BLANK = ' '.freeze

  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    header = (vertical ? MONTHS : WDAYS).dup.unshift("#{@year}")
    ths = (vertical ? WDAYS : MONTHS).dup
    length = vertical ? 3 : 2
    calendar = days(length:).then { vertical ? _1.transpose : _1 }.map do |line|
      line.unshift(ths.shift.ljust(4))
      line.join(' ').then { _1.gsub(/\s(\[\d{,2}\])(?:\s|\z)/) { "#{$1}" } }.rstrip
    end
    calendar.unshift(header.join(' ')).join("\n")
  end

  private

  def days(length:)
    [*1..12].map do |month|
      begining_of_month, end_of_month = Date.new(@year, month, 1), Date.new(@year, month, -1)
      array = [*begining_of_month..end_of_month].map do |date|
        date == @today ? "[#{date.day}]".rjust(length + 2) : date.day.to_s.rjust(length)
      end
      begining_of_month.wday.times { array.unshift(BLANK.rjust(length)) }
      array.fill(BLANK.rjust(length), array.size..WDAYS.size - 1)
    end
  end
end
