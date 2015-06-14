require_relative 'models/game'
require 'json'

before do
  content_type :json
end

# TODO:
## GETs should be POSTs
## add after do end for json stuff
## Implement reveal, for real

# New game
get '/game' do
  game = Game.new params[:difficulty] || :beginner
  game.setup

  JSON.pretty_generate({
    'status' => 'success',
    'data' => {
      'game_id' => game.game_id,
      'board' => {
        'tiles' => game.board.tiles,
        'rows' => game.board.rows,
        'cols' => game.board.cols
      }
    }
  })
end

# Reveal (x, y): /board/game_id?x=x&y=y
get '/board/:game_id' do
  game = Game.new
  game.load params[:game_id]
  game.reveal params[:x], params[:y]

  JSON.pretty_generate({
    'status' => 'success',
    'data' => {
      'game_id' => game.game_id,
      'board' => {
        'tiles' => game.board.tiles,
        'rows' => game.board.rows,
        'cols' => game.board.cols
      }
    }
  })
end

# Put a flag
get '/board/:game_id?flag' do
  game = Game.load params[:game_id]
  #game.board.put_flag :x, :y

  # return response
end