class Board
  attr_reader :cells

  def initialize
    @cells = {}
  end

  def generate_cells
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

  def horizontal_helper(ship, placement)
    numbers = placement.map { |number| number[1..-1].ord }
    current_index = 0
    until current_index == (placement.length - 1)
      diff = numbers[current_index] - numbers[current_index + 1]
      if diff == -1
        current_index += 1
      else
        return false
      end
    end
    true
  end

  def vertical_helper(ship, placement)
    letters = placement.map { |letter| letter[0].ord }
    current_index = 0
    until current_index == (placement.length - 1)
      diff = letters[current_index] - letters[current_index + 1]
      if diff == -1
        current_index += 1
      else
        return false
      end
    end
    true
  end
  
  def valid_placement?(ship, placement)
    if horizontal_helper(ship, placement) == true && vertical_helper(ship, placement) == true
      false
    elsif ship.length == placement.length && horizontal_helper(ship, placement) == true || vertical_helper(ship, placement) == true
      true
    else
      false
    end
  end

  def place(ship, placement)
    if valid_placement?(ship, placement)
      @cells.each do |coordinate, cell|
        cell.place_ship(ship)
      end
    end
  end
end
