require_relative 'tile'
require 'json'

class Board

  attr_accessor :rows, :cols, :tiles

  DIMENSIONS  = {
    :beginner => [3, 3, 2],
    :intermediate => [6, 6, 10]
  }

  SURROUND = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

  # TODO: save the state using the token

  def initialize(difficulty = :beginner)
    @rows, @cols, @mines = DIMENSIONS[difficulty]
    reset
  end

  def reset
    @tiles = Array.new(@rows){|row| Array.new(@cols) {|col| Tile.new(row, col)}}
  end

  def setup
    put_mines
    update_surrounding
    #save_state
  end

  def load board
    @rows, @cols = board[:rows], board[:cols]
    board[:tiles].each do |row|
      row.each do |tile|
        @tiles[tile[:row]][tile[:col]] = Tile.load tile
      end
    end
    self
    #board[:tiles].each do |row|
    #  row.each do |tile|
    #    @board.tiles[]
  #    end
  #  end

    #p board[:tiles][0]
  end

  def put_mines
    current_mines = 0
    while current_mines < @mines
      rand_row, rand_col = rand(@rows), rand(@cols)

      if not @tiles[rand_row][rand_col].mined
        @tiles[rand_row][rand_col].mined = true
        current_mines += 1
      end
    end
  end

  def update_surrounding
    @tiles.map do |row|
      row.map do |tile|
        tile.surroundings = surroundings(tile)
      end
    end
  end

  def surroundings(tile)
    row, col = tile.row, tile.col
    result = 0
    ((row - 1)..(row + 1)).each do |x|
      ((col - 1)..(col + 1)).each do |y|
        if in_range(x, y) and @tiles[x][y].mined
          result += 1
        end
      end
    end
    result
  end

  def mine_at? x, y
    @tiles[x][y].mined
  end

  def in_range(x, y)
    x.between?(0, @rows-1) and y.between?(0, @cols-1)
  end

  def state
    {
      :tiles => @tiles,
      :rows => @rows,
      :cols => @cols
    }
  end

end