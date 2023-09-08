class Ship
  attr_reader :name, :length, :health
  attr_accessor :sunk

  def initialize(name, length)
    @name = name
    @length = length
    @health = length
    @sunk = false
  end

  def sunk?
    @sunk == true #should this querry method also include a check?
  end

  def hit
    @health -= 1
    @sunk = true if @health == 0
  end
end
