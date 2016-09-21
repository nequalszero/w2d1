require 'singleton'

class NullPiece
  include Singleton

  attr_reader :color, :symbol

  def initialize
    @color = nil
    @symbol = "-"
  end

  def change_background(color)
    @symbol = @symbol.colorize(:background => color)
  end
end
