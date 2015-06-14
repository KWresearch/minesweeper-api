require_relative 'board'
require_relative '../database'
require 'SecureRandom'

class Game
  # TODO:
  ## Reduce json boilerplate
  ## Reduce board boilerplate

  attr_accessor :game_id, :board, :difficulty

  def initialize(difficulty = :beginner)
    @difficulty = difficulty
  end

  def setup
    @game_id = SecureRandom.hex 5
    @board = Board.new(difficulty, @token)
    @board.setup
    save
  end

  def save
    Database.instance.db.insert_one({
      'game_id' => @game_id,
      'difficulty' => @difficulty,
      'board' => {
        'tiles' => @board.tiles.map {|row| row.map(&:state)},
        'rows' => @board.rows,
        'cols' => @board.cols
      }
    })
  end

  def load game_id
    db = Database.instance.db
    coll = db.find(:game_id => game_id).first

    @game_id = coll[:game_id]
    @difficulty = coll[:difficulty]
    @board = Board.new(@difficulty, @game_id).load coll[:board]
  end

  def reveal x, y
    db = Database.instance.db
    coll = db.find(:game_id => game_id).first

    @game_id = coll[:game_id]
    @difficulty = coll[:difficulty]
    @board = Board.new(@difficulty, @game_id).load coll[:board]

    if board.mine_at? x.to_i, y.to_i
      status = 'game_over'
    else
      #board.reveal x, y
      status = 'playing'
    end

    b = {:tiles => @board.tiles.map {|row| row.map(&:state)},:rows => @board.rows,:cols => @board.cols}

    d = db.find(:game_id => game_id).find_one_and_update( {'$set' => {:status => status, :board => b }}, :return_document => :after)
    puts "................"
    puts d
  end


end