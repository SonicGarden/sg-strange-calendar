require "date"
class SgStrangeCalendar  
  WEEKDAY_HEADER = "Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo"
  
  def initialize(year, today = nil)
    @year = year
    @today = today
    @calendar = generate_calendar_hash(year) # {"Jan" => {1 => "Mo", 2=>"Tu", ... }, "Feb"=>{1=>"Th", ... }, ...}
  end

  def generate(vertical: false)
    result = [@year.to_s + " " + WEEKDAY_HEADER]
    @calendar.each do |month, date|
      result.push(create_month_line(month, date))
    end
    puts result
    result.join("\n")
  end

  def generate_calendar_hash(year)
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
    result = [month + " "]
    target_date = 1
    
    WEEKDAY_HEADER.split(" ").each do |w|
      target_weekday = date[target_date]
      if target_weekday.nil?
        break
      end
      
      if w == target_weekday
        result.push(target_date.to_s.rjust(2))
        target_date += 1
      else
        result.push("  ")
      end
    end
    
    result.join(" ")
  end
end

# c = SgStrangeCalendar.new(2025)
# c.generate
