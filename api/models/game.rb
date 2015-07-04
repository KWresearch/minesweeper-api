require_relative 'board'
require_relative '../database'
require 'SecureRandom'

class Game

  attr_accessor :game_id, :board, :difficulty, :status

  def initialize config
    @difficulty = config[:difficulty] || :beginner
    @game_id = config[:game_id] || SecureRandom.hex(5)
    @board = Board.new @difficulty
    @status = 'Game created'

    # Load a previous game if needed
    @board.load(config[:board]) if config[:board]
  end

  # Start a new game
  def start
    @board.setup
    @status = 'Playing now'
    save
  end

  # Save the current state of the game
  def save
    Database.instance.db.insert_one game_state
  end

  # Update the state of the game
  def update
    Database.instance.db.find(:game_id => @game_id).find_one_and_update({
      '$set' => game_state
    })
  end

  # Load a started game
  def self.load game_id
    state = Database.instance.db.find(:game_id => game_id).first
    if state then return Game.new(state) else return nil end
  end

  def reveal row, col
    row, col = row.to_i, col.to_i

    # TODO: check flag[row][col]
    if not @board.in_range row, col
      @status = "#{row} and #{col} are not in the board"
    elsif @board.mine_at? row, col
      @status = "Game over"
      finish
    else
      @board.reveal row, col
      @status = "You revealed #{row}, #{col}"
    end

    update
    [@status, self]
  end

  def put_flag row, col
    # TODO
  end

  # Game over!
  def finish
    @board.reveal_mines
    @status = 'Game over'
  end

  # The current state of the game
  def game_state
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