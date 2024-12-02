# frozen_string_literal: true

require 'date'

class SgStrangeCalendar
  DAY_CELLS = 37

  DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31].freeze

  HEADER = {
    month: Date::ABBR_MONTHNAMES,
    day:   Date::DAYNAMES.map { _1[0, 2] }.cycle.first(DAY_CELLS)
  }.freeze

  CONVERTER_AND_ROW_FORMAT = {
    horizontal: [:itself,    "%-4s#{'%3s' * DAY_CELLS}"],
    vertical:   [:transpose, "%-4s#{'%4s' * 12}"]
  }.freeze

  def initialize(year, today = nil)
    @year = year
    @today = today
    @horizontal_grid = horizontal_grid_only_header

    fill_horizontal_grid_with_marked_days
  end

  def generate(vertical: false)
    direction = vertical ? :vertical : :horizontal

    converter, row_format = CONVERTER_AND_ROW_FORMAT[direction]
    grid = converter.to_proc[@horizontal_grid]

    grid.map { |row| (row_format % row).rstrip }.join("\n").chomp
      .sub(/-(\d+) ?/) { "[#{$1}]" }
  end

  private

  def horizontal_grid_only_header
    HEADER[:month].zip.tap { |grid| grid[0] = [@year, *HEADER[:day]] }
  end

  def fill_horizontal_grid_with_marked_days
    1.upto(12).each do |month|
      # 月初のwdayが欲しいだけなので、本当はDate.newより計算した方が速いはず(が、何も見ずに書けない :<
      start_index = Date.new(@year, month, 1).wday + 1

      @horizontal_grid[month][start_index..] = marked_days(month:)
      @horizontal_grid[month][DAY_CELLS] ||= nil # 要素数を揃える
    end
  end

  def marked_days(month:)
    Array(1..end_of(month:)).tap do |days|
      # @todayがある時は当該日を[]で囲む時のマーカーとして負数にしておく
      days[@today.day - 1] *= -1 if @today&.month == month
    end
  end

  def end_of(month:)
    if month == 2 && Date.gregorian_leap?(@year)
      29
    else
      DAYS_IN_MONTH[month]
    end
  end
end
