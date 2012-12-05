class Cell
  attr_accessor :label, :row, :column, :probability, :state #(:unknown, :miss, :hit, :ship)

  def initialize(row, column, label)
    @row = row
    @column = column
    @label = label
    @state = :unknown
  end
end
