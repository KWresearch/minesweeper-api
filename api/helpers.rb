helpers do
  def created data
    generic_response 201, data.status, {:game_id => data.game_id, :board => data.board.state}
  end

  def success data
    generic_response 200, data.status, {:game_id => data.game_id, :board => data.board.state}
  end

  def bad_request data = {:error => '500 - Bad request'}
    generic_response 500, "Invalid parameters", data
  end

  def not_found data = {:error => '404 - Not found'}
    generic_response 404, "Game not found", data
  end

  def error status, data
    generic_response 500, data
  end

  def generic_response code, status, data
    [code, {}, JSON.pretty_generate({
      :status => status,
      :data => data
      })]
  end

  def valid_params? params
    game_id = params[:game_id]
    row = params[:row]
    col = params[:col]

    p params
    return true if not row and not col

    return false if not game_id or game_id.length > 10
    return false if not row or not col
    row_i = Integer(row) rescue nil
    col_i = Integer(col) rescue nil
    return false if not row_i or not col_i

    true
  end
end