class SgStrangeCalendar
  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    require "date"
    day_of_week = %w[Su Mo Tu We Th Fr Sa]
    cal_arr = []

    #1行目の見出し行を生成
    37.times  do |i|
      if i >= 7
        index_dow = i % 7
      else
        index_dow = i
      end
      cal_arr[i] = " " + day_of_week[index_dow]
    end
    cal_arr.unshift(@year)

    #2行目以降の月・日部分を生成
    name_of_month = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]
    length_og_feb = 28

    if Date.new(@year).leap?
      length_og_feb = length_og_feb + 1
    end

    length_of_month =[31, length_og_feb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    12.times  do |i|
      days_of_month =[]
      length_of_month[i].times do|a|
        days_of_month.push(sprintf("%3d",a+1))
      end

      #月初日の曜日を調べて、1行目の見出し行に合わせてインデントを下げる
      first_day = Date.new(@year, i+1 , 1)
      first_day.wday.times do |b|
        days_of_month.unshift(["   "])
      end
      days_of_month.unshift("\n" + name_of_month[i] + " ")

      cal_arr.push([days_of_month])
    end

    #２次元配列を結合してカレンダーの形に整形
    cal_arr.join
  end
end

#テスト実行用
#require "date"
#today = Date.new(2024, 12, 9)
#calendar = SgStrangeCalendar.new(2024, today)
#puts calendar.generate