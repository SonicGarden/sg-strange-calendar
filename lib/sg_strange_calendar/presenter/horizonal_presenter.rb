require 'date'
require_relative 'base_presenter'

class SgStrangeCalendar
  class Presenter
    class HorizonalPresenter < BasePresenter
      class << self
        def display_value(value, today)
          # for debug
          # return '-+' if(value.nil?)
          return '  ' if(value.nil?)
          return "[#{value.day}]".rjust(2) if(is_today?(value, today))
          return value.day.to_s.rjust(2) if(value.is_a?(Date))

          value.to_s.rjust(2)
        end

        def update_today_str(str_row, today)
          # 2桁以上の場合は、左側へのはみ出しを削る
          str_row = str_row.gsub(/ \[/, '[') if today.day > 9

          # 右側へのはみ出しを削る
          str_row.gsub(/\] /, ']')
        end
      end
    end
  end
end
