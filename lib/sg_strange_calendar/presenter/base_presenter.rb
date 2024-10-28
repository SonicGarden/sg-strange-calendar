require_relative 'sg_strange_calendar/presenter/base_presenter'

class BasePresenter
  def present
    raise NotImplementedError, "You must implement the present method"
  end
end
