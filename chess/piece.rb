require 'colorize'
require_relative 'movement_modules'

class Piece
  attr_reader :color, :symbol, :pos

  HORIZONTAL_DIRS = [ [1,0], [0,1], [-1,0], [0,-1] ]
  DIAGONAL_DIRS = [ [1,1], [-1,1], [1,-1], [-1,-1] ]

  def initialize(color, board, pos, symbol = "-")
    @color = color
    @board = board
    @pos = pos
    @symbol = symbol
  end

  def valid_moves
    valid = []
    moves.each do |poss_move|
      new_board = @board.dup
      new_board.move(@pos, poss_move)
      valid << poss_move unless new_board.in_check?(@color)
    end
    valid
  end

  def update_pos(pos)
    @pos = pos
  end

  def in_bounds?(pos)
    pos.all? {|coord| coord.between?(0,7)}
  end

  def unoccupied?(pos)
    @board[pos].color == nil
  end

  def blocked?(pos)
    #checks if piece in pos is our color
    @board[pos].color == @color
  end

  def opponent?(pos)
    @board[pos].color != @color && @board[pos].color != nil
  end

  def change_background(color)
    @symbol = @symbol.colorize(:background => color)
  end
end


class King < Piece
  include Stepable

  def initialize(color, board, pos)
    symbol = color == :black ? '♚' : '♔'
    super(color, board, pos, symbol)
  end

  protected

  def move_diffs
    Piece::HORIZONTAL_DIRS + Piece::DIAGONAL_DIRS
  end
end

class Knight < Piece
  include Stepable

  def initialize(color, board, pos)
    symbol = color == :black ? '♞' : '♘'
    super(color, board, pos, symbol)
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

  MOVE_DIRS = Piece::DIAGONAL_DIRS

  def initialize(color, board, pos)
    symbol = color == :black ? '♝' : '♗'
    super(color, board, pos, symbol)
  end
end

class Rook < Piece
  include Slideable

  MOVE_DIRS = Piece::HORIZONTAL_DIRS

  def initialize(color, board, pos)
    symbol = color == :black ? '♜' : '♖'
    super(color, board, pos, symbol)
  end
end

class Queen < Piece
  include Slideable

  MOVE_DIRS = Piece::HORIZONTAL_DIRS + Piece::DIAGONAL_DIRS

  def initialize(color, board, pos)
    symbol = color == :black ? '♛' : '♕'
    super(color, board, pos, symbol)
  end
end

class Pawn < Piece


  def initialize(color, board, pos)
    symbol = color == :black ? '♟' : '♙'
    super(color, board, pos, symbol)
  end

  def valid_move?(pos)
    in_bounds?(pos) && unoccupied?(pos)
  end

  def moves
    possible_moves = []
    possible_moves << forward_dir unless forward_dir.empty?
    possible_moves += side_attacks unless side_attacks.empty?
    if at_start_row? && !forward_dir.empty?
      possible_moves += start_move
    end
    possible_moves
  end

  def start_move
    forward_move = @color == :white ? [-1, 0] : [1, 0]
    possible_move = forward_move.map { |el| el*2}
    possible_move = possible_move.map.with_index { |el, idx| el + @pos[idx] }
    if valid_move?(possible_move) && !opponent?(possible_move)
      return [possible_move]
    end
    []
  end

  # assuming white starts at the bottom
  def forward_dir
    forward_move = @color == :white ? [-1, 0] : [1, 0]
    forward_move = forward_move.map.with_index { |el, idx| el + @pos[idx] }
    if valid_move?(forward_move)
      return forward_move
    end
    []
  end

  def side_attacks
    attacks = @color == :white ? [[-1, -1], [-1, 1]] : [[1, 1], [1, -1]]
    attacks = attacks.map do |attack|
      attack.map.with_index { |el, idx| el + @pos[idx] }
    end
    attacks.select { |attack| in_bounds?(attack) && opponent?(attack)}
  end

  def at_start_row?
    if @color == :black
      @pos[0] == 1
    else
      @pos[0] == 6
    end
  end
end
