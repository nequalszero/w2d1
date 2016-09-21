module Stepable

  def moves
    moves_arr = move_diffs.map{|move| [@pos[0]+move[0], @pos[1]+move[1]] }
    moves_arr.select{|pos| in_bounds?(pos) && !blocked?(pos)}
  end

end

module Slideable

  def moves
    possible_moves = []
    self.class::MOVE_DIRS.each do |dir|
      possible_moves.concat( grow_unblocked_moves_in_dir(*dir) )
    end
    possible_moves
  end

  private

  def grow_unblocked_moves_in_dir(dx, dy)
    possible_moves = [@pos]
    while true
      prev_pos = possible_moves[-1]
      new_pos = [prev_pos[0] + dx, prev_pos[1] + dy]
      break unless in_bounds?(new_pos) && !blocked?(new_pos)
      possible_moves << new_pos
      break if opponent?(new_pos)
    end
    return [] if possible_moves.length == 1
    possible_moves[1..-1]
  end

end
