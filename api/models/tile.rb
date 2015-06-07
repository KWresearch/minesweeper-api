require 'json'

class Tile
  
   def initialize(row, col)
      @row = row
      @col = col
   end

   def to_json(options)
      {"row" => @row,"col" => @col}.to_json
   end
end