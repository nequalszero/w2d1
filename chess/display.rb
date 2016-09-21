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

  def get_cursor_input (message)
    while true
      system('clear')
      render
      puts message
      position = @cursor.get_input
      move_highlight
      return position if position.is_a?(Array)
    end
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
  board = Board.new
  board.debug_place([0,4], :black, King)
  board.debug_place([1,3], :black, Pawn)
  board.debug_place([1,5], :black, Pawn)
  board.debug_place([0,3], :black, Pawn)
  board.debug_place([0,5], :black, Pawn)
  board.debug_place([2,4], :white, Rook)
  board.debug_place([3,1], :white, Bishop)
  board.debug_place([3,7], :white, Bishop)
  display = Display.new(board)
  display.render
  puts board.in_check?(:black)
  puts board.check_mate?(:black)
end
