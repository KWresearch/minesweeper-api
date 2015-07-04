require_relative 'tile'
require 'json'

class Board

  attr_accessor :rows, :cols, :tiles

  DIMENSIONS  = {
    :beginner => [3, 3, 2],
    :intermediate => [6, 6, 10],
    :advanced => [12, 12, 15] # TODO
  }

  # TODO: PASS THNEM TO GAME AND THEN TO ROUTES
  PASS = 1
  MINED = 2
  OK = 3

  SURROUND = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

  def initialize difficulty = :beginner
    @rows, @cols, @mines = DIMENSIONS[difficulty]
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
      .keep_if {|(x, y)| in_range(x, y) and mine_at?(x, y)}
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
    puts "With #{row}, #{col}"
    tile = @tiles[row][col]

    if surrounding_mines(tile) == 0 # or tile.surrounding_mines == 0
      ((row - 1)..(row + 1)).each do |x|
        ((col - 1)..(col + 1)).each do |y|
          puts "Trying #{x}, #{y}"
          if in_range(x, y) and !tile_at(x, y).mined and !tile_at(x, y).flagged and !tile_at(x, y).revealed
            puts "Revealing #{tile.row}, #{tile.col}"
            tile.revealed = true
            tile.display = tile.surrounding_mines
            reveal x, y
          end
        end
      end
    else
      if not tile.revealed
        puts "revealing #{tile.row}, #{tile.col}"
        tile.revealed = true
        tile.display = tile.surrounding_mines
      end
    end
  end

  def reveal_mines
    @tiles.each do |row|
      row.each do |tile|
        tile.revealed = true if tile.mined
      end
    end
  end

  def tile_at x, y
    @tiles[x][y]
  end

  def mine_at? row, col
    @tiles[row][col].mined
  end

  def flag_at? row, col
    @tiles[row][col].flagged
  end

  def in_range x, y
    x.between?(0, @rows - 1) and y.between?(0, @cols - 1)
  end

  def state
    {:tiles => @tiles, :rows => @rows, :cols => @cols}
  end
end