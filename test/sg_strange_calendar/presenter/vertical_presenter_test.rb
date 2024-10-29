require 'minitest/autorun'
require_relative '../../../lib/sg_strange_calendar/presenter/vertical_presenter'

class SgStrangeCalendar::Presenter::VerticalPresenterTest < Minitest::Test
  def test_header
    expected = <<~TXT.chomp
      2024 Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
    TXT
    array = [
      %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]
    ]
    today = Date.new(2024, 1, 1)
    presenter = SgStrangeCalendar::Presenter::VerticalPresenter.present(array, today)
    assert_equal expected, presenter
  end
  def test_first_row
    expected = <<~TXT.chomp
      2024 Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
      Su                                     1           1
    TXT
    array = [
      %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec],
      ['Su', nil, nil, nil, nil, nil, nil, nil, nil, 1, nil, nil, 1]
    ]
    today = Date.new(2024, 1, 1)
    presenter = SgStrangeCalendar::Presenter::VerticalPresenter.present(array, today)
    assert_equal expected, presenter
  end
end
