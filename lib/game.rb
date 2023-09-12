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
      # Computer places pieces
      @com_board.computer_ship_placement(@com_cruiser)
      @com_board.computer_ship_placement(@com_sub)
      # User places pieces
      user_setup
    end
  end

  def user_setup 
    puts "I have laid out my ships on the grid.
    You now need to lay out your two ships.
    The Cruiser is three units long and the Submarine is two units long."
    puts @user_board.render
    puts "Enter the squares for the Cruiser (3 spaces):"
 
    input_placement_checker(@user_cruiser)
  end

  def input_placement_checker(ship)
    user_input = gets.chomp
    user_input = user_input.split

    all_coordinate_valid = user_input.all? { |coordinate| @user_board.valid_coordinate?(coordinate) }

    # I hate that this fixed it...but I swapped the two conditions and it started to work...
    if @user_board.valid_placement?(ship, user_input) && all_coordinate_valid && 
      @user_board.place(ship, user_input)
      # Logic for sub placement
      @user_board.cells.each do |coordinate, cell|
        if cell.ship == @user_sub
          turn
        end
      end
      puts "Enter the squares for the Submarine (2 spaces):"
      input_placement_checker(@user_sub)      
    else
      puts "Those are invalid coordinates, admiral. Please try again."
      input_placement_checker(ship)
    end
  end
  
  def turn
    puts "=============COMPUTER BOARD============="
    puts @com_board.render
    puts "==============PLAYER BOARD=============="
    puts @user_board.render(true)
    puts "Enter the coordinate for your shot:"
    user_input = gets.chomp
    @user_board.fire_upon(user_input)
    
    if @user_board.cells[user_input].ship == nil && 
      shot_outcome = "miss"
    elsif @user_board.cells[user_input].ship != nil && @user_board.cells[user_input].ship.health > 0
      shot_outcome = "hit!"
    elsif @user_board.cells[user_input].ship != nil && @user_board.cells[user_input].ship.health <= 0
      shot_outcome = "hit! You sunk my #{@user_board.cells[user_input].ship}"
    end
    puts "Your shot on #{user_input} was a #{shot_outcome}."
    # computer shoots (include some kind of collision check)
    # feedback on computer shot
    # check for if all ships of either player are sunk (game over method)
    turn # will cycle until game over conditions are met
  end
end
