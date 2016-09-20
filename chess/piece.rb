require 'colorize'

class Piece
  attr_reader :value

  def initialize(value = "-")
    @value = "-"
  end

  def change_background(color)
    @value = @value.colorize(:background => color)
  end
end
