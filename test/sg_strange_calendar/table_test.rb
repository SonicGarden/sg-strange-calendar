require 'minitest/autorun'
require 'date'
require_relative '../../lib/sg_strange_calendar/table'

class SgStrangeCalendar::TableTest < Minitest::Test
  def test_header
    expected = <<~TXT.chomp
      2024 Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo
    TXT
    table = SgStrangeCalendar::Table.new(2024).generate
    assert_equal expected, table[0].join(' ')
  end

  def test_rows_count
    expected = 12 + 1
    table = SgStrangeCalendar::Table.new(2024).generate
    assert_equal expected, table.size
  end

  def test_rows_length
    expected = SgStrangeCalendar::Table::WEEKDAYS.size + 1
    table = SgStrangeCalendar::Table.new(2024).generate
    table.each do |row|
      assert_equal expected, row.size
    end
  end

  def test_contents
    table = SgStrangeCalendar::Table.new(2024).generate
  end
end
