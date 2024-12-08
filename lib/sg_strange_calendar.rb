require 'date'

class SgStrangeCalendar
  WDAYS = (%w[Su Mo Tu We Th Fr Sa] * 5).concat(%w[Su Mo])
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]

  def initialize(year, today = nil)
    @year = year
    @today = today
    @should_mark_today = @today&.year == @year
    @month_first_wdays = (1..12).map { |i| Date.new(@year, i, 1).wday }
  end

  def generate(vertical: false)
    generate_horizontal
  end

  private

  def generate_horizontal
    header = [@year.to_s.ljust(4)].concat(WDAYS).join(' ')

    calenders_2d_array = generate_calenders_2d_array
    calenders_per_month = MONTHS.map.with_index do |month, i|
      row = ["#{month} "]
            .concat(calenders_2d_array[i].map { |day| day.to_s.rjust(2) })
            .join(' ')

      if @should_mark_today && @today.month - 1 == i
        right_bracket_index = 4 + (@month_first_wdays[i] + @today.day) * 3
        left_bracket_index = right_bracket_index - (@today.day.between?(1, 9) ? 2 : 3)

        row[left_bracket_index] = '['
        row[right_bracket_index] = ']'
      end

      row
    end

    [header].concat(calenders_per_month).join("\n")
  end

  # 例
  # [
  #   ['', '', 1, 2, ..., 31],  # 1月
  #   ['', 1, 2, 3, ..., 28],   # 2月
  #   ...
  # ]
  def generate_calenders_2d_array
    month_last_days = (1..12).map { |i| Date.new(@year, i, 1).next_month.prev_day.day }

    MONTHS.map.with_index do |_, i|
      ([''] * @month_first_wdays[i]).concat((1..month_last_days[i]).to_a)
    end
  end
end
