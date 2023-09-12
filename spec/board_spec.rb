require "./spec/spec_helper"

RSpec.describe Board do
  before(:each) do
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  describe "#initialize" do
    it "exists" do
      expect(@board).to be_a(Board)
    end
  end

  describe "#generate_cells" do
    it "creates a hash of cells" do
      expect(@board.cells).to be_a(Hash)
      expect(@board.cells.length).to eq(16)
      @board.cells.each do |cell, cell_object|
        expect(cell_object).to be_an_instance_of(Cell)
      end
    end
  end

  describe "#valid_coordinate?" do
    it "returns boolean result of coordinate test" do
      expect(@board.valid_coordinate?("A1")).to be true
      expect(@board.valid_coordinate?("D4")).to be true
      expect(@board.valid_coordinate?("A5")).to be false
      expect(@board.valid_coordinate?("E1")).to be false
      expect(@board.valid_coordinate?("A22")).to be false
    end
  end

  describe "#horizontal_helper?" do
    it "determines valid placement of ship by horizontally consecutive coordinates" do
      expect(@board.horizontal_helper?(@cruiser, ["A1", "A2", "A4"])).to be false
      expect(@board.horizontal_helper?(@submarine, ["A1", "C1"])).to be false
      expect(@board.horizontal_helper?(@cruiser, ["A3", "A2", "A1"])).to be false
      expect(@board.horizontal_helper?(@cruiser, ["A1", "A2", "A3"])).to be true
    end
  end

  describe "#vertical_helper??" do
    it "determines valid placement of ship by vertically consecutive coordinates" do
      expect(@board.vertical_helper?(@cruiser, ["A1", "C2", "B3"])).to be false
      expect(@board.vertical_helper?(@submarine, ["A1", "C1"])).to be false
      expect(@board.vertical_helper?(@cruiser, ["A1", "B2", "C3"])).to be false
      expect(@board.vertical_helper?(@cruiser, ["A1", "B1", "C1"])).to be true
    end
  end

  describe "#collision_helper?" do
    it "determines if ship placement is overlapping" do
      expect(@board.collision_helper?(@cruiser, ["A1", "A2", "A3"])).to be true
      @board.place(@cruiser, ["A1", "A2", "A3"])
      expect(@board.collision_helper?(@submarine, ["A1", "B1"])).to be false
      expect(@board.collision_helper?(@submarine, ["B1", "B2"])).to be true
    end
  end

  describe "#valid_placement?" do  
    it "determines valid placement of ship by length" do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2"])).to be false
      expect(@board.valid_placement?(@submarine, ["A2", "A3", "A4"])).to be false
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A3"])).to be true
      expect(@board.valid_placement?(@cruiser, ["A2", "B3", "D4"])).to be false
      expect(@board.valid_placement?(@cruiser, ["A1", "B4", "C2"])).to be false
    end

    it "determines valid placement of ship by consecutive coordinates and non-diagonal placement" do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to be false
      expect(@board.valid_placement?(@submarine, ["A1", "C1"])).to be false
      expect(@board.valid_placement?(@cruiser, ["A3", "A2", "A1"])).to be false
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A3"])).to be true
      expect(@board.valid_placement?(@cruiser, ["A1", "B1", "C1"])).to be true
      expect(@board.valid_placement?(@submarine, ["A1", "A2"])).to be true
      expect(@board.valid_placement?(@cruiser, ["B1", "C1", "D1"])).to be true
    end

    it "checks for overlapping ships" do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A3"])).to be true
      @board.place(@cruiser, ["A1", "A2", "A3"])
      expect(@board.valid_placement?(@submarine, ["A1", "B1"])).to be false
      expect(@board.valid_placement?(@submarine, ["B1", "B2"])).to be true
    end
  end

  describe "#place" do
    it "places a ship if passed placement is valid" do
      @board.place(@cruiser, ["A1", "A2", "A3"])
      cell_1 = @board.cells["A1"] 
      cell_2 = @board.cells["A2"]
      cell_3 = @board.cells["A3"]
      expect(cell_1.ship).to eq(@cruiser)
      expect(cell_1.ship).to eq(cell_2.ship)
    end

    it "will not place a ship if any cell is occupied" do
      cell_1 = @board.cells["A1"] 
      cell_2 = @board.cells["A2"]
      cell_3 = @board.cells["A3"]
      @board.place(@submarine, ["A3", "A4"])
      @board.place(@cruiser, ["A1", "A2", "A3"])

      expect(cell_3.ship).to eq(@submarine)
      expect(cell_1.ship).to be nil
    end
  end

  describe "#render" do
    it "prints out a board with relevant information" do
      @board.place(@cruiser, ["A1", "A2", "A3"])

      expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it "prints out a board with all ship information" do
      @board.place(@cruiser, ["A1", "A2", "A3"])

      expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it "renders board information after actions taken" do
      @board.place(@cruiser, ["A1", "A2", "A3"])
      @board.place(@submarine, ["C1", "D1"])
      @board.fire_upon("A1")
      @board.fire_upon("B4")
      @board.fire_upon("C1")
      @board.fire_upon("D1")

      expect(@board.render).to eq("  1 2 3 4 \nA H . . . \nB . . . M \nC X . . . \nD X . . . \n")
    end

    it "renders board information after actions taken with true ship positions" do
      @board.place(@cruiser, ["A1", "A2", "A3"])
      @board.place(@submarine, ["C1", "D1"])
      @board.fire_upon("A1")
      @board.fire_upon("B4")
      @board.fire_upon("C1")
      @board.fire_upon("D1")

      expect(@board.render(true)).to eq("  1 2 3 4 \nA H S S . \nB . . . M \nC X . . . \nD X . . . \n")
    end
  end

  describe "#fire_upon" do
    it "fires on the board using input coordinate" do
      @board.place(@cruiser, ["A1", "A2", "A3"])
      @board.place(@submarine, ["C1", "D1"])
      @board.fire_upon("A1")

      expect(@board.cells["A1"].fired_upon?).to be true
    end

    it "will not not allow firing on invalid coordinates" do
      expect(@board.fire_upon("X1")).to eq("Please enter a valid coordinate")

      @board.fire_upon("A1")

      expect(@board.fire_upon("A1")).to eq("That coordinate has already been fired upon")
    end
  end

  describe "#random_horizontal_placement" do
    it "makes random coordinates for a ship" do
      random_cruiser = @board.random_horizontal_placement(@cruiser)
      expect(random_cruiser.length).to eq(3)
      expect(@board.horizontal_helper?(@cruiser, random_cruiser)).to be true

      random_submarine = @board.random_horizontal_placement(@submarine)
      expect(random_submarine.length).to eq(2)
      expect(@board.horizontal_helper?(@submarine, random_submarine)).to be true
    end
  end

  describe "#random_vertical_placement" do
    it "makes random coordinates for a ship" do
      random_cruiser = @board.random_vertical_placement(@cruiser)
      expect(random_cruiser.length).to eq(3)
      expect(@board.vertical_helper?(@cruiser, random_cruiser)).to be true

      random_submarine = @board.random_vertical_placement(@submarine)
      expect(random_submarine.length).to eq(2)
      expect(@board.vertical_helper?(@submarine, random_submarine)).to be true
    end
  end

  describe "#computer_ship_placement" do
    it "places ship in a position" do
      @board.computer_ship_placement(@cruiser)
      # Check for number cells used up
      used_cells =  @board.cells.values.select do |cell|
        cell.ship != nil
      end
      expect(used_cells.count).to eq(3)
      # Makes an array of nil or coordinates where something was placed
      placed_at = @board.cells.map do |coordinate, cell|
        coordinate if cell.ship != nil
      end
      # I couldn't figure out how to not have nils, so removed w/compact
      # Only assertion I could think of for now
      expect(placed_at.compact).to be_a Array
      expect(@board.collision_helper?(@cruiser, placed_at.compact)).to be false
    end

    it "cannot place ship on used cell, only horizontal left" do
      @board.place(@cruiser, ["B1", "B2", "B3"])
      @board.place(@cruiser, ["C1", "C2", "C3"])
      @board.place(@cruiser, ["D1", "D2", "D3"])
      @board.place(@submarine, ["A4", "B4"])
      @board.place(@submarine, ["C4", "D4"])
      # This is a ship specifically made for testing
      tester = Ship.new("Tester", 3)
      @board.computer_ship_placement(tester)
      # Makes an array of nil or coordinates where something was placed
      placed_at = @board.cells.map do |coordinate, cell|
        coordinate if cell.ship.name == "Tester"
      end
      # Only has 3 valid spaces (horizontally)
      expect(placed_at.compact).to eq(["A1", "A2", "A3"])
    end
    
    it "when only vertical space is left, does not create a conflict" do
      @board.place(@cruiser, ["B1", "B2", "B3"])
      @board.place(@cruiser, ["C1", "C2", "C3"])
      @board.place(@cruiser, ["D1", "D2", "D3"])
      @board.place(@cruiser, ["A1", "A2", "A3"])
      @board.place(@submarine, ["A4", "B4"])
      # This is a ship specifically made for testing
      tester = Ship.new("Tester", 2)
      @board.computer_ship_placement(tester)
      # Makes an array of nil or coordinates where something was placed
      placed_at = @board.cells.map do |coordinate, cell|
        coordinate if cell.ship.name == "Tester"
      end
      # Only has 3 valid spaces (horizontally)
      expect(placed_at.compact).to eq(["C4", "D4"])
    end
  end

  describe "#com_fire_upon" do
    it "random cell to fire upon" do
      @board.com_fire_upon
      com_fired_coord = @board.cells.map do |coordinate, cell|
        coordinate if cell.fired_upon? == true
      end.compact
      expect(com_fired_coord.count).to eq(1)
      expect(@board.cells[com_fired_coord[0]].render).to eq("M")

      @board.com_fire_upon
      com_fired_coord = @board.cells.map do |coordinate, cell|
        coordinate if cell.fired_upon? == true
      end.compact
      expect(com_fired_coord.count).to eq(2)

      @board.com_fire_upon
      com_fired_coord = @board.cells.map do |coordinate, cell|
        coordinate if cell.fired_upon? == true
      end.compact
      expect(com_fired_coord.count).to eq(3)
    end

    it "cannot fire upon a cell that has already been fired upon" do
      # Unsure on a better way to test atm
      @board.fire_upon("A3")
      @board.fire_upon("A4")
      @board.fire_upon("B1")
      @board.fire_upon("B2")
      @board.fire_upon("B3")
      @board.fire_upon("B4")
      @board.fire_upon("C1")
      @board.fire_upon("C2")
      @board.fire_upon("C3")
      @board.fire_upon("C4")
      @board.fire_upon("D1")
      @board.fire_upon("D2")
      @board.fire_upon("D3")
      @board.fire_upon("D4")
      
      @board.place(@submarine, ["A1", "A2"])
      expect(@board.cells["A1"].fired_upon?).to be false
      expect(@board.cells["A1"].ship).to eq(@submarine)
      expect(@board.cells["A1"].render).to eq(".")
      expect(@board.cells["A1"].render(true)).to eq("S")
      expect(@board.cells["A2"].render).to eq(".")
      expect(@board.cells["A2"].render(true)).to eq("S")

      @board.com_fire_upon
      expect(@board.cells["A1"].fired_upon?).to eq(true).or(eq(false))
      expect(@board.cells["A2"].fired_upon?).to eq(true).or(eq(false))
      expect(@board.cells["A1"].render).to eq("H").or(eq("M")).or(eq("."))
      expect(@board.cells["A1"].render(true)).to eq("H").or(eq("M")).or(eq("S"))
      expect(@board.cells["A2"].render).to eq("H").or(eq("M")).or(eq("."))
      expect(@board.cells["A2"].render(true)).to eq("H").or(eq("M")).or(eq("S"))

      @board.com_fire_upon
      expect(@board.cells["A1"].render).to eq("X")
      expect(@board.cells["A2"].render(true)).to eq("X")
    end
  end
end
