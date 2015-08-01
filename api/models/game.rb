require_relative 'board'
require_relative '../database'
require 'SecureRandom'

class Game

  attr_accessor :game_id, :board, :difficulty, :status

  def initialize config
    @difficulty = config[:difficulty] || :beginner
    @game_id = config[:game_id] || SecureRandom.hex(5)
    @board = Board.new @difficulty
    @status = config[:status] || 'Game created'

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
    update_required = true

    return if is_game_over or is_solved

    if !@board.in_range row, col
      @status = "Position #{row},#{col} out of board"
      update_required = false

    elsif @board.flagged? row, col
      @status = "There is already a flag there!"
      update_required = false

    elsif @board.revealed? row, col
      @status = "You already revealed that position"
      update_required = false

    elsif @board.mined? row, col
      @status = "Game over"
      finish

    else
      @board.reveal row, col
      @status = "You revealed position #{row}, #{col}"
      if is_solved
        @status = "You won"
        @board.reveal_mines
      end
    end

    update if update_required
  end

  def put_flag row, col
    row, col = row.to_i, col.to_i
    update_required = true

    return if is_game_over or is_solved

    if !@board.in_range row, col
      @status = "Postion #{row}, #{col} out of board"
      update_required = false

    elsif @board.flagged? row, col
      @status = "Flag removed at #{row}, #{col}"
      @board.put_flag row, col

    elsif @board.revealed? row, col
      @status = "You cannot put a flag there"
      update_required = false

    else
      @status = "Flag put on #{row}, #{col}"
      @board.put_flag row, col
      if is_solved
        @status = "You won"
        finish
      end
    end

    update if update_required
  end

  def finish
    @board.reveal_mines
    Database.instance.db.find(:game_id => @game_id).delete_one
  end

  def is_game_over
    @status == 'Game over'
  end

  def is_solved
    @board.tiles.each do |row|
      row.each do |tile|
        return false if not (tile.revealed or tile.flagged) and not tile.mined
      end
    end
    true
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