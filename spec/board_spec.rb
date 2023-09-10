require "./spec/spec_helper"

RSpec.describe Board do
  before(:each) do
    @board = Board.new
    @board.generate_cells
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  describe "#initialize" do
    it "exists" do
      expect(@board).to be_a(Board)
    end
    
    # it "has empty coordinates hash when created" do
    #   expect(@board.coordinates).to eq(Hash.new)
    # end
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
      expect(@board.valid_coordinate?('A1')).to be true
      expect(@board.valid_coordinate?('D4')).to be true
      expect(@board.valid_coordinate?('A5')).to be false
      expect(@board.valid_coordinate?('E1')).to be false
      expect(@board.valid_coordinate?('A22')).to be false
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
      expect(@board.vertical_helper?(@cruiser, ["A1", "B2", "C3"])).to be true
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
    end

    it "determines valid placement of ship by consecutive coordinates" do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to be false
      expect(@board.valid_placement?(@submarine, ["A1", "C1"])).to be false
      expect(@board.valid_placement?(@cruiser, ["A3", "A2", "A1"])).to be false
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A3"])).to be true
      expect(@board.valid_placement?(@cruiser, ["A1", "B1", "C1"])).to be true
      expect(@board.valid_placement?(@submarine, ["A1", "A2"])).to be true
      expect(@board.valid_placement?(@cruiser, ["B1", "C1", "D1"])).to be true
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

      expect(@board.render).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
    end
  end
end
