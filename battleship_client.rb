class BattleshipClient
 
  def create_new_game 
    url = "#{@base_url}games/join"
    params = { :user => @user, :board => @my_board }
    json_response = post_request url, params
    handle_game_start_response json_response
  end

  def handle_game_start_response(response)
    @game_id = response["game_id"]
  end

  def take_turn
    request_status
  end
  
  def initialize(url, username, board)
    init_board
    @base_url = url
    @user = username
    @my_board = board
    create_new_game 
  end

  def init_board
    @opp_board = []
    (0..9).each do |row|
      @opp_board[row] = []
      col_index = 0
      ('A'..'J').each do |col|
        @opp_board[row][col_index] = Cell.new(row, col_index, col+(row+1).to_s)
        col_index += 1
      end
    end
  end

  def shoot
    sleep 0.1

    @target_cell = select_target_cell
    target_label = @target_cell.label
    
    url = "#{@base_url}games/fire"
    params = { :user => @user, :game_id => @game_id, :shot => target_label }
    puts params
    response = post_request url, params
    handle_shot_result response
  end

  
  def handle_shot_result(response)
    # puts response
    if response["hit"]
      @target_cell.state = :hit
      sunk_ship = response["sunk"]
    else
      @target_cell.state = :miss
    end
    request_status
  end

  def request_status
    url = "#{@base_url}games/status"
    params = { :user => @user, :game_id => @game_id }
    response = get_request url, params
    handle_status_result response
  end

  def handle_status_result(response)
    playing = response["game_status"] == "playing"
    if playing && response["my_turn"]
        shoot
    end
    playing
  end
end