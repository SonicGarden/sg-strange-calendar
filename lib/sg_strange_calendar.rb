require "date"
class SgStrangeCalendar  
  WEEKDAY_HEADER = "Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo"
  
  def initialize(year, today = nil)
    @year = year
    @today = today
    @calendar = create_calendar_hash(year) # {"Jan" => {1 => "Mo", 2=>"Tu", ... }, "Feb"=>{1=>"Th", ... }, ...}
  end

  def generate(vertical: false)
    result = [@year.to_s + " " + WEEKDAY_HEADER]
    @calendar.each do |month, date|
      result.push(create_month_line(month, date))
    end
    adjust_space(result.join("\n"))
  end

  def create_calendar_hash(year)
    result = {}

    Date.new(year, 1, 1).step(Date.new(year, 12, 31)).each do |date|
      month = date.strftime("%b") # ex: Jan
      weekday = date.strftime("%a")[0, 2] # ex: Mo

      result[month] ||= {}
      result[month][date.day] = weekday
    end

    result
  end

  def create_month_line(month, date)
    result = [month.ljust(4)]
    target_date = 1
    
    WEEKDAY_HEADER.split(" ").each do |w|
      target_weekday = date[target_date]
      if target_weekday.nil?
        break
      end
      
      if w == target_weekday
        if isToday(month, target_date)
          result.push("[" + target_date.to_s + "]")
        else
          result.push(target_date.to_s.rjust(2))
        end
        target_date += 1
      else
        result.push("  ")
      end
    end
    
    result.join(" ")
  end

  def isToday(targe_month, target_date)
    !@today.nil? && @today.strftime("%Y") == @year.to_s && @today.strftime("%b") == targe_month && @today.strftime("%d") == target_date.to_s.rjust(2, "0")
  end
end

def adjust_space(target)
  if @today.nil?
    return target
  end

  @today.strftime("%d").to_i < 10 ? target.gsub("] ", "]") : target.gsub(" [", "[").gsub("] ", "]")
  
end

today = Date.new(2024, 12, 31)
c = SgStrangeCalendar.new(2024, today)
c.generate
