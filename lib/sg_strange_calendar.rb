require_relative 'sg_strange_calendar/table'
require_relative 'sg_strange_calendar/presenter/horizonal_presenter'

class SgStrangeCalendar
  def initialize(year, today = nil)
    @year = year
    @today = today || Date.today
  end

  def generate(vertical: false)
    # [
    #   %w[year Su Mo Tu We Th Fr ... Sa Su Mo]
    #   [Mon, nil, nil, ... Date1, Date2, ... Date31, nil, nil, ...]]
    #   ...
    # ]
    table = SgStrangeCalendar::Table.new(@year, @today)
    SgStrangeCalendar::Presenter::HorizonalPresenter.present(table.generate)
  end
end
