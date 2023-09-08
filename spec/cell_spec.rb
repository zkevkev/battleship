require "./spec/spec_helper"

RSpec.describe Cell do

  before(:each) do
    @cell = Cell.new("B4")
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
end