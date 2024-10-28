require 'minitest/autorun'
require_relative '../../../lib/sg_strange_calendar/presenter/horizonal_presenter'

class SgStrangeCalendar::Presenter::HorizonalPresenterTest < Minitest::Test
  def test_present_with_no_nil
    expected = <<~TXT.chomp
      Jan  b  c  d  e  f  g
      Feb  i  j  k  l  m  n
    TXT
    array = [
      ['Jan', 'b', 'c', 'd', 'e', 'f', 'g'],
      ['Feb', 'i', 'j', 'k', 'l', 'm', 'n']
    ]
    presenter = SgStrangeCalendar::Presenter::HorizonalPresenter.present(array)
    assert_equal expected, presenter
  end

  def test_present_with_nil
    expected = <<~TXT.chomp
      Jan  b  c  d  e  f  g
      Feb  i  j  k  l  m
    TXT
    array = [
      ['Jan', 'b', 'c', 'd', 'e', 'f', 'g'],
      ['Feb', 'i', 'j', 'k', 'l', 'm', nil]
    ]
    presenter = SgStrangeCalendar::Presenter::HorizonalPresenter.present(array)
    assert_equal expected, presenter
  end

  def test_present_date
    expected = <<~TXT.chomp
      Jan  1  2  3  4  5  6
      Feb  i  j  k  l  m
    TXT
    array = [
      ['Jan'] + (1..6).to_a.map { |i| Date.new(2024, 1, i) },
      ['Feb', 'i', 'j', 'k', 'l', 'm', nil]
    ]
    presenter = SgStrangeCalendar::Presenter::HorizonalPresenter.present(array)
    assert_equal expected, presenter
  end
end
