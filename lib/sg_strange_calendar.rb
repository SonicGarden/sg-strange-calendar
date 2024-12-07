require "date"

class SgStrangeCalendar
  WEEK_SIGNAL = %w[Su Mo Tu We Th Fr Sa]

  def initialize(year, today = nil)
    @year = year
    @today = today
    @calendar = []
    # 1日が土曜日始まりで31日まである月に最も曜日が発生するため、第6週の月曜までを曜日を作成する
    @calendar << [year] + (WEEK_SIGNAL * 5) + WEEK_SIGNAL[0..1]

    row_size = @calendar.first.length
    date = Date.new(year, 1, 1)
    loop do
      # 翌年になるまで繰り返す
      return if date.year > year

      # vertical表示できるように曜日と同じ固定長の配列を作成する
      @calendar << Array.new(row_size - 1)
      # その月の最終日までを繰り返して日付を追加する
      ((date >> 1) - 1).day.times do |i|
        @calendar[date.month][date.wday + i] = i + 1
      end
      # 先頭に月を追加
      @calendar[date.month].unshift date.strftime("%b")
      # 翌月にインクリメントする
      date = date >> 1
    end
  end

  def generate(vertical: false)
    # vertical表示の場合は行と列の入れ換え
    calendar_view = vertical ? @calendar.transpose : @calendar

    calendar_view.map.with_index do |row, i|
      row = row.map.with_index do |val, j|
        next val.to_s.ljust(5) if j == 0

        # 数字の左側に空白を入れる
        val = val.to_s.rjust(vertical ? 3 : 2)
        # 今日の日付が指定されている場合は、数字の後ろに]だけを結合する
        if today
          if vertical
            val.concat("]") if j == today.month && val.to_i == today.day
          else
            val.concat("]") if i == today.month && val.to_i == today.day
          end
        end
        # ]が結合されていない場合は空白を追加する
        val.end_with?("]") ? val : val.concat(" ")
      end.join.sub(/\s(\d+)\]/, "[\\1]").rstrip # ]が結合されている数字の前に[を結合する
    end.join("\n")
  end

  private

  attr_reader :year, :today
end
 