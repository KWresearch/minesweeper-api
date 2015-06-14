#require 'json/ext'

class Tile

  attr_accessor :row, :col, :mined, :surroundings, :display, :flagged, :revealed

  @@public_fields = %w[row col revealed display mined surroundings]

  def initialize(row, col)
    @row, @col = row, col
    @mined = false
    @revealed = false
    @flagged = false
    @display = ''
    @surroundings = 0
  end

  def self.load raw_tile
    tile = Tile.new raw_tile[:row], raw_tile[:col]
    tile.mined = raw_tile[:mined]
    tile.flagged = raw_tile[:flagged]
    tile.revealed = raw_tile[:revealed]
    tile.surroundings = raw_tile[:surroundings]

    tile
  end

  def state
    {
      "row" => @row,
      "col" => @col,
      "mined" => @mined,
      "flagged" => @flagged,
      "revealed" => @revealed,
      "surroundings" => @surroundings
    }
  end

  def to_json(options)
    {
      "row" => @row,
      "col" => @col,
      "revealed" => @revealed,
      "display" => @display
    }.to_json
    state.to_json
  end
end