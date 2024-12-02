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
    header_output = []
    months_output = []
    header_output << generate_vertical_header()
    months_output << generate_vertical_months()
    header_output.join("\n") + "\n" + months_output.join("\n")
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

  def generate_vertical_header
    "#{@year} #{@months.map(&:name).join(' ')}"
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

  def generate_vertical_months
    arr = []
    @months.map do |month|
      days_in_month = generate_days_in_month(month)
      leading_spaces = calculate_spaces(month)
      days_in_month += [nil] * (31 - days_in_month.size)
      arr << days_in_month
    end
    p arr.transpose
  end

  def generate_days_in_month(month, today_marker: false)
    days_in_month = (Month::FIRST_DAY..month.last_day).map { |d| d.to_s.rjust(2, ' ') }
    days_in_month[@today.day - 1] = "[#{@today.day}]" if today_marker
    days_in_month
  end

  def display_days_in_month(month, days, leading_spaces, today_marker: false)
    if today_marker
      days_in_month_until_today = (Month::FIRST_DAY..@today.day).map { |d| d.to_s.rjust(2, ' ') }
      days_in_month_until_today[@today.day - 1] = "[#{@today.day}]"
      days_in_month_after_today = (@today.day + 1..month.last_day).map { |d| d.to_s.rjust(2, ' ') }

      if month.end_of_month?(@today)
        "#{month.name} #{leading_spaces}#{days_in_month_until_today[0..-2].join(' ')}#{days_in_month_until_today.last}"
      else
        "#{month.name} #{leading_spaces}#{days_in_month_until_today.join(' ')}#{days_in_month_after_today.join(' ')}"
      end
    else
      "#{month.name} #{leading_spaces}#{days.join(' ')}"
    end
  end

  def calculate_spaces(month)
    ' ' * [1, @year.to_s.split('').count - 3].max + ' ' * month.start_wday * 3
  end
end
