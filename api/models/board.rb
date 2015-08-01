require_relative 'tile'
require 'json'

class Board

  attr_accessor :rows, :cols, :tiles, :mines

  DIMENSIONS  = {
    :beginner => [3, 3, 2],
    :intermediate => [6, 6, 10],
    :advanced => [12, 12, 15] # TODO
  }

  SURROUND = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

  def initialize difficulty = :beginner
    @rows, @cols, @mines = DIMENSIONS[difficulty.to_sym]
    @tiles = Array.new(@rows){|row| Array.new(@cols) {|col| Tile.new(row, col)}}
  end

  def setup
    put_mines
    update_surrounding_mines
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

  def update_surrounding_mines
    @tiles.map do |row|
      row.map do |tile|
        tile.surrounding_mines = surrounding_mines tile
      end
    end
  end

  def surrounding_mines tile
    SURROUND
      .map {|(x, y)| [tile.row + x, tile.col + y]}
      .keep_if {|(x, y)| in_range(x, y) and mined?(x, y)}
      .length
  end

  def load board
    @rows, @cols = board[:rows], board[:cols]
    board[:tiles].each do |row|
      row.each do |tile|
        @tiles[tile[:row]][tile[:col]] = Tile.load tile
      end
    end
    self
  end

  def reveal row, col
    tile = @tiles[row][col]

    if tile.surrounding_mines == 0
      ((row - 1)..(row + 1)).each do |x|
        ((col - 1)..(col + 1)).each do |y|
          if in_range(x, y) and !tile_at(x, y).mined and !tile_at(x, y).flagged and !tile_at(x, y).revealed
            tile_at(x, y).set_as_revealed
            reveal x, y
          end
        end
      end
    else
      if not tile.revealed
        tile.set_as_revealed
      end
    end
  end

  def put_flag row, col
    @tiles[row][col].flagged = !@tiles[row][col].flagged
  end

  def reveal_mines
    @tiles.each do |row|
      row.each do |tile|
        tile.reveal_mine if tile.mined
      end
    end
  end

  def tile_at x, y
    @tiles[x][y]
  end

  def mined? row, col
    @tiles[row][col].mined
  end

  def flagged? row, col
    @tiles[row][col].flagged
  end

  def revealed? row, col
    @tiles[row][col].revealed
  end

  def in_range x, y
    x.between?(0, @rows - 1) and y.between?(0, @cols - 1)
  end

  def state
    {:tiles => @tiles, :rows => @rows, :cols => @cols}
  end
end