class BasePresenter
  def present(array, today)
    (header(array) + content(array, today)).join("\n")
  end

  def header(array)
    [(array[0]).join(' ')]
  end

  def content(array, today)
    array[1..].map do |row|
      str_row = normal_row(row, today)
      # [xx] を含む row は今日を含んでいると判断する
      if is_contain_today?(str_row)
        str_row = update_today_str(str_row, today)
      end
      # rsrip is to remove trailing spaces
      str_row.rstrip
    end
  end

  def normal_row(row, today)
    # row[0] is left-justified
    # row[1..] is right-justified
    [
      row[0].ljust(4), # 4 equal years length
      row[1..].map do |cell|
        display_value(cell, today)
      end
    ].join(' ')
  end

  def display_value(value, today)
    # for debug
    # return '-+' if(value.nil?)
    return ' '.rjust(space_size) if(value.nil?)
    return "[#{value.day}]".rjust(space_size) if(is_today?(value, today))
    return value.day.to_s.rjust(space_size) if(value.is_a?(Date))

    value.to_s.rjust(space_size)
  end

  def is_today?(value, today)
    false if value.is_a?(Date)
    value == today
  end

  def is_contain_today?(str_row)
    str_row.match?(/[\[|\]]/)
  end
end
