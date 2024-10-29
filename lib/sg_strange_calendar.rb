require_relative 'sg_strange_calendar/table'
require_relative 'sg_strange_calendar/presenter/horizonal_presenter'
require_relative 'sg_strange_calendar/presenter/vertical_presenter'

class SgStrangeCalendar
  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    # [
    #   %w[year Su Mo Tu We Th Fr ... Sa Su Mo]
    #   [Mon, nil, nil, ... Date1, Date2, ... Date31, nil, nil, ...]]
    #   ...
    # ]
    table = SgStrangeCalendar::Table.new(@year, @today).generate

    if vertical
      SgStrangeCalendar::Presenter::VerticalPresenter.new.present(
        table.transpose,
        @today
      )
    else
      SgStrangeCalendar::Presenter::HorizonalPresenter.new.present(
        table,
        @today
      )
    end
  end
end
