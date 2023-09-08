class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end
  
  def empty?
    @ship == nil ? true : false
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
    @ship.hit
    @fired_upon = true
  end
end