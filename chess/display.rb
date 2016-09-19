require_relative 'cursor'
require_relative 'board'
require 'colorize'

class Display
  attr_reader :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def render
    render_column_label
    render_border
    @board.grid.each_with_index { |row, idx| render_row(row, idx) }
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

  def render_row(row, idx)
    display_arr = row.map { |piece| piece.value }
    row_string =  " #{idx} | " + display_arr.join("  ") + " | "
    puts row_string
  end
end


if __FILE__ == $PROGRAM_NAME
  new_board = Board.new
  display = Display.new(new_board)
  while true
    display.render
    display.cursor.get_input
  end
end
