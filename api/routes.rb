require_relative 'models/game'
require 'json'

# New game
get '/game' do
  content_type :json

  game = Game.new params[:difficulty] || :beginner

  JSON.pretty_generate({
    'status' => 200,
    'data' => {
      'game_id' => game.id,
      'state' => game.state,
      'board' => {
        'tiles' => game.board.tiles,
        'rows' => game.board.rows,
        'cols' => game.board.cols
      }
    }
  })
end