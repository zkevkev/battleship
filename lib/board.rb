class Board
  attr_accessor :cells

  def initialize
    @cells = generate_cells
  end

  def generate_cells
    @cells = {}
    pairs = []
    range_alphas = ["A", "B", "C", "D"]
    range_nums = ["1", "2", "3", "4"]

    range_nums.each do |num|
      range_alphas.each do |alpha|
        pairs << alpha + num
      end
    end
    pairs.sort.each do |pair|
      @cells[pair] = Cell.new(pair)
    end
    @cells
  end

  def valid_coordinate?(coordinate)
    valid_coordinates = @cells.keys
    valid_coordinates.include?(coordinate)
  end

  def horizontal_helper?(ship, placement)
    # ["A1", "B2", "B3"] => [['A', '1'], ['B', '2'], ['B', '2']]
    placement_split = placement.map { |number| [number[0], number[1].ord] }
    # index 0 values STAY THE SAME, index 1 values increment
    # Both have to be true

    placement_split.each do |placement|
      return false if placement[0] != placement_split[0][0]
    end

    current_index = 0
    until current_index == (placement.length - 1)
      diff = placement_split[current_index][1] - placement_split[current_index + 1][1]
      if diff == -1
        current_index += 1
      else
        return false
      end
    end
    true
  end

  def vertical_helper?(ship, placement)
    placement_split = placement.map { |letter| [letter[0].ord, letter[1]] }
    
    placement_split.each do |placement|
      return false if placement[1] != placement_split[0][1]
    end

    current_index = 0
    until current_index == (placement.length - 1)
      diff = placement_split[current_index][0] - placement_split[current_index + 1][0]
      if diff == -1
        current_index += 1
      else
        return false
      end
    end
    true
  end

  def collision_helper?(ship, placement)
    placement.each do |place|
      return false if @cells[place].ship != nil
    end
    true
  end

  def valid_placement?(ship, placement)
    # Diagonal
    if horizontal_helper?(ship, placement) && vertical_helper?(ship, placement) 
      false
    elsif (horizontal_helper?(ship, placement) || vertical_helper?(ship, placement)) && ship.length == placement.length && collision_helper?(ship, placement)
      true
    else
      false
    end
  end

  def place(ship, placement)
    if valid_placement?(ship, placement)
      placement.each do |coordinate|
        @cells[coordinate].ship = ship
      end
    end
  end

  def render(reveal = nil)
    if reveal == nil
      placeholder = @cells.map { |coordinate, cell| cell.render }.join(" ")
      "  1 2 3 4 \n" +
      "A #{placeholder[0..6]} \n" +
      "B#{placeholder[7..14]} \n" +
      "C#{placeholder[15..22]} \n" +
      "D#{placeholder[23..30]} \n"
    else
      placeholder = @cells.map { |coordinate, cell| cell.render(true) }.join(" ")
      "  1 2 3 4 \n" +
      "A #{placeholder[0..6]} \n" +
      "B#{placeholder[7..14]} \n" +
      "C#{placeholder[15..22]} \n" +
      "D#{placeholder[23..30]} \n"
    end
  end

  def fire_upon(coordinate)
    if !valid_coordinate?(coordinate)
      "Please enter a valid coordinate"
    elsif valid_coordinate?(coordinate) && @cells[coordinate].fired_upon?
      "That coordinate has already been fired upon"
    else
      @cells[coordinate].fire_upon
    end
  end

  def random_horizontal_placement(ship)
    # Sequential number arrays depending on length of ship
    nums = []
    ("1".."4").each_cons(ship.length) { |num| nums << num }
    # Randomly pick one of the sequences, by index (0-1 OR 0-2)
    # I did a bunch of pry spot tests and it does work (any better way of testing?)
    random_index = Random.new.rand(0..(nums.length - 1))
    # generate random letter A through D, and tack it on to get coordinates
    letter = Random.new.rand(65..68).chr
    # Array of random coordinates
    final_placement = nums[random_index].map { |num| letter + num }
  end

  def random_vertical_placement(ship)
    # each_cons to get sequential letters
    letters = []
    ("A".."D").each_cons(ship.length) { |letter| letters << letter }
    # Randomly pick one of the sequences (0-1 OR 0-2)
    random_index = Random.new.rand(0..(letters.length - 1))
    # generate random number 1 through 4, and tack it on to get coordinates
    number = Random.new.rand(1..4).to_s
    # Array of random coordinates
    final_placement = letters[random_index].map { |letter| letter + number}
  end

  def computer_ship_placement(ship) # I decided to use a parameter instead
    # Randomizing
    # Place Horizontal OR Vertical
    if Random.new.rand(0..1) == 0
      random_coordinates = random_horizontal_placement(ship)
    else
      random_coordinates = random_vertical_placement(ship)
    end
    # I think this is recursion
    if valid_placement?(ship, random_coordinates) 
      place(ship, random_coordinates)
    else
      computer_ship_placement(ship)
    end
  end

  def com_fire_upon
    com_coordinate = @cells.keys.sample
    if @cells[com_coordinate].fired_upon? == false
      @cells[com_coordinate].fire_upon
      com_coordinate
    else
      com_fire_upon
    end
  end

  def clear_board
    @cells.each do |coordinate, cell|
      cell.ship = nil
      cell.fired_upon = false
    end
  end
end
