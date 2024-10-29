require 'minitest/autorun'
require_relative '../../../lib/sg_strange_calendar/presenter/horizonal_presenter'

class SgStrangeCalendar::Presenter::HorizonalPresenterTest < Minitest::Test
  def test_present_with_no_nil
    expected = <<~TXT.chomp
      Jan   b  c  d  e  f  g
      Feb   i  j  k  l  m  n
    TXT
    array = [
      ['Jan', 'b', 'c', 'd', 'e', 'f', 'g'],
      ['Feb', 'i', 'j', 'k', 'l', 'm', 'n']
    ]
    today = Date.new(2025, 1, 1)
    presenter = SgStrangeCalendar::Presenter::HorizonalPresenter.present(array, today)
    assert_equal expected, presenter
  end

  def test_present_with_nil
    expected = <<~TXT.chomp
      Jan   b  c  d  e  f  g
      Feb   i  j  k  l  m
    TXT
    array = [
      ['Jan', 'b', 'c', 'd', 'e', 'f', 'g'],
      ['Feb', 'i', 'j', 'k', 'l', 'm', nil]
    ]
    today = Date.new(2025, 1, 1)
    presenter = SgStrangeCalendar::Presenter::HorizonalPresenter.present(array, today)
    assert_equal expected, presenter
  end

  def test_present_date
    expected = <<~TXT.chomp
      Jan   1  2  3  4  5  6
      Feb   i  j  k  l  m
    TXT
    array = [
      ['Jan'] + (1..6).to_a.map { |i| Date.new(2024, 1, i) },
      ['Feb', 'i', 'j', 'k', 'l', 'm', nil]
    ]
    today = Date.new(2025, 1, 1)
    presenter = SgStrangeCalendar::Presenter::HorizonalPresenter.present(array, today)
    assert_equal expected, presenter
  end

  def test_present_first_today
    expected = <<~TXT.chomp
      Jan  [1] 2  3  4  5  6
      Feb   i  j  k  l  m
    TXT
    array = [
      ['Jan'] + (1..6).to_a.map { |i| Date.new(2024, 1, i) },
      ['Feb', 'i', 'j', 'k', 'l', 'm', nil]
    ]
    today = Date.new(2024, 1, 1)
    presenter = SgStrangeCalendar::Presenter::HorizonalPresenter.present(array, today)
    assert_equal expected, presenter
  end
  def test_present_second_today
    expected = <<~TXT.chomp
      Jan   1 [2] 3  4  5  6
      Feb   i  j  k  l  m
    TXT
    array = [
      ['Jan'] + (1..6).to_a.map { |i| Date.new(2024, 1, i) },
      ['Feb', 'i', 'j', 'k', 'l', 'm', nil]
    ]
    today = Date.new(2024, 1, 2)
    presenter = SgStrangeCalendar::Presenter::HorizonalPresenter.present(array, today)
    assert_equal expected, presenter
  end
  def test_present_end_today
    expected = <<~TXT.chomp
      Jan  26 27 28 29 30[31]
      Feb   i  j  k  l  m
    TXT
    array = [
      ['Jan'] + (26..31).to_a.map { |i| Date.new(2024, 1, i) },
      ['Feb', 'i', 'j', 'k', 'l', 'm', nil]
    ]
    today = Date.new(2024, 1, 31)
    presenter = SgStrangeCalendar::Presenter::HorizonalPresenter.present(array, today)
    assert_equal expected, presenter
  end
end
