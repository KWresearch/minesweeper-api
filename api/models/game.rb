require_relative 'board'
require 'SecureRandom'

class Game
  attr_accessor :id, :state, :board

  def initialize(difficulty = :beginner)
    @difficulty = difficulty
    @id = SecureRandom.hex 5
    @state = :playing
    @board = Board.new @difficulty
  end
end