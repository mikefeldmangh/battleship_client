class RandomBattleshipClient < BattleshipClient
 
  def select_target_cell
    # choose random cell as long as it has not already been used
    begin
      row = rand(0..9)
      col = rand(0..9)
    end until @opp_board[row][col].state == :unknown
    @opp_board[row][col]
  end
    
end