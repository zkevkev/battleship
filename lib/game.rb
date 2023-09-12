require "./spec/spec_helper"

class Game
  def initialize
    @com_board = Board.new
    @com_board.generate_cells
    @com_cruiser = Ship.new("Cruiser", 3)
    @com_sub = Ship.new("Submarine", 2)
    @user_board = Board.new
    @user_cruiser = Ship.new("Cruiser", 3)
    @user_sub = Ship.new("Submarine", 2)
  end

  def setup
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    setup_response = gets.chomp

    if setup_response == "q" || setup_response == "Q"
      puts 'Game over'
    elsif setup_response == "p" || setup_response == "P"
      com_setup
    end
  end
      
  def com_setup
    # Computer places pieces
    @com_board.computer_ship_placement(@com_cruiser)
    @com_board.computer_ship_placement(@com_sub)

    user_setup
  end
    #user shtuff
    # user places pieces
    # method in Board class
  def user_setup 
    puts "I have laid out my ships on the grid.
    You now need to lay out your two ships.
    The Cruiser is three units long and the Submarine is two units long."
    puts @user_board.render

    user_placement
  end

  def user_placement
    puts "Enter the squares for the Cruiser (3 spaces):"
 
    input_placement_checker  
  end

  def input_placement_checker
    user_input = gets.chomp
    user_input = user_input.split

    valid_coordinate = user_input.all? { |coordinate| @user_board.valid_coordinate?(coordinate) }

    if valid_coordinate # && @user_board.valid_placement?(@user_cruiser, user_input)
      @user_board.place(@user_cruiser, user_input)
    else
      puts "Those are invalid coordinates, admiral. Please try again."
      input_placement_checker
    end
  end
  

end
