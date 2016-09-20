require_relative 'cursor'
require_relative 'board'
require 'colorize'

class Display
  attr_reader :cursor

  HIGHLIGHT = :light_green
  BACKGROUND = :black

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def render
    system('clear')
    render_column_label
    render_border
    @board.grid.each_with_index { |row, idx| render_row(idx) }
    render_border
  end

  def render_column_label
    column_label =  "     " + (0..@board.size - 1).to_a.join("  ") + "   "
    puts column_label
  end

  def render_border
    border = "   +-" + ("-" * (3 * @board.size - 2)) + "-+ "
    puts border
  end

  def render_row(idx)
    display_arr = @board.get_row_values(idx)
    row_string =  " #{idx} | " + display_arr.join("  ") + " | "
    puts row_string
  end

  def move_highlight(old_pos = @cursor.previous_pos, new_pos = @cursor.cursor_pos)
    @board.highlight_pos(new_pos, HIGHLIGHT)
    @board.highlight_pos(old_pos, BACKGROUND) unless old_pos.nil?
  end

end


if __FILE__ == $PROGRAM_NAME
  new_board = Board.new
  display = Display.new(new_board)
  while true
    display.render
    display.cursor.get_input
    display.move_highlight
  end
end
