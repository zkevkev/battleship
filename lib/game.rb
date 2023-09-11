require "./spec/spec_helper"

class Game
  def setup
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    setup_response = gets.chomp

    if setup_response == "q" || setup_response == "Q"
      puts 'Game over'
    elsif setup_response == "p" || setup_response == "P"
    end
  end
      
  def com_setup
    @com_board = Board.new
    @com_board.generate_cells
    # Computer places pieces
    @com_cruiser = Ship.new("Cruiser", 3)
    @com_sub = Ship.new("Submarine", 2)
    @com_board.computer_ship_placement(com_cruiser)
    @com_board.computer_ship_placement(com_sub)
  end

  def user_setup
    #user shtuff
    @user_board = Board.new
    @user_board.generate_cells
    puts new_board.render
    # user places pieces
    @user_cruiser = Ship.new("Cruiser", 3)
    @user_sub = Ship.new("Submarine", 2)
    # method in Board class
  end

  def start_method 
    puts "I have laid out my ships on the grid./n
    You now need to lay out your two ships./n
    The Cruiser is three units long and the Submarine is two units long./n"
    puts @user_board.render
  end

  def user_placement
    puts "Enter the squares for the Cruiser (3 spaces):"
    cruiser_input = gets.chomp
    cruiser_input = cruiser_input.split
    if cruiser_input.all? { |coordinate| valid_coordinate?(coordinate) } && valid_placement?(cruiser_input)
      @user_board.place(@user_cruiser, cruiser_input)
    else
      puts "Those are invalid coordinates, admiral. Please try again."
      user_placement
    end
  end
  

end
