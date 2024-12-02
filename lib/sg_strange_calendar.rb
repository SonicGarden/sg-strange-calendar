require 'date'
require_relative 'month'

class SgStrangeCalendar
  DAYS = %w[
    Su Mo Tu We Th Fr Sa
    Su Mo Tu We Th Fr Sa
    Su Mo Tu We Th Fr Sa
    Su Mo Tu We Th Fr Sa
    Su Mo Tu We Th Fr Sa Su Mo
  ].freeze

  ALL_DAYS_COUNT = 37

  def initialize(year, today = nil)
    @year = year
    @today = today
    @months = define_months
  end

  def generate(vertical: false)
    vertical ? display_vertical() : display_horizontal()
  end

  private

  def define_months
    [
      Month.new(@year, 'Jan', 1),
      Month.new(@year, 'Feb', 2),
      Month.new(@year, 'Mar', 3),
      Month.new(@year, 'Apr', 4),
      Month.new(@year, 'May', 5),
      Month.new(@year, 'Jun', 6),
      Month.new(@year, 'Jul', 7),
      Month.new(@year, 'Aug', 8),
      Month.new(@year, 'Sep', 9),
      Month.new(@year, 'Oct', 10),
      Month.new(@year, 'Nov', 11),
      Month.new(@year, 'Dec', 12)
    ].freeze
  end

  def display_vertical
  end

  def display_horizontal
    output = []
    output << generate_header()
    output << generate_months()
    output.join("\n")
  end

  def generate_header
    "#{@year} #{DAYS.join(' ')}"
  end

  def generate_months
    @months.map do |month|
      if month.name == @today&.strftime('%b')
        days_in_month = generate_days_in_month(month, today_marker: true)
        leading_spaces = calculate_spaces(month)
        display_days_in_month(month, days_in_month, leading_spaces, today_marker: true)
      else
        days_in_month = generate_days_in_month(month)
        leading_spaces = calculate_spaces(month)
        display_days_in_month(month, days_in_month, leading_spaces, today_marker: false)
      end
    end
  end

  def generate_days_in_month(month, today_marker: false)
    days_in_month = Array.new(ALL_DAYS_COUNT, '  ')
    start_day = month.start_wday

    (1..month.last_day).each do |d|
      days_in_month[start_day + d - 1] = d.to_s.rjust(2, ' ')
    end

    days_in_month[@today.day + start_day - 1] = "[#{@today.day}]".rjust(4, ' ') if today_marker
    days_in_month
  end

  def display_days_in_month(month, days_in_month, leading_spaces, today_marker: false)
    if today_marker 
      start_day = month.start_wday
      days_in_month_until_today = days_in_month[0..(start_day + @today.day - 2)]
      days_today = days_in_month[start_day + @today.day - 1]
      days_in_month_after_today = days_in_month[start_day + @today.day..-1]

      if month.first_day_of_month?(@today) && month.start_wday == 0
        days_in_month_until_today = days_in_month[0..(start_day + @today.day - 1)]
        "#{month.name}#{leading_spaces}#{days_in_month_until_today.join(' ')}#{days_in_month_after_today.join(' ').rstrip}"
      elsif month.first_day_of_month?(@today)
        "#{month.name} #{leading_spaces}#{days_in_month_until_today.join(' ')}#{days_today}#{days_in_month_after_today.join(' ').rstrip}"
      elsif month.end_of_month?(@today)
        "#{month.name} #{leading_spaces}#{days_in_month_until_today[0..-1].join(' ')}#{days_today}"
      else

        "#{month.name} #{leading_spaces}#{days_in_month_until_today.join(' ')}#{days_today}#{days_in_month_after_today.join(' ').rstrip}"
      end
    else

      "#{month.name} #{leading_spaces}#{days_in_month.join(' ').rstrip}"
    end
  end

  def calculate_spaces(month)
    ' ' * [1, @year.to_s.split('').count - 3].max
  end
end
