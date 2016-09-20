require 'colorize'
require_relative 'movement_modules'

class Piece
  attr_reader :color, :pos, :symbol

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @symbol = "-"
  end

  def valid_moves

  end

  def change_background(color)
    @symbol = @symbol.colorize(:background => color)
  end
end


class King < Piece
  include Stepable

  attr_reader :symbol

  def initialize(color, board, pos)
    @symbol = color == :black ? '♚' : '♔'
    super(color, board, pos)
  end

  protected

  def move_diffs
    diffs = []
    (-1..1).each do |row|
      (-1..1).each do |col|
        diffs << [row,col] unless row, col == 0,0
      end
    end
    diffs
  end
end

class Knight < Piece
  include Stepable

  def initialize(color, board, pos)
    @symbol = color == :black ? '♞' : '♘'
    super(color, board, pos)
  end

  protected

  def move_diffs
    [
      [1, 2],
      [1, -2],
      [-1, 2],
      [-1, -2],
      [2, 1],
      [2, -1],
      [-2, 1],
      [-2, -1]
              ]
  end
end

# ♛♚♝♞♜♟
# ♕♔♗♘♖♙

class Bishop < Piece
  include Slideable

  MOVE_DIRS = Slideable::DIAGONAL_DIRS

  attr_reader :symbol

  def initialize(color, board, pos)
    @symbol = color == :black ? '♝' : '♗'
    super(color, board, pos)
  end
end

class Rook < Piece
  include Slideable

  MOVE_DIRS = Slideable::HORIZONTAL_DIRS

  attr_reader :symbol

  def initialize(color, board, pos)
    @symbol = color == :black ? '♜' : '♖'
    super(color, board, pos)
  end
end
