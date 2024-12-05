require 'date'

class SgStrangeCalendar
  def initialize(year, today = nil)
    # 引数保存
    @save_today = today
    @save_year = year

    # 開始と終端の設定
    @start_date = Date.new(year, 1, 1)
    @end_date = Date.new(year, 12, 31)

    # 固定文字列の用意
    @month_str =  ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    @wday_str = ['Su','Mo','Tu','We','Th','Fr','Sa','Su','Mo','Tu','We','Th','Fr','Sa','Su','Mo','Tu','We','Th','Fr','Sa','Su','Mo','Tu','We','Th','Fr','Sa','Su','Mo','Tu','We','Th','Fr','Sa','Su','Mo']


    # １年分の配列を保存する変数
    @yearList = Array.new()

    # 表示用の配列を用意
    index_date =  @start_date
    mounth_day_str = ''
    while @end_date + 1 >= index_date do
      # 月初めに月の配列を用意
      if index_date.day == 1 then
        # 終端の空白の配列を作成
        if mounth_day_str != '' then
          endblank = 1 + @wday_str.length - mounth_day_str.length
          endblank.times{
            mounth_day_str.push('  ')
          }
        end

        # 年を終えたので終了
        if index_date.year != @save_year then
          return
        end
        # 月の配列を用意
        mounth_day_str = Array.new()
        @yearList.push(mounth_day_str)

        # 繰り返し処置用の空白。最初の要素は何もしない
        mounth_day_str.push('  ')

        # 曜日分の空白を追加
        index_date.wday.times{
          mounth_day_str.push('  ')
        }
      end

      # todayの文字列か通常の文字列かを判別して追加する
      if  @save_today != nil and @save_today == index_date then
        mounth_day_str.push(sprintf("[%d]", index_date.day)) 
      else
        mounth_day_str.push(sprintf("%2d", index_date.day)) 
      end
      index_date = index_date + 1
    end
  end

  def generate(vertical: false)
    result = ""

    # 年を設定
    result = @save_year.to_s + ' '
    if vertical then
      # 縦方向用
      result += @month_str.join(' ')
      @wday_str.each_with_index {|wday_str, wday_index|
        result += "\n" + wday_str
        temp = '  '
        space = ''
        @month_str.each_with_index {|mounth_str, mounth_index|
          # 挿入する空白を判別
          if  @yearList[mounth_index][wday_index + 1].length == 4
            # 10-31のToday文字用
            space = ' '
          elsif mounth_index > 0 and @yearList[mounth_index - 1][wday_index + 1].length > 2 then
            # Today文字後用
            space = ' '
          else
            # 通常および1-9のToday文字用
            space = '  '
          end

          # 数値があるまで、空白をスキップする処理
          if @yearList[mounth_index][wday_index + 1].to_s == '  ' then
            temp += space + @yearList[mounth_index][wday_index + 1].to_s
          else 
            result += temp + space + @yearList[mounth_index][wday_index + 1].to_s
            temp = ''
          end
        }
      }
    else
      result += @wday_str.join(' ')
      @yearList.each_with_index {|mounth_day,index|
        result += "\n" + @month_str[index] + ' '
        mounth_day.each_with_index{|day_str,day_index|
          # 一つ前の値をチェックする関係で、１つ目スキップ。そのため、１つ目はダミーになっている
          if day_index > 0 then
            # 数値の前に空白が必要かをチェック
            if day_str.length <= 3 and mounth_day[day_index - 1].length < 3 then
              result += ' ' + day_str
            else
              result += day_str
            end

            # 月の最終日以降の空白を出力させないための終了判定処理。
            if day_index > 7 and mounth_day[day_index + 1] == "  " then
              break
            end
          end
        }
      }
    end
    return result
  end
end

