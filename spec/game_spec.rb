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
end
