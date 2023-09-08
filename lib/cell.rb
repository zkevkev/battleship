class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
  end
  
  def empty?
    @ship == nil ? true : false
  end
end