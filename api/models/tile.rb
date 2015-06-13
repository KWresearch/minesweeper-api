#require 'json/ext'

class Tile

  attr_accessor :row, :col, :mined, :surroundings

  def initialize(row, col)
    @row = row
    @col = col
    @mined = false
    @surroundings = 0
  end

  def raw_data
    {"row" => @row,"col" => @col, "mined" => @mined, "surroundings" => @surroundings}
  end

  def to_json(options)
    {"row" => @row,"col" => @col, "mined" => @mined, "surroundings" => @surroundings}.to_json
  end
end