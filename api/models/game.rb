require_relative 'board'
require_relative '../database'
require 'SecureRandom'

class Game

  attr_accessor :game_id, :board, :difficulty, :status

  def initialize config
    @difficulty = config[:difficulty] || :beginner
    @game_id    = config[:game_id] || SecureRandom.hex(5)
    @board      = Board.new @difficulty
    @status     = 'playing'

    # Load a previous game if needed
    @board.load(config[:board]) if config[:board]
  end

  def setup
    @board.setup
    save
  end

  # Save the state of the game
  def save
    Database.instance.db.insert_one state
  end

  # Load a previous saved game
  def self.load game_id
    Game.new Database.instance.db.find(:game_id => game_id).first
  end

  def reveal x, y
    if @board.mine_at? x.to_i, y.to_i
      @status = 'game_over'
    else
      #board.reveal x, y
    end

    update
  end

  def update
    Database.instance.db.find(:game_id => @game_id).find_one_and_update({
      '$set' => state
    })
  end

  def state
    {
      :game_id => @game_id,
      :difficulty => @difficulty,
      :status => @status,
      :board => {
        :tiles => @board.tiles.map {|row| row.map(&:state)},
        :rows => @board.rows,
        :cols => @board.cols
      }
    }
  end
end