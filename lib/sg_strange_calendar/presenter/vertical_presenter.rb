require 'date'

class SgStrangeCalendar
  class Presenter
    class VerticalPresenter
      def self.present(array, today)
        rows = [(array[0]).join(' ')] +
          # row[0] is left-justified
          # row[1..] is right-justified
          # rsrip is to remove trailing spaces
          str_row = array[1..].map do |row|
            date = row[1..].map do |cell|
              display_value(cell, today)
            end

            str_row = [
              row[0].ljust(4),
              date
            ].join(' ')
            # [xx] を含む row は今日を含んでいると判断する
            # 1文字右側にずらす
            if !today.nil? && today.day < 10
              str_row = str_row.gsub(/\] /, ']')
              str_row = str_row.gsub(/\[/, ' [')
            end
            str_row.rstrip
          end
        rows.join("\n")
      end

      class << self
        def display_value(value, today)
          # for debug
          # return '-+/' if(value.nil?)
          return '   ' if(value.nil?)
          if(is_today?(value, today))
            return "[#{value.day}]".rjust(3)
          end
          return value.day.to_s.rjust(3) if(value.is_a?(Date))
          value.to_s.rjust(3)
        end

        def is_today?(value, today)
          false if value.is_a?(Date)
          value == today
        end
      end
    end
  end
end
