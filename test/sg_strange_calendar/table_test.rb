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
end