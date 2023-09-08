require "./spec/spec_helper"

RSpec.describe Cell do

  before(:each) do
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe "#initialize" do
    it "exists" do
      expect(@cell).to be_an_instance_of(Cell)
    end

    it "has attributes" do
      expect(@cell.coordinate).to eq("B4")
      expect(@cell.ship).to be nil
    end
  end

  describe "#empty?" do
    it "defaults to true" do
      expect(@cell.empty?).to be true
    end
  end

  describe "#place_ship" do
    it "assigns ship attribute" do
      expect(@cell.ship).to be_nil
      expect(@cell.empty?).to be true
      @cell.place_ship(@cruiser)
      expect(@cell.ship).to eq(@cruiser)
      expect(@cell.empty?).to be false
    end
  end

  describe "#fire_upon and #fired_upon?" do
    it "fires on a cell and updates state" do
      @cell.place_ship(@cruiser)
      expect(@cell.fired_upon?).to be false
      @cell.fire_upon
      expect(@cell.fired_upon?).to be true
      expect(@cell.ship.health).to eq(2)
    end

    it "still functions if cell does not contain ship" do
      expect(@cell.fired_upon?).to be false
      @cell.fire_upon
      expect(@cell.fired_upon?).to be true
    end
  end
end