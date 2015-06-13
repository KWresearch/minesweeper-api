require_relative 'models/game'
require 'json'

before do
  content_type :json
end

# New game
get '/game' do
  game = Game.new params[:difficulty] || :beginner

  JSON.pretty_generate({
    'status' => 'success',
    'data' => {
      'game_id' => game.token,
      'board' => {
        'tiles' => game.board.tiles,
        'rows' => game.board.rows,
        'cols' => game.board.cols
      }
    }
  })
end