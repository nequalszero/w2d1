# require_relative 'board'
# require_relative 'display'
# require_relative 'player'

['board', 'display', 'player'].each { |file| require_relative file }

class Game

  def initialize(player1, player2)
    @board = Board.new
    @board.populate_board
    @display = Display.new(@board)
    @player1 = player1
    @player2 = player2
    @current_player = @player1
  end

  def alternate_players
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def play
    until @board.check_mate?(@current_player.color)
      @display.render
      prompt
      alternate_players
    end

  end

  def prompt
    message = "#{@current_player.name} please select a #{@current_player.color} piece to move"
    while true
      start_pos = get_position(message)
      break if valid_start_pos?(start_pos)
    end

    message = "#{@current_player.name} please enter a position to move to"
    end_pos = get_position(message)
    @board.move(start_pos, end_pos)
  end

  def get_position(message)
    while true
      position = @display.get_cursor_input(message)
      return position if position.is_a?(Array)
    end
  end

  def valid_start_pos?(pos)
    return true if @board[pos].color == @current_player.color
    puts "You selected a piece of the wrong color!"
    false
  end

end


if __FILE__ == $PROGRAM_NAME
  player1 = Player.new("Rufus", :white)
  player2 = Player.new("Dufus", :black)
  chess_game = Game.new(player1, player2)
  chess_game.play
end
