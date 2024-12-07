class SgStrangeCalendar
  WDAYS = %w(Su Mo Tu We Th Fr Sa).freeze

  def initialize(year, today = nil)
    @table = [[year.to_s, WDAYS * 5, WDAYS[0..1]].flatten]
    (1..12).each do |month|
      first_date = Date.new(year, month)
      last_date = Date.new(year, month, -1)
      days = (1..last_date.day).to_a
      if (today && today.month == month) then
        days[today.day - 1] = "M#{today.day}"
      end
      row = Array.new(@table[0].length).fill("")
      row[0] = first_date.strftime("%b")
      row[first_date.wday + 1..first_date.wday + days.length] = days
      @table.push row
    end
  end

  def generate(vertical: false)
    if (vertical) then
      @table = @table.transpose
    end
    widths = @table[0].map.with_index {|txt, i| i == 0 ? txt.length : txt.length + 1 }
    @table.each_with_object("") do |row, result|
      row.each_with_index do |txt, i|
        result << (i == 0 ? txt.ljust(widths[i]) : txt.to_s.rjust(widths[i]))
      end
      result.rstrip!
      result << "\n"
    end.chomp.gsub(/M(\d+).?/, '[\1]')
  end
end
