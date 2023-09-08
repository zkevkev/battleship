require "./spec/spec_helper"

RSpec.describe Ship do
  before(:each) do
    @cruiser = Ship.new("Cruiser", 3)
  end
  describe "#initialize" do
    it "exists" do
      expect(@cruiser).to be_an_instance_of(Ship)
    end

    it "has attributes" do
      expect(@cruiser.name).to eq("Cruiser")
      expect(@cruiser.length).to eq(3)
      expect(@cruiser.health).to eq(3)
    end
  end

  describe "#sunk?" do
    it "ship defaults as not sunk" do
      expect(@cruiser.sunk?).to be false
    end
    
    it "can tell when a ship is sunk" do
      expect(@cruiser.sunk?).to be false
      3.times {@cruiser.hit}
      expect(@cruiser.health).to eq(0)
      expect(@cruiser.sunk?).to be true
    end
  end

  describe "#hit" do
    it "decrements health" do
      expect(@cruiser.health).to eq(3)
      @cruiser.hit
      
    end
  end
end
