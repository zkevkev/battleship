require "./spec/spec_helper"

RSpec.describe Cell do

  before(:each) do
    @cell_1 = Cell.new("B4")
    @cell_2 = Cell.new("B2")
    @cell_3 = Cell.new("B3")
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe "#initialize" do
    it "exists" do
      expect(@cell_1).to be_an_instance_of(Cell)
    end

    it "has attributes" do
      expect(@cell_1.coordinate).to eq("B4")
      expect(@cell_1.ship).to be nil
    end
  end

  describe "#empty?" do
    it "defaults to true" do
      expect(@cell_1.empty?).to be true
    end
  end

  describe "#place_ship" do
    it "assigns ship attribute" do
      expect(@cell_1.ship).to be_nil
      expect(@cell_1.empty?).to be true
      @cell_1.place_ship(@cruiser)
      expect(@cell_1.ship).to eq(@cruiser)
      expect(@cell_1.empty?).to be false
    end
  end

  describe "#fire_upon and #fired_upon?" do
    it "fires on a cell and updates state" do
      @cell_1.place_ship(@cruiser)
      expect(@cell_1.fired_upon?).to be false
      @cell_1.fire_upon
      expect(@cell_1.fired_upon?).to be true
      expect(@cell_1.ship.health).to eq(2)
    end

    it "still functions if cell does not contain ship" do
      expect(@cell_1.fired_upon?).to be false
      @cell_1.fire_upon
      expect(@cell_1.fired_upon?).to be true
    end
  end

  describe "#render" do
    it "returns '.' if cell is empty and unfired upon" do
      expect(@cell_1.render).to eq(".")
    end

    it "returns 'M' if cell is empty and fired upon" do
      expect(@cell_1.render).to eq(".")
      @cell_1.fire_upon
      expect(@cell_1.render).to eq("M")
    end

    it "returns 'H' if cell is not empty and fired upon" do
      expect(@cell_2.render).to eq(".")
      @cell_2.place_ship(@cruiser)
      expect(@cell_2.render).to eq(".")
      @cell_2.fire_upon
      expect(@cell_2.render).to eq("H")
    end

    it "returns 'X' if cell is fired upon and ship is sunk" do
      expect(@cell_2.render).to eq(".")
      @cell_1.place_ship(@cruiser)
      @cell_2.place_ship(@cruiser)
      @cell_3.place_ship(@cruiser)
      expect(@cell_2.render).to eq(".")
      @cell_1.fire_upon
      @cell_2.fire_upon
      expect(@cell_2.render).to eq("H")
      @cell_3.fire_upon
      expect(@cell_2.render).to eq("X")
  end
end