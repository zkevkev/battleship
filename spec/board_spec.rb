require "./spec/spec_helper"

RSpec.describe Board do
  before(:each) do
    @board = Board.new
  end

  describe "#initialize" do
    it "exists" do
      expect(@board).to be_a(Board)
    end
    
    it "has empty coordinates hash when created" do
      expect(@board.coordinates).to eq(Hash.new)
    end
  end

  describe "#cells" do
    it "creates a hash of cells" do
      expect(@board.coordinates).to eq(Hash.new)
      @board.cells
      expect(@board.coordinates).to be_a(Hash)
      expect(@board.coordinates.length).to eq(16)
      @board.coordinates.each do |coordinate, cell_object|
        expect(cell_object).to be_an_instance_of(Cell)
      end
    end
  end

  describe "#valid_coordinate?" do
    it "returns boolean result of coordinate test" do
      @board.cells
      expect(@board.valid_coordinate?('A1')).to be true
      expect(@board.valid_coordinate?('D4')).to be true
      expect(@board.valid_coordinate?('A5')).to be false
      expect(@board.valid_coordinate?('E1')).to be false
      expect(@board.valid_coordinate?('A22')).to be false
    end
  end
end
