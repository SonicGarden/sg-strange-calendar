require 'date'

class SgStrangeCalendar
  class Presenter
    class HorizonalPresenter
      def self.present(array)
        array.map do |row|
          date = row[1..].map do |cell|
            display_value(cell)
          end.join(' ')
          # row[0] is left-justified
          # row[1..] is right-justified
          # rsrip is to remove trailing spaces
          [
            display_value(row[0]).ljust(4),
            date
          ].join(' ').rstrip
        end.join("\n")
      end

      class << self
        def display_value(value)
          # for debug
          # return '-+' if(value.nil?)
          return '  ' if(value.nil?)
          return value.day.to_s.rjust(2) if(value.is_a?(Date))

          value.to_s.rjust(2)
        end
      end
    end
  end
end
