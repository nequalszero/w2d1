class Stepable

  def moves
    moves_arr = move_diffs.map{|move| [@pos[0]+move[0], @pos[1]+move[1]] }
    moves_arr.select{|pos| in_bounds?(pos)}
  end

  def in_bounds?(pos)
    pos.all? {|coord| coord.between?(0,7)}
  end
end

class Slideable

  HORIZONTAL_DIRS = [ [1,0], [0,1], [-1,0], [0,-1] ]
  DIAGONAL_DIRS = [ [1,1], [-1,1], [1,-1], [-1,-1] ]
  def moves

  end

  def in_bounds?(pos)
    pos.all? {|coord| coord.between?(0,7)}
  end

  private

  def grow_unblocked_moves_in_dir(dx, dy)

  end

end
