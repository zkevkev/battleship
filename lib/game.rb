require "./spec/spec_helper"

class Game
  def initialize
    @com_board = Board.new
    @com_cruiser = Ship.new("Cruiser", 3)
    @com_sub = Ship.new("Submarine", 2)
    @user_board = Board.new
    @user_cruiser = Ship.new("Cruiser", 3)
    @user_sub = Ship.new("Submarine", 2)
    @user_shot_input = nil
    @com_shot = nil
  end

  def setup
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    setup_response = gets.chomp.downcase

    if setup_response == "q"
      abort "Game over"
    elsif setup_response == "p"
      # Computer places pieces
      @com_board.computer_ship_placement(@com_cruiser)
      @com_board.computer_ship_placement(@com_sub)
      # User places pieces
      user_setup
    else
      setup
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
    user_placement = gets.chomp.upcase
    user_placement_index = (ship.length * 2) == user_placement.delete(" ").length
    user_placement = user_placement.split
    all_coordinate_valid = user_placement.all? { |coordinate| @user_board.valid_coordinate?(coordinate) }

    if user_placement_index && all_coordinate_valid && @user_board.valid_placement?(ship, user_placement)
      @user_board.place(ship, user_placement)
      # Logic for sub placement check
      @user_board.cells.each do |coordinate, cell|
        start_turn if cell.ship == @user_sub
      end
      puts "Enter the squares for the Submarine (2 spaces):"
      input_placement_checker(@user_sub)
    else
      puts "Those are invalid coordinates, admiral. Please try again."
      input_placement_checker(ship)
    end
    puts "Those are invalid coordinates, admiral. Please try again."
    input_placement_checker(ship)
  end

  def start_turn
    puts "=============COMPUTER BOARD============="
    puts @com_board.render
    puts "==============PLAYER BOARD=============="
    puts @user_board.render(true)
    puts "Enter the coordinate for your shot:"
    user_turn
  end

  def user_turn
    until @user_cruiser.health == 0 && @user_sub.health == 0
      @user_shot_input = gets.chomp.upcase.strip
      if !@com_board.valid_coordinate?(@user_shot_input)
        puts "Please enter a valid coordinate"
        user_turn
      elsif @com_board.valid_coordinate?(@user_shot_input) && @com_board.cells[@user_shot_input].fired_upon?
        puts "That coordinate has already been fired upon, pick somewhere else"
        user_turn
      else
      @com_board.fire_upon(@user_shot_input)
      com_turn
      end
    end
    turn_result
  end

  def com_turn
    @com_shot = @user_board.com_fire_upon
      turn_result
  end

  def turn_result
    com_board_cell_render = @com_board.cells[@user_shot_input].render
    if com_board_cell_render  == "M"
      user_shot_outcome = "miss."
    elsif com_board_cell_render == "H"
      user_shot_outcome = "hit!"
    elsif com_board_cell_render == "X"
      user_shot_outcome = "hit! You sunk my #{@com_board.cells[@user_shot_input].ship.name}. Blyat."
    end

    user_board_cell_render = @user_board.cells[@com_shot].render
    if user_board_cell_render == "M"
      com_shot_outcome = "miss."
    elsif user_board_cell_render == "H"
      com_shot_outcome = "hit!"
    elsif user_board_cell_render == "X"
      com_shot_outcome = "hit! I sunk your #{@user_board.cells[@com_shot].ship.name}."
    end

    # feedback on computer shot
    # check for if all ships of either player are sunk (game over method)
    puts "Your shot on #{@user_shot_input} was a #{user_shot_outcome}"
    puts "My shot on #{@com_shot} was a #{com_shot_outcome}"

    if (@com_cruiser.health == 0 && @com_sub.health == 0) || (@user_cruiser.health == 0 && @user_sub.health == 0)
      game_over
    else
      start_turn # will cycle until game over conditions are met
    end
  end

  def game_over
    puts "=============COMPUTER BOARD============="
    puts @com_board.render
    puts "==============PLAYER BOARD=============="
    puts @user_board.render(true)
    if @user_cruiser.health == 0 && @user_sub.health == 0
      puts "You just lost to a computer made by mod 1 students. Pathetic."
      puts "Press return to go to main menu."
      gets.chomp
    else
      puts "You may have won this battle, but you haven't seen the last of me."
      puts "Press return to go to main menu."
      gets.chomp
    end
    @user_board.clear_board
    @com_board.clear_board
    setup
  end
end