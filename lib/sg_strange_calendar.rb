require 'date'

##
# SgStrangeCalendar クラスはカスタムカレンダーを生成するためのクラスです。
# 年、日付の配置、およびカレンダーの形式（縦・横）を指定してカレンダーを作成します。
#
# 主な機能:
# - カレンダーの縦方向/横方向の出力
# - 日付のフォーマットと配置
class SgStrangeCalendar
  # 各月の日数（通常年）
  DAYS_IN_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  # 各月の日数（閏年）
  DAYS_IN_MONTH_LEAP = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  # 月の総数
  MONTHS_NUM = 12

  # 月の名前
  MONTHS_NAMES = %w[January February March April May June July August September October November December]

  # 曜日の名前
  DAYS_NAMES = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

  private_constant :DAYS_IN_MONTH
  private_constant :DAYS_IN_MONTH_LEAP
  private_constant :MONTHS_NUM
  private_constant :MONTHS_NAMES
  private_constant :DAYS_NAMES

  ##
  # カレンダーを初期化します。
  #
  # - year: カレンダーを生成する年。
  # - today: 現在の日付（デフォルトはnil）。
  #
  # @param year [Integer] カレンダーを生成する年
  # @param today [Date, nil] 現在の日付（オプション）
  def initialize(year, today = nil)
    @year = year
    @today = today
    @isLeapYear = Date.leap?(year)
    @primary_length = 12
    @secondary_length = 37

    @first_date_of_year = Date.new(year, 1, 1)
    @date_array = set_up_date_array(highlight_today: !@today.nil?)
  end

  ##
  # カレンダーを生成してそれを返す
  #
  # @param vertical [Boolean] カレンダーを縦方向に表示する場合はtrue（デフォルトはfalse）
  # @return [String] テーブル
  def generate(vertical: false)
    short_days = DAYS_NAMES.map { |day| day[0...2] }
    repeated_days = short_days.cycle.take(37)

    short_months = MONTHS_NAMES.map { |month| month[0...3] }

    unless vertical
      header_labels = repeated_days
      row_labels = short_months
      date_array = @date_array
    else
      header_labels = short_months
      row_labels = repeated_days
      date_array = @date_array.transpose
    end

    date_format_size = header_labels.first.length
    row_label_format_size = @year.to_s.length

    header = "#{@year} #{header_labels.join(' ')}"
    rows = row_labels.map.with_index do |label, row_index|
      # それぞれの要素の書式を合わせる
      formatted_dates = date_array[row_index].map { |date| date.to_s.rjust(date_format_size) }

      formatted_dates = formatted_dates.each_with_object("") do |date, acc_string|
        if date.include?("[")
          # `[数字]` の場合、余分なスペースを削除してそのまま追加
          if date.length > date_format_size + 1
            acc_string.rstrip!
            acc_string << "#{date}"
          elsif date.length == date_format_size + 1
            acc_string << "#{date}"
          else
            acc_string << " #{date}"
          end
        else
          # 通常の日付はスペース付きで追加
          acc_string << "#{date} "
        end
      end

      "#{label.ljust(row_label_format_size)} #{formatted_dates}".rstrip
    end

    [header, rows].join("\n").rstrip
  end

  private

  ##
  # カレンダーの内部データ構造を初期化します。
  #
  # @param  highlight_today [Boolean] 今日の日付を強調するか否か
  # @return [Array<Array<Integer>>] 月ごとの日付が格納された二次元配列
  def set_up_date_array(highlight_today:)
    # 12 * 37の二次元配列　本カレンダーのテーブルの構造と一致する
    date_array = Array.new(@primary_length) { Array.new(@secondary_length) }

    # 1日の前に何マススキップされているかを格納する変数
    skipped_date = @first_date_of_year.wday

    0...@primary_length.times do |month_index|
      month_array = date_array[month_index]

      # その月の日数
      days = days_in_month(month_index + 1)

      # その月において、日数を考慮しない際にもっと大きい日数
      # [nil, nil, 1, 2 .. 31, 32, 33]なら33を指す
      max_date_number_in_this_row = nil

      0...@secondary_length.times do |day_index|
        date = day_index - skipped_date + 1
        if day_index >= skipped_date && date <= days
          if highlight_today && @today.day == date && @today.month - 1 == month_index
            month_array[day_index] = "[#{date}]"
          else
            month_array[day_index] = date
          end
        end
        max_date_number_in_this_row = date if day_index == @secondary_length - 1
      end

      skipped_date = (9 - max_date_number_in_this_row + days) % 7
    end

    date_array
  end

  ##
  # 指定された月の日数を取得します。
  #
  # @param month [Integer] 月（1〜12）
  # @return [Integer] 月の日数
  def days_in_month(month)
    # @yearは必須であるから、nil判定しない
    @isLeapYear = Date.leap?(@year) if @isLeapYear.nil?
    @isLeapYear ? DAYS_IN_MONTH_LEAP[month - 1]: DAYS_IN_MONTH[month - 1]
  end
end
