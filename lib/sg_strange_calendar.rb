# frozen_string_literal: true

require 'date'

class SgStrangeCalendar
  private attr_reader :year, :today

  MONTHS_INDEX = 0
  WEEKDAYS_INDEX = 0
  YEAR_SPACE_SIZE = 1
  WEEKDAYS_SPACE_SIZE = 37
  WEEKDAYS = %w[Su Mo Tu We Th Fr Sa]
  # 以下のハッシュのキーはDateのAPI仕様に依存している
  MONTHS = (1..12).zip(%w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]).to_h # Date#month

  private_constant(*%i[
     MONTHS_INDEX
     WEEKDAYS_SPACE_SIZE
     YEAR_SPACE_SIZE
     WEEKDAYS_INDEX
     MONTHS
     WEEKDAYS
   ])

  # @param [Integer] year 表示対象の年
  # @param [Date] today 今日の（目立たせたい) 日付
  # @return [SgStrangeCalendar] SgStrangeCalenderインスタンス
  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  # @param [Boolean] vertical 縦に表示するか
  # @return [String] 変なカレンダー
  def generate(vertical: false)
    outline_filled_calendar = build_outline_filled_calendar
    day_filled_calendar = build_day_filled_calendar(outline_filled_calendar)
    build_formatted_calendar(day_filled_calendar, vertical)
  end

  private

  def build_outline_filled_calendar
    calendar = Array.new(YEAR_SPACE_SIZE + WEEKDAYS_SPACE_SIZE).map do
      Array.new(YEAR_SPACE_SIZE + MONTHS.size, '')
    end
    calendar[0] = [nil, *MONTHS.values]
    transposed_calendar = calendar.transpose
    transposed_calendar[0] = [year.to_s, *WEEKDAYS.cycle.take(WEEKDAYS_SPACE_SIZE)]
    transposed_calendar
  end

  def build_day_filled_calendar(calendar)
    day_filled_calendar = Marshal.load(Marshal.dump(calendar))

    (Date.new(year, 1,1)..Date.new(year, 12, 31)).each do |date|
      date_index = date.day + offset_days_each_month[date.month]
      date_value = date == today ? "[#{date.day}]" : date.day.to_s

      day_filled_calendar[date.month][date_index] = date_value
    end

    day_filled_calendar
  end

  # カレンダーは日曜日から始まるが月初の曜日はそれぞれ異なるのでその分のオフセットを保持
  def offset_days_each_month
    @offset_days_each_month ||= MONTHS.each_key.to_h do |month_number|
      offset_days = Date.new(year, month_number, 1).wday

      [month_number, offset_days]
    end
  end

  def build_formatted_calendar(calendar, vertical)
    directed_calendar = vertical ? calendar.transpose : calendar

    # 一行目の項目のサイズに依存する
    cell_size = (vertical ? MONTHS.values : WEEKDAYS).max_by(&:size).size
    year_size = year.to_s.size

    cell_adjusted_calendar = directed_calendar.map do |row|
      row[0] = row[0].ljust(year_size)
      adjusted_row = row.map.with_index(1) { |v| v.rjust(cell_size) }
      adjusted_row.join(' ').rstrip
    end.join("\n")

    if today
      adjust_emphasized_day(cell_adjusted_calendar, vertical)
    else
      cell_adjusted_calendar
    end
  end

  # todayが指定された際に、[]の分増えたスペースを調整
  def adjust_emphasized_day(row, vertical)
    common = row.sub(/((?<=\[\d{2}\]) {1})/, '')
                .sub(/((?<=\[\d{1}\]) {1})/, '')

    vertical ? common.sub(/ {1}(?=\[\d{1}\])/, '  ') :
               common.sub(/ {1}(?=\[\d{2}\])/, '')
  end
end
