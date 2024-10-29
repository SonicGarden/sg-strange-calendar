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
          if(is_today?(value, today))
            return "[#{value.day}]".rjust(3)
          end
          return value.day.to_s.rjust(3) if(value.is_a?(Date))
          value.to_s.rjust(3)
        end

        def update_today_str(str_row, today)
          if today.day < 10
            str_row = str_row.gsub(/\] /, ']')
            str_row = str_row.gsub(/\[/, ' [')
          end

          str_row
        end
      end
    end
  end
end
