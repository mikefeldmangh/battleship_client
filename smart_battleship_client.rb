class SmartBattleshipClient < BattleshipClient
 
  def initialize(url, username, board)
    super url, username, board
    @play_mode = :hunt
    @ships = [5, 4, 3, 3, 2]
    @current_hits = [] #cells
    @num_ship_cells_hit_since_last_clear = 0
    @mode = :hunt
  end

  def select_target_cell
    reset_cell_probabilities
    if @mode == :hunt
      hunt
    else
      target
    end
  end

  def reset_cell_probabilities
    @opp_board.each do |r|
      r.each do |c|
        c.probability = 0
      end
    end
  end

  def get_cell_with_max_probability
    max = -1
    max_cell = nil
    @opp_board.each do |r|
      r.each do |c|
        # puts "max=#{max} cell:#{c.to_s}"
        if c.probability > max
          max = c.probability
          max_cell = c
        end
      end
    end
    # puts "returning: #{max_cell.to_s}"
    max_cell
  end

  def hunt
    all_cell_probabilities
    get_cell_with_max_probability
  end

  def all_cell_probabilities
    @ships.each do |ship_length|
      puts "ship length= #{ship_length}"
      (0..9).each do |row|
        (0..9).each do |col|
          test_ship_here ship_length, @opp_board[row][col], :horizontal
          test_ship_here ship_length, @opp_board[row][col], :vertical
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
          test_ship_here ship_length, @opp_board[row][current_column], :horizontal
        end
        start_row = row - ship_length - 1
        (start_row..row).each do |current_row|
          test_ship_here ship_length, @opp_board[current_row][col], :vertical
        end
      end
    end
    get_cell_with_max_probability
  end

  def test_ship_here(ship_size, start_cell, direction)
    # puts "test size:#{ship_size} dir:#{direction} cell: #{start_cell.to_s}"
    if direction == :horizontal
      row = start_cell.row
      end_column = start_cell.column + ship_size - 1
      fits = true
      if end_column < 10
        (start_cell.column..end_column).each do |col|
          if !check_cell row, col
            fits = false
            break
          end
        end
        if fits
          (start_cell.column..end_column).each do |col|
            process_fit_cell row, col
          end
        end
      end
    elsif direction == :vertical
      col = start_cell.column
      end_row = start_cell.row + ship_size - 1
      fits = true
      if end_row < 10
        (start_cell.row..end_row).each do |row|
          if !check_cell row, col
            fits = false
            break
          end
        end
        if fits
          (start_cell.row..end_row).each do |row|
            process_fit_cell row, col
          end
        end
      end
    end
  end

  def check_cell(row, col)
    test_cell = @opp_board[row][col]
    # puts "test V(#{ship_size}): #{test_cell.to_s}"
    if @opp_board[row][col].state == :miss || @opp_board[row][col].state == :ship
      false
    else
      true
    end
  end

  def process_fit_cell(row, col)
    test_cell = @opp_board[row][col]
    if test_cell.state != :hit
      test_cell.probability += 1
    end
  end
  
  def handle_shot_result(response)
    # puts response
    if response["hit"]
      @mode = :target
      @current_hits.push(@target_cell)
      @target_cell.state = :hit
      sunk_ship = response["sunk"]
      if sunk_ship && sunk_ship > 0
        @mode = :hunt
        remove_ship(sunk_ship)
        clear_current_hit_cells sunk_ship, @target_cell
      end
    else
      @target_cell.state = :miss
    end
    request_status
  end

  def remove_ship(ship_length)
    puts "sunk ship: #{ship_length}"
    puts "ships: #{@ships}"
    @ships.delete_at(@ships.index(ship_length))
  end

  # cannot necessarily easily define where the sunken ship was placed if we have more hits than the size of the ship
  def clear_current_hit_cells(sunk_ship_length, last_cell_hit)
    @num_ship_cells_hit_since_last_clear += sunk_ship_length
    if (@current_hits.size == @num_ship_cells_hit_since_last_clear)
      @current_hits.each do |cell|
        cell.state = :ship
      end
      @current_hits = []
      @num_ship_cells_hit_since_last_clear = 0
    end
  end
end