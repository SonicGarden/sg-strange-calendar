# frozen_string_literal: true

require 'date'

class SgStrangeCalendar
  HORIZONTAL_WIDTH = 31 + 7 - 1 # 31 day + wdays - 1(overlapped)

  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    array = vertical ? calender_array.transpose : calender_array
    array.map.with_index do |m, row|
      next m.join(' ') if row.zero?

      # horizontal:
      # ['Jan', nil, 1, 2]
      # -> "Jan      1  2"
      #        ~xxxYYYzzz  : numof "~" is 1
      #
      # vertical:
      # ['Th', 4, 1]
      # -> "Th     4   1 "
      #       ~~~xxxxYYYY  : numof "~" is 3
      first_spacer = vertical ? '   ' : ' '
      line_arg = "#{m.first}#{first_spacer}"
      m[1..].each.with_index(1) do |day, column|
        if vertical
          day_arg = if @today&.month == column && @today&.day == day
                      "[#{day}]"
                    else
                      "#{day} " # Right side space is reserved for "]".
                    end
          line_arg << format('%4s', day_arg)
        else
          line_arg << format('%3s', day)
        end
      end
      # Horizontal mode have each 3 width, but 1 char overlapped following day.
      # So, replaces with "[day]" after created each lines.
      if !vertical && m.first == @today&.strftime('%b')
        # convert from "  1  2  3" -> "  1 [2] 3"
        #                   ~~~ <- pick here
        line_arg.sub!(/ #{@today.day}(\s|\z)/, "[#{@today.day}]")
      end
      line_arg.strip
    end.join("\n")
  end

  private

  def header
    # According to Date specifications, "Date.parse(str = '-4712-01-01')" is Monday
    [@year] + 37.times.map { |i| (Date.parse - 1 + i).strftime('%a')[0..1] }
  end

  def calender_array
    [header] +
      12.times.map do |i|
        first_day = Date.parse("#{@year}-#{i + 1}-1")
        last_day = first_day.next_month - 1
        days = last_day.day
        begin_margin = [nil] * first_day.wday
        days_ary = 1.upto(days).to_a
        ary = [first_day.strftime('%b')] + begin_margin + days_ary
        ary.fill(ary.size..HORIZONTAL_WIDTH) { nil }
      end
  end
end
