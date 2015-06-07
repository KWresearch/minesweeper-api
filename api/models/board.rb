require_relative 'tile'
require 'json'

class Board
  attr_accessor :rows, :cols, :tiles

  DIMENSIONS  = {
    :beginner => [3, 3, 2],
    :intermediate => [6, 6, 10]
  }

  def initialize(difficulty=:beginner)
    @rows, @cols, @mines = DIMENSIONS[difficulty]
    p difficulty
    p DIMENSIONS[:beginner]
    @tiles = Array.new(@rows){|row| Array.new(@cols) {|col| 0}}
    setup
  end

  def setup
    (0...@rows).each do |row|
      (0...@cols).each do |col|
        @tiles[row][col] = Tile.new row, col
      end
    end
  end
end