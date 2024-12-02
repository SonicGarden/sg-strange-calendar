class Month
  attr_reader :name, :number, :last_day

  FIRST_DAY = 1

  def initialize(year, name, number)
    @year = year
    @name = name
    @number = number
  end

  def start_wday
    Date.new(@year, @number, FIRST_DAY).wday
  end

  def last_day
    Date.new(@year, @number, -1).day
  end

  def end_of_month?(date)
    date.day == Date.new(date.year, @number, -1).day
  end
end
