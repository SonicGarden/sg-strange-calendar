require 'date'
require_relative 'base_presenter'

class SgStrangeCalendar
  class Presenter
    class VerticalPresenter < BasePresenter
      class << self
        def display_value(value, today)
          # for debug
          # return '-+*' if(value.nil?)
          return '   ' if(value.nil?)
          return "[#{value.day}]".rjust(3) if(is_today?(value, today))
          return value.day.to_s.rjust(3) if(value.is_a?(Date))

          value.to_s.rjust(3)
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
end
