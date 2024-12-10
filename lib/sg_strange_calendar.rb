# frozen_string_literal: true

require 'date'

class SgStrangeCalendar
  private attr_reader :year, :today

  MONTHS_INDEX = 0
  WEEKDAYS_INDEX = 0
  YEAR_SPACE_SIZE = 1
  WEEKDAYS_SPACE_SIZE = 37
  # 以下のハッシュのキーはDateのAPI仕様に依存している
  MONTHS = (1..12).zip(%w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]).to_h # Date#month
  WEEKDAYS = (0..6).zip(%w[Su Mo Tu We Th Fr Sa]).to_h # Date#wday

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
    build_visualized_calendar(day_filled_calendar, vertical)
  end

  private

  def build_outline_filled_calendar
    calendar = Array.new(YEAR_SPACE_SIZE + MONTHS.size).map do
      Array.new(YEAR_SPACE_SIZE + WEEKDAYS_SPACE_SIZE) do
        ''
      end
    end

    calendar[0][0] = year.to_s

    MONTHS.each_key do |month_number|
      calendar[month_number][MONTHS_INDEX] = MONTHS[month_number]
    end

    WEEKDAYS_SPACE_SIZE.times do |fill_time|
      week_number = fill_time % WEEKDAYS.size
      weekday_index = fill_time + YEAR_SPACE_SIZE
      calendar[WEEKDAYS_INDEX][weekday_index] = WEEKDAYS[week_number]
    end

    calendar
  end

  def build_day_filled_calendar(calendar)
    day_filled_calendar = Marshal.load(Marshal.dump(calendar))

    (Date.new(year, 1,1)..Date.new(year, 12, 31)).each do |date|
      date_index = date.day + offset_days_each_month[date.month]
      date_value = date == today ? "[#{date.day}]" : date.day.to_s

      day_filled_calendar[date.month][date_index] =  date_value
    end

    day_filled_calendar
  end

  # カレンダーは日曜日から始まるが月初の曜日はそれぞれ異なるのでその分のオフセットを保持
  def offset_days_each_month
    @offset_days_each_month ||= MONTHS.each_key.to_h do |month_number|
      [month_number, Date.new(year, month_number, 1).wday]
    end
  end

  def build_visualized_calendar(calendar, vertical)
    directed_calendar = vertical ? calendar.transpose : calendar

    # 一行目の項目のサイズに依存する
    cell_size = (vertical ? MONTHS : WEEKDAYS).values.max_by(&:size).size
    year_size = year.to_s.size
    cell_adjusted_calendar = directed_calendar.map do |row|
      row.map.each_with_index do |value, i|
          i.zero? ? value.ljust(year_size) : value.rjust(cell_size)
      end
    end

    # todayが指定された際に、[]の分増えたスペースを調整
    c = cell_adjusted_calendar.map{ |row| row.join(" ").rstrip }
                          .join("\n")
    adjust_emphasized(c, vertical)

  end

  def adjust_emphasized(row, vertical)
    common = row.sub(/((?<=\[\d{2}\]) {1})/, '')

    if vertical
      common.sub(/ {1}(?=\[\d{1}\])/, '  ')
            .sub(/((?<=\[\d{1}\]) {1})/, '')
    else
      common.sub(/(?<=\[\d{1}\]) {1}/, '')
            .sub(/ {1}(?=\[\d{2}\])/, '')
    end
  end
end
