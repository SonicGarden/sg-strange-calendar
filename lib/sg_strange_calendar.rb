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

  # @param [Boolan] vertical 縦に表示するか
  # @return [String] 変なカレンダー
  def generate(vertical: false)
    outline_filled_calendar = outline_filled_calendar()
    day_filled_calendar = day_filled_calendar(outline_filled_calendar, vertical)
    visualized_calendar(day_filled_calendar, vertical)
  end

  private

  def outline_filled_calendar
    calendar = Array.new(YEAR_SPACE_SIZE + MONTHS.size).map do
      Array.new(YEAR_SPACE_SIZE + WEEKDAYS_SPACE_SIZE)
    end

    calendar[0][0] = year

    MONTHS.each_key do |month_number|
      calendar[month_number][MONTHS_INDEX] = MONTHS[month_number]
    end

    WEEKDAYS_SPACE_SIZE.times do |fill_time|
      calendar[WEEKDAYS_INDEX][YEAR_SPACE_SIZE + fill_time] = WEEKDAYS[rotated_week_number(fill_time)]
    end

    calendar
  end

  def day_filled_calendar(calendar, _vertical)
    day_filled_calendar = calendar.dup

    (Date.parse("#{year}-1-1")..Date.parse("#{year}-12-31")).each do |date|
      day_filled_calendar[date.month][date.day + offset_days_each_month[date.month]] = date.day
    end

    day_filled_calendar[today.month][today.day + offset_days_each_month[today.month]] = "[#{today.day}]" if today

    day_filled_calendar
  end

  def rotated_week_number(week_fill_time)
    week_fill_time % WEEKDAYS.size
  end

  # カレンダーは日曜日から始まるが月初の曜日はそれぞれ異なるのでその分のオフセットを保持
  def offset_days_each_month
    @offset_days_each_month ||= MONTHS.each_key.map do |month_number|
      [month_number, Date.new(year, month_number, 1).wday]
    end.to_h
  end

  def visualized_calendar(calendar, vertical)
    # 一行目の項目のサイズに依存する
    space_size = (vertical ? MONTHS : WEEKDAYS).values.max_by(&:size).size
    calendar.map do |row|
      row.map do |space|
        if MONTHS.values.include?(space)
          vertical ? space : space.ljust(year.to_s.size)
        elsif WEEKDAYS.values.include?(space)
          vertical ? space.ljust(year.to_s.size) : space
        elsif space.nil?
          ' ' * space_size
        else
          space.to_s.rjust(space_size)
        end
      end
    end => space_adjusted_calendar

    directioned_calendar = if vertical
                             space_adjusted_calendar.transpose
                           else
                             space_adjusted_calendar
                           end

    # todayが指定された際に、[]の分増えたスペースを調整
    directioned_calendar.map do |row|
      if vertical
        vertical_emphasized_line(row)
      else
        horizontal_emphasized_line(row)
      end.rstrip
    end.join("\n").rstrip
  end

  def vertical_emphasized_line(line)
    line.map do |space|
      case space
      when /\[\d{2}\]/
        space
      when /\[\d{1}\]/
        ' ' + space
      else
        space + ' '
      end
    end.join
  end

  def horizontal_emphasized_line(line)
    line.join(' ')
        .sub(/(?<=\[\d{1}\]) {1}/, '')
        .gsub(/ {1}(?=\[\d{2}\])/, '')
        .gsub(/((?<=\[\d{2}\]) {1})/, '')
  end
end
