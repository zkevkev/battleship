require "./spec/spec_helper"

RSpec.describe Game do
  before(:each) do
    @game = Game.new
  end

  it "exists" do
    expect(@game).to be_an_instance_of(Game)
    @game.setup
    @game.com_setup
  end

  describe "#fire_upon and #fired_upon?" do
    it "fires on a cell and updates state" do
      @cell_1.place_ship(@cruiser)
      expect(@cell_1.fired_upon?).to be false
      @cell_1.fire_upon
      expect(@cell_1.fired_upon?).to be true
      expect(@cell_1.ship.health).to eq(2)
    end
  end
end
