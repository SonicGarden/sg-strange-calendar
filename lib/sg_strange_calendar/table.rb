module SgStrangeCalendar
  class Table
    WEEKDAYS = %w[Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo]

    def initialize(year, today = nil)
      @year = year
      @today = today || Date.today
    end

    def generate
      [ header(@year) ] +
        ((0..11).to_a).map { |month| Row.new(@year, month, @today).generate }
    end

    private

    def header(year)
      [year] + WEEKDAYS
    end

    class Row
      def initialize(year, month, today = nil)
        @year = year
        @month = month
        @today = today || Date.today
      end

      def generate
        date = start_of_month
        [ start_of_month.strftime('%b') ] +
          start_blank_days +
          (start_of_month..end_of_month).to_a +
          end_blank_days
      end

      def start_blank_days
        start_of_month.strftime('%w').to_i.times.map { |_| nil }
      end

      def end_blank_days
        (WEEKDAYS.size - start_blank_days.length - end_of_month.day ).times.map { |_| nil }
      end

      def start_of_month
        Date.new(@year, @month + 1, 1)
      end

      def end_of_month
        Date.new(@year, @month + 1, -1)
      end
    end
  end
end
