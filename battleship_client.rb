Class BattleshipClient
 
  def create_new_game
    #TODO: send game request
  end

  def handle_game_start_response (response)
    @game_id = response.game_id
    request_status
  end

  def initialize
    init_board
    @user = "Mike"
    @play_mode = :hunt
    @ships = [5, 4, 3, 3, 2]
    @current_hits = [] #cells
    create_new_game
  end

  def init_board
    (1..10).each do |row|
      col_index = 1
      ('A'..'J').each do |col|
        @board[row][col_index] = Cell.new(row, col_index, col+row)
        col_index++
      end
    end
  end

  def shoot
    sleep 0.1

    reset_cell_probabilities
    if @mode == :hunt
      @target_cell = hunt
    else
      @target_cell = target
    end

    target_label = @target_cell.label
    #TODO: send shot request with target label
  end

  def reset_cell_probabilities
    @board.each do |r|
      r.each do |c|
        c.probability = 0
      end
    end
  end

  def get_cell_with_max_probability
    max = -1
    @board.each do |r|
      r.each do |c|
        if c.probability > max
          max = c.probability
          max_cell = c
      end
    end
    max_cell
  end

  def hunt
    all_cell_probabilities
    get_cell_with_max_probability
  end

  def all_cell_probabilities
    @ships.each do |ship_length|
      (1..10).each do |row|
        (1..10).each do |col|
          test_ship_here (ship_length, @board[row][col], :horizontal)
          test_ship_here (ship_length, @board[row][col], :vertical)
        end
      end
    end
  end

  def target
    #get cell probabilities around current_hits
    @current_hits.each do |hit|
      row = hit.row
      col = hit.column
      @ships.each do |ship_length|
        start_col = col - ship_length - 1
        (start_col..col).each do |current_column|
          test_ship_here (ship_length, @board[row][current_column], :horizontal)
        end
        start_row = row - ship_length - 1
        (start_row..row).each do |current_row|
          test_ship_here (ship_length, @board[current_row][col], :vertical)
        end
      end
    end

    get_cell_with_max_probability
  end

  

  def test_ship_here (ship_size, start_cell, direction)
    if direction == :horizontal
      row = start_cell.row
      end_column = start_cell.column + ship_size - 1
      fits = true
      if end_column <= 10
        (start_cell.column..end_column).each do |col|
          if @board[row][col].status == :miss || @board[row][col].status == :ship
            fits = false
            break
          end
        end
        (start_cell.column..end_column).each do |col|
          if @board[row][col].status != :hit
            @board[row][col].probability++
          end
        end
      end
    else if direction == :vertical
      col = start_cell.column
      end_row = start_cell.row + ship_size - 1
      fits = true
      if end_row <= 10
        (start_cell.row..end_row).each do |row|
          if @board[row][col].status == :miss || @board[row][col].status == :ship
            fits = false
            break
          end
        end
        (start_cell.row..end_row).each do |row|
          if @board[row][col].status != :hit
            @board[row][col].probability++
          end
        end
      end
    end
  end

  def handle_shot_result (response)
    if response.hit
      @mode = :target
      @current_hits.push(@target_cell)
      if response.sunk
        @mode = :hunt
        remove_ship(response.sunk)
        #TODO: clear ship cells from hit list and mark them
      end
    end
    
    # else if miss - change nothing
    
    request_status
  end

  def remove_ship (ship_length)
    @ships.delete_at(ships.index(ship_length))
  end

  def request_status
    #TODO: send request for status
  end

  def handle_status_result (response)
    if response.game_status == "playing" && response.my_turn
      shoot
    end
    
  end

end


