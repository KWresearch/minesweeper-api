require_relative 'models/game'
require_relative 'helpers'
require 'json'

# TODO GETs should be POSTs

# Start a new game
get '/game' do
  game = Game.new({:difficulty => params[:difficulty]})
  game.start

  created game
end

# Request an existing game
get '/board/:game_id' do
  game = Game.load params[:game_id]
  if game then success(game) else not_found end
end

# Reveal a tile!
# /board/game_id/reveal?row=row&col=col
get '/board/:game_id/reveal' do
  return bad_request if not valid_params? params

  game = Game.load params[:game_id]
  return not_found if not game

  game.reveal params[:row], params[:col]

  success game
end

# Put a flag
# /board/game:id/flag?row=row&col=col
get '/board/:game_id/flag' do
  return bad_request if not valid_params? params

  game = Game.load params[:game_id]
  return not_found if not game

  game.put_flag params[:row], params[:col]

  success game
end

before do
  content_type :json
end