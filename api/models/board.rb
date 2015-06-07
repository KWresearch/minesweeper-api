require_relative 'tile'
require 'json'

class Board
  attr_accessor :rows, :cols, :tiles

  DIMENSIONS  = {
    :beginner => [3, 3, 2],
    :intermediate => [6, 6, 10]
  }

  SURROUND = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

  def initialize(difficulty = :beginner)
    @rows, @cols, @mines = DIMENSIONS[difficulty]
    setup
  end

  def setup
    @tiles = Array.new(@rows){|row| Array.new(@cols) {|col| Tile.new(row, col)}}

    put_mines
    update_surrounding
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
    @tiles.map {|row| row.map {|tile| tile.surroundings = surroundings(tile) }}
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

  def in_range(x, y)
    x.between?(0, @rows-1) and y.between?(0, @cols-1)
  end

  def reset
    setup
  end

end