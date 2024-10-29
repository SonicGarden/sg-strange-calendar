require 'date'

class SgStrangeCalendar
  class Presenter
    class HorizonalPresenter
      def self.present(array, today)
        array.map do |row|
          date = row[1..].map do |cell|
            display_value(cell, today)
          end.join(' ')
          # row[0] is left-justified
          # row[1..] is right-justified
          # rsrip is to remove trailing spaces
          str_row = [
            display_value(row[0], today).ljust(4),
            date
          ].join(' ').rstrip
          # [xx] を含む row は今日を含んでいると判断する
          if str_row.match?(/[\[|\]]/)
            # 右側へのはみ出しを削る
            str_row = str_row.match?(/\] /) ? str_row.gsub(/\] /, ']') : str_row
            # 2桁以上の場合は、左側へのはみ出しを削る
            if today.day > 9
              str_row = str_row.match?(/ \[/) ? str_row.gsub(/ \[/, '[') : str_row
            end
          end
          str_row
        end.join("\n")
      end

      class << self
        def display_value(value, today)
          # for debug
          # return '-+' if(value.nil?)
          return '  ' if(value.nil?)
          return "[#{value.day}]".rjust(2) if(is_today?(value, today))
          return value.day.to_s.rjust(2) if(value.is_a?(Date))

          value.to_s.rjust(2)
        end

        def is_today?(value, today)
          false if value.is_a?(Date)
          value == today
        end
      end
    end
  end
end
