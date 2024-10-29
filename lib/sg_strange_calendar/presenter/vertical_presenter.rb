require 'date'

class SgStrangeCalendar
  class Presenter
    class VerticalPresenter
      def self.present(array, today)
        rows = [([today.year()] + array[0]).join(' ')] +
          # row[0] is left-justified
          # row[1..] is right-justified
          # rsrip is to remove trailing spaces
          array[1..].map do |row|
            date = row[1..].map do |cell|
              display_value(cell, today)
            end

            [
              row[0].ljust(4),
              date
            ].join(' ')
          end

        rows.join("\n")
      end

      class << self
        def display_value(value, today)
          # for debug
          # return '-+/' if(value.nil?)
          return '   ' if(value.nil?)
          # return "[#{value.day}]".rjust(3) if(is_today?(value, today))
          return value.day.to_s.rjust(3) if(value.is_a?(Date))
          value.to_s.rjust(3)
        end

        def is_today?(value, today)
          false
        end
      end
    end
  end
end
