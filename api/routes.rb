require_relative 'models/game'
require 'json'

before do
  content_type :json
end

# TODO GETs should be POSTs
# TODO Implement reveal, for real

# New game
get '/game' do
  game = Game.new({:difficulty => params[:difficulty]})
  game.setup

  JSON.pretty_generate({
    :status => 'success',
    :data => {
      :game_id => game.game_id,
      :board   => game.board.state
    }
  })
end

# Reveal (x, y): /board/game_id?x=x&y=y
get '/board/:game_id' do
  # TODO sanitize input
  #game = Game.new({})
  game = Game.load params[:game_id]
  game.reveal params[:x], params[:y]

  JSON.pretty_generate({
    :status => 'success',
    :data => {
      :game_id => game.game_id,
      :board   => game.board.state
    }
  })
end

# Put a flag
get '/board/:game_id?flag' do
  game = Game.load params[:game_id]
  #game.board.put_flag :x, :y

  # return response
end