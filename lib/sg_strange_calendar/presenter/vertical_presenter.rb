require 'date'
require_relative 'base_presenter'

class SgStrangeCalendar
  class Presenter
    class VerticalPresenter < BasePresenter
      SPACE_SIZE = 3
      def space_size
        SPACE_SIZE
      end

      def update_today_str(str_row, today)
        # 10 文字より小さかったら、日付の前にスペースを追加
        # 1 文字ずつずらす
        return str_row.gsub(/\] /, ']').gsub(/\[/, ' [') if today.day < 10

        str_row
      end
    end
  end
end
