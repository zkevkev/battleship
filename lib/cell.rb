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
    @fired_upon = true
    return if @ship == nil
    @ship.hit
  end

  def fired_upon?
    @fired_upon 
  end

  def render(reveal = nil)
    if reveal != true
      if @ship == nil && fired_upon? == true
        "M"
      elsif @ship != nil && fired_upon? == true && @ship.sunk? == false
        "H"
      elsif @ship != nil && fired_upon? == true && @ship.sunk? == true
        "X"
      else
        "."
      end
    elsif reveal == true
      if @ship != nil
        "S"
      else
        "."
      end
    end
  end
end