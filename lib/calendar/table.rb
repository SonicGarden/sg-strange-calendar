module Calendar
  class Table
    def initialize(rows:, today: nil)
      @rows = rows
      @today = today
    end

    def generate(vertical: false)
      vertical ? generate_with_vertical : generate_with_horizontal
    end

    private

    def generate_with_horizontal
      header = @rows.first.join(' ')
      body = @rows[1..].map do |row|
        [
          "#{row.first} ",
          *row[1..].map do |cell|
            if cell.is_a?(Date)
              string_format = cell == @today ? '[%-d]' : '%_2d'
              cell.strftime(string_format)
            else
              '  '
            end
          end
        ].join(' ')
      end
      text = [header, *body].join("\n")
      return text unless @today

      replace_today_for_horizontal(text:, today: @today)
    end

    def generate_with_vertical
      header = transposed_rows.first.join(' ')
      body = transposed_rows[1..].map do |row|
        [
          "#{row.first}  ",
          *row[1..].map do |cell|
            if cell.is_a?(Date)
              string_format =
                if cell == @today
                  space_size = cell.day > 9 ? 0 : 1
                  ' ' * space_size + '[%-d]'
                else
                  '%_3d'
                end
              cell.strftime(string_format)
            else
              '   '
            end
          end
        ].join(' ').rstrip
      end
      text = [header, *body].join("\n")
      return text unless @today

      replace_today_for_vertical(text:, today: @today)
    end

    def transposed_rows
      return @transposed_rows if @transposed_rows

      max_length = @rows.map { |row| row.length }.max
      filled_rows = @rows.map do |row|
        row + [''] * (max_length - row.length)
      end
      @transposed_rows = filled_rows.transpose
    end

    def replace_today_for_horizontal(text:, today:)
      result = /[^\S\n\r]\[(#{today.day})\][^\S\n\r]?/.match(text)
      captured = result.to_a[0]
      text.gsub(captured, today.day > 9 ? captured.strip : captured.rstrip)
    end

    def replace_today_for_vertical(text:, today:)
      result = /\[(#{today.day})\][^\S\n\r]?/.match(text)
      captured = result.to_a[0]
      text.gsub(captured, captured.rstrip)
    end
  end
end

