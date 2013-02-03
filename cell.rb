class Cell
  attr_accessor :label, :row, :column, :probability, :state #(:unknown, :miss, :hit, :ship)

  def initialize(row, column, label)
    @row = row
    @column = column
    @label = label
    @state = :unknown
    @probability = 0
  end
  
  def to_s
    "label:#{@label} row:#{@row} column:#{@column} state:#{@state} probability:#{@probability}"
  end
end
