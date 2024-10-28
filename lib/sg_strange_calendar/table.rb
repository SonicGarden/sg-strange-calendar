module SgStrangeCalendar
  class Table
    def initialize(year, today = nil)
      @year = year
      @today = today || Date.today
    end

    def generate
      [
        header(@year),

      ]
    end

    private

    def header(year)
      [year] + %w[Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo]
    end
  end
end
