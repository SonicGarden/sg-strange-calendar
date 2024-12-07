class BasePresenter
  def initialize(today)
    @today = today
  end

  def present(array)
    (header(array) + content(array)).join("\n")
  end

  def header(array)
    [(array[0]).join(' ')]
  end

  def content(array)
    array[1..].map do |row|
      str_row = normal_row(row)
      # [xx] を含む row は今日を含んでいると判断する
      if is_contain_today?(str_row)
        str_row = update_today_str(str_row)
      end
      # rsrip is to remove trailing spaces
      str_row.rstrip
    end
  end

  def normal_row(row)
    # row[0] is left-justified
    # row[1..] is right-justified
    [
      row[0].ljust(4), # 4 equal years length
      row[1..].map do |cell|
        display_value(cell)
      end
    ].join(' ')
  end

  def display_value(value)
    # for debug
    # return '-+' if(value.nil?)
    return ' '.rjust(space_size) if(value.nil?)
    return "[#{value.day}]".rjust(space_size) if(is_today?(value))
    return value.day.to_s.rjust(space_size) if(value.is_a?(Date))

    value.to_s.rjust(space_size)
  end

  def is_today?(value)
    false if value.is_a?(Date)
    value == @today
  end

  def is_contain_today?(str_row)
    str_row.match?(/[\[|\]]/)
  end
end
