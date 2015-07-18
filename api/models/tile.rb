#require 'json/ext'

class Tile

  attr_accessor :row, :col, :mined, :surrounding_mines, :display, :flagged, :revealed

  def initialize row, col
    @row, @col = row, col
    @mined = false
    @revealed = false
    @flagged = false
    @display = "."
    @surrounding_mines = 0
  end

  def self.load raw_tile
    tile = Tile.new raw_tile[:row], raw_tile[:col]
    tile.mined = raw_tile[:mined]
    tile.flagged = raw_tile[:flagged]
    tile.display = raw_tile[:display]
    tile.revealed = raw_tile[:revealed]
    tile.surrounding_mines = raw_tile[:surrounding_mines]

    tile
  end

  def set_as_revealed
    @revealed = true
    @display = @surrounding_mines
  end

  def reveal_mine
    @revealed = true
    @display = 'M'
  end

  def flagged=(flagged_)
    @flagged = flagged_
    if @flagged then @display = 'F' else @display = '.' end
  end

  def state
    {
      "row" => @row,
      "col" => @col,
      "mined" => @mined,
      "flagged" => @flagged,
      "revealed" => @revealed,
      "surrounding_mines" => @surrounding_mines,
      :display => @display
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