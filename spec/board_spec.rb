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
      expect(@board.coordinates[:A1]).to be_an_instance_of(Cell)
    end
  end
end
