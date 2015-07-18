require_relative 'models/game'
require_relative 'helpers'
require 'json'

before do content_type :json end

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

# Reveal a tile: /board/game_id/reveal?row=row&col=col
get '/board/:game_id/reveal' do
  if not valid_params? params then return bad_request end
  if not (game = Game.load(params[:game_id])) then return not_found end

  game.reveal params[:row], params[:col]
  success game
end

# Put a flag: /board/game:id/flag?row=row&col=col
get '/board/:game_id/flag' do
  if not valid_params? params then return bad_request end
  if not (game = Game.load(params[:game_id])) then return not_found end

  game.put_flag params[:row], params[:col]
  success game
end