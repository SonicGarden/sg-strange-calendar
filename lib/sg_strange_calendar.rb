# frozen_string_literal: true

require 'date'

class SgStrangeCalendar
  HORIZONTAL_WIDTH = 31 + 7 - 1 # 31 day + wdays - 1(overlapped)

  def initialize(year, today = nil)
    @year = year
    return unless today

    @today_month = today.month
    @today_month_arg = today.strftime('%b')
    @today_day = today.day
  end

  def generate(vertical: false)
    vertical ? generate_vertical : generate_horizontal
  end

  private

  def header
    # According to Date specifications, "Date.parse(str = '-4712-01-01')" is Monday
    [@year] + 37.times.map { |i| (Date.parse - 1 + i).strftime('%a')[0..1] }
  end

  def horizontal_calender_array
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

  def first_spacer(vertical: false)
    # horizontal:
    # ['Jan', nil, 1, 2]
    # -> "Jan      1  2"
    #        ~xxxYYYzzz  : Length of first_spacer(~) is 1
    #
    # vertical:
    # ['Th', 4, 1]
    # -> "Th     4   1 "
    #       ~~~xxxxYYYY  : Length of first_spacer(~) is 3
    vertical ? '   ' : ' '
  end

  def generate_horizontal
    horizontal_calender_array.map.with_index do |m, row|
      next m.join(' ') if row.zero?

      # ['Jan', nil, 1, 2]
      # -> "Jan      1  2"
      #        ~xxxYYYzzz  : first_spacer(~) length is 1
      line_arg = "#{m.first}#{first_spacer}"
      m[1..].each.with_index(1) do |day, column|
        line_arg << format('%3s', day)
      end
      # Horizontal mode have each 3 width, but 1 char overlapped following day.
      # So, replaces with "[day]" after created each lines.
      # convert from "  1  2  3" -> "  1 [2] 3"
      #                   ~~~ <- pick here and replace
      line_arg.sub!(/ #{@today_day}(\s|\z)/, "[#{@today_day}]") if m.first == @today_month_arg
      line_arg.strip
    end.join("\n")
  end

  def generate_vertical
    horizontal_calender_array.transpose.map.with_index do |m, row|
      next m.join(' ') if row.zero?

      line_arg = "#{m.first}#{first_spacer(vertical: true)}"
      m[1..].each.with_index(1) do |day, column|
        # Right side space is reserved for "]".
        day_arg = if @today_month == column && @today_day == day
                    "[#{day}]"
                  else
                    "#{day} "
                  end
        line_arg << format('%4s', day_arg)
      end
      line_arg.strip
    end.join("\n")
  end
end
