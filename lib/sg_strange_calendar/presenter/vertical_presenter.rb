require 'date'
require_relative 'base_presenter'

class SgStrangeCalendar
  class Presenter
    class VerticalPresenter < BasePresenter
      SPACE_SIZE = 3
      def space_size
        SPACE_SIZE
      end

      def update_today_str(str_row)
        # 2桁以上は、右側へのはみ出しを削る
        str_row = str_row.gsub(/\[/, ' [') if @today.day < 10

        # 右側へのはみ出しを削る
        str_row.gsub(/\] /, ']')
      end
    end
  end
end
