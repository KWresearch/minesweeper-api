require_relative 'board'
require_relative '../database'
require          'SecureRandom'

class Game

  attr_accessor :token, :board

  def initialize(difficulty = :beginner)
    @token = SecureRandom.hex 5
    @board = Board.new difficulty, @token
    save_new_game
  end

  def save_new_game
    db = Database.new().connect
    db.insert_one({
      'game_id' => @token,
      'board' => {
        'tiles' => @board.tiles.map {|row| row.map(&:raw_data)},
        'rows' => @board.rows,
        'cols' => @board.cols
      }
    })
  end
  
end