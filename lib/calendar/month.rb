require 'date'

module Calendar
  class Month
    NAMES = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

    def initialize(year:, value:)
      @year = year
      @value = value
      @name = NAMES[@value - 1]
      @day_count = day_count
      @dates = (1..@day_count).map { |number| Date.new(@year.value, @value, number) }
    end

    def to_array
      [@name, *([''] * first_date_wday), *@dates]
    end

    private

    def day_count
      case @value
      when 1, 3, 5, 7, 8, 10, 12 then 31
      when 4, 6, 9, 11 then 30
      when 2
        @year.leap_year? ? 29 : 28
      else
        raise 'Invalid month'
      end
    end

    def first_date_wday
      @dates.first.wday
    end
  end
end
