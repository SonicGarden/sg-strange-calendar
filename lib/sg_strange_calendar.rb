require 'date'

class SgStrangeCalendar
  DAYS_HEADER = (%w[Su Mo Tu We Th Fr Sa] * 5).concat(%w[Su Mo])
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]

  def initialize(year, today = nil)
    @year = year
    @today = today
    @should_mark_today = @today&.year == @year
  end

  def generate(vertical: false)
    header = [@year.to_s.ljust(4)].concat(DAYS_HEADER).join(' ')

    month_first_wdays = (1..12).map { |i| Date.new(@year, i, 1).wday }
    month_last_days = (1..12).map { |i| Date.new(@year, i, 1).next_month.prev_day.day }

    calenders_per_month = MONTHS.map.with_index do |month, i|
      calender = ["#{month} "]
                   .concat(['  '] * month_first_wdays[i])
                   .concat((1..month_last_days[i]).to_a.map { |day| day.to_s.rjust(2) })
                   .join(' ')

      if @should_mark_today && @today.month - 1 == i
        right_bracket_index = 4 + (month_first_wdays[i] + @today.day) * 3
        left_bracket_index = right_bracket_index - (@today.day.between?(1, 9) ? 2 : 3)

        calender[left_bracket_index] = '['
        calender[right_bracket_index] = ']'
      end

      calender
    end

    [header].concat(calenders_per_month).join("\n")
  end
end
