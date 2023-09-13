require "./spec/spec_helper"

RSpec.describe Game do
  before(:each) do
    @game = Game.new
  end

  it "exists" do
    expect(@game).to be_an_instance_of(Game)
  end

  # We are unsure if we should test these, as it would require an attr_reader just for purpose of testing.
  # it "has attributes" do
  #   expect(@game.com_board).to be_an_instance_of(Board)
  #   expect(@game.user_board).to be_an_instance_of(Board)
  #   expect(@game.user_cruiser).to be_an_instance_of(Ship)
  #   expect(@game.user_sub).to be_an_instance_of(Ship)
  #   expect(@game.com_sub).to be_an_instance_of(Ship)
  #   expect(@game.com_cruiser).to be_an_instance_of(Ship)
  #   expect(@game.user_shot_input).to be nil
  #   expect(@game.com_shot).to be nil
  # end
end
