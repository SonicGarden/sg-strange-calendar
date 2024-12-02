require_relative 'month'
require_relative 'table'
require 'date'

module Calendar
  class Year
    attr_reader :value, :today

    def initialize(value:, today: nil)
      @value = value
      @today = today
      @months = (1..Month::NAMES.size).map { |value| Month.new(year: self, value:) }
    end

    def leap_year?
      date = Date.new(@value, 1, 1)
      date.leap?
    end

    def generate(vertical: false)
      rows = [header, *@months.map(&:to_array)]
      table = Table.new(rows:, today: @today)
      table.generate(vertical:)
    end

    private

    def header
      [@value.to_s, *(%w[Su Mo Tu We Th Fr Sa] * 5), 'Su', 'Mo']
    end
  end
end
