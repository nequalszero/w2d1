require_relative 'piece'
require_relative 'null_piece'
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

  PIECES_HASH = {
    King => {
      :white => [[7, 4]],
      :black => [[0, 4]]
    },
    Queen => {
      :white => [[7, 3]],
      :black => [[0, 3]]
    },
    Rook =>{
      :white => [[7, 7], [7,0]],
      :black => [[0, 0], [0,7]]
    },
    Bishop =>{
      :white => [[7, 2], [7,5]],
      :black => [[0, 2], [0,5]]
    },
    Knight => {
      :white => [[7, 1], [7, 6]],
      :black => [[0, 1], [0, 6]]
    },
    Pawn => {
      :white => (0..7).to_a.map {|col| [6,col]},
      :black => (0..7).to_a.map {|col| [1,col]}
    }
  }

  def initialize
    @size = 8
    @grid = Array.new(@size) {Array.new(@size) { NullPiece.instance }}
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def populate_board
    PIECES_HASH.each do |piece, attributes|
      attributes.each do |color, positions|
        positions.each do |pos|
          self[pos] = piece.new(color,self,pos)
        end
      end
    end
  end

  def move(start, end_pos)
    raise NoPieceFoundError.new(start) if self[start] == NullPiece.instance
    raise OutOfBoundsError.new(start) unless in_bounds?(start)
    raise OutOfBoundsError.new(end_pos) unless in_bounds?(end_pos)

    if (self[start].moves).include?(end_pos)
      self[end_pos] = self[start]
      self[start] = NullPiece.instance
      self[end_pos].update_pos(end_pos)
    else
      raise "Invalid move"
    end
  end

  # I think we used this in cursor
  def in_bounds?(pos)
    pos.all? {|coord| coord.between?(0, @size-1)}
  end

  def get_row_values(idx)
    @grid[idx].map{|piece| piece.symbol}
  end

  def highlight_pos(pos, bg_color)
    self[pos].change_background(bg_color)
  end

  def in_check?(color)
    king_pos = where_my_king_at_yo(color)
    enemy_pieces(color).any? { |enemy| enemy.moves.include?(king_pos)}
  end

  def check_mate?(color)
    if in_check?(color)
      unless my_pieces(color).any? {|piece| piece.valid_moves.length > 0}
        return true
      end
    end
    false
  end

  def debug_place(pos, color, klass)
    self[pos] = klass.new(color, self, pos)
  end

  def dup
    dupped = Board.new
    my_pieces(:white).each do |piece|
      dupped[piece.pos] = piece.class.new(:white, dupped, piece.pos.dup)
    end
    my_pieces(:black).each do |piece|
      dupped[piece.pos] = piece.class.new(:black, dupped, piece.pos.dup)
    end
    dupped
  end

  def enemy_pieces(color)
    color == :black ? get_whites : get_blacks
  end

  def my_pieces(color)
    color == :white ? get_whites : get_blacks
  end

  def where_my_king_at_yo(color)
    @grid.each do |row|
      row.each { |piece| return piece.pos if piece.class == King }
    end
  end

  def get_blacks
    blacks = []
    @grid.each do |row|
      row.each { |piece| blacks << piece if piece.color == :black }
    end
    blacks
  end

  def get_whites
    whites = []
    @grid.each do |row|
      row.each { |piece| whites << piece if piece.color == :white }
    end
    whites
  end

end
