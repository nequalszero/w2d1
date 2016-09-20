require_relative 'piece'
require 'colorize'

class NoPieceFoundError < StandardError
  def initialize(pos)
    @message = "No piece in position #{pos}"
  end
end

class OutOfBoundsError < StandardError
  def initialize(pos)
    @message = "Position #{pos} out of bounds"
  end
end

class Board
  attr_reader :grid, :size

  def initialize
    @size = 8
    @grid = Array.new(@size) {Array.new(@size) {Piece.new}}
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def move(start, end_pos)
    raise NoPieceFoundError.new(start) if @grid[start] == NullPiece.instance
    raise OutOfBoundsError.new(start) unless in_bounds?(start)
    raise OutOfBoundsError.new(end_pos) unless in_bounds?(end_pos)

    ####### raise if the piece cannot move to end_pos #### INCOMPLETE #######
    @grid[end_pos] = @grid[start]
    @grid[start] = NullPiece.instance
  end

  def in_bounds?(pos)
    pos.all? {|coord| coord.between?(0, @size-1)}
  end

  def get_row_values(idx)
    @grid[idx].map{|piece| piece.value}
  end

  def highlight_pos(pos, bg_color)
    self[pos].change_background(bg_color)
  end

end
