require_relative 'sg_strange_calendar/table'
require_relative 'sg_strange_calendar/presenter/horizonal_presenter'
require_relative 'sg_strange_calendar/presenter/vertical_presenter'

class SgStrangeCalendar
  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    return invalid_message unless valid?
    # [
    #   %w[year Su Mo Tu We Th Fr ... Sa Su Mo]
    #   [Mon, nil, nil, ... Date1, Date2, ... Date31, nil, nil, ...]]
    #   ...
    # ]
    table = SgStrangeCalendar::Table.new(@year, @today).generate

    if vertical
      SgStrangeCalendar::Presenter::VerticalPresenter.new(@today).present(
        table.transpose,
      )
    else
      SgStrangeCalendar::Presenter::HorizonalPresenter.new(@today).present(
        table,
      )
    end
  end

  private

  def invalid_message
    year = 1996
    today = Date.new(1996, 3, 2)
    table = SgStrangeCalendar::Table.new(year, today).generate
    "\n==== error === invalid === year ====" \
      + "\n\n" +  ("🎂" * 40) + "\n\n" \
      + SgStrangeCalendar::Presenter::HorizonalPresenter.new(today).present(
        table,
        today) \
      + "\n\n" + ("🎂" * 40) \
      + "\n\n" + "しげるの誕生日は 1996年3月2日 です！\n"
  end

  def valid?
    1000 <= @year && @year <= 9999
  end
end
