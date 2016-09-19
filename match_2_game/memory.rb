require_relative "board"
require_relative "player"


class InvalidSize < StandardError
  attr_reader :message

  def initialize(message)
    @message = message
  end
end

class OutOfBoundsError < StandardError
end

class MemoryGame
  attr_reader :player

  def initialize(player, size = 4)
    raise InvalidSize.new("'size' input was not a number.") if size.class != Fixnum
    raise InvalidSize.new("'size' entered was not greater than 0") if size <= 0
    @board = Board.new(size)
    @previous_guess = nil
    @player = player
  end

  def compare_guess(new_guess)
    if previous_guess
      if match?(previous_guess, new_guess)
        player.receive_match(previous_guess, new_guess)
      else
        puts "Try again."
        [previous_guess, new_guess].each { |pos| board.hide(pos) }
      end
      self.previous_guess = nil
      player.previous_guess = nil
    else
      self.previous_guess = new_guess
      player.previous_guess = new_guess
    end
  end

  def get_player_input
    begin
      pos = player.get_input
      check_boundaries(pos)
    rescue ArgumentError => e
      puts e.message
      retry
    rescue InputError => e
      puts e.message
      retry
    rescue OutOfBoundsError => e
      puts e.message
      retry
    end
    pos
  end

  def make_guess(pos)
    revealed_value = board.reveal(pos)
    player.receive_revealed_card(pos, revealed_value)
    board.render

    compare_guess(pos)

    sleep(1)
    board.render
  end

  def match?(pos1, pos2)
    board[pos1] == board[pos2]
  end

  def play
    until board.won?
      board.render
      pos = get_player_input
      make_guess(pos)
    end

    puts "Congratulations, you win!"
  end

  def check_boundaries(pos)
    return if pos.all? { |x| x.between?(0, board.size - 1) }
    raise OutOfBoundsError.new("#{pos} out of bounds (0 to #{board.size - 1})")
  end

  private
  attr_accessor :previous_guess
  attr_reader :board
end

if __FILE__ == $PROGRAM_NAME
  size = ARGV.empty? ? 4 : ARGV.shift.to_i
  MemoryGame.new(HumanPlayer.new(size), size).play
end
