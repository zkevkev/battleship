require "./spec/spec_helper"

class Game
  def setup
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    setup_response = gets.chomp

    if setup_response == "q" || setup_response == "Q"
      puts 'Game over'
    elsif setup_response == "p" || setup_response == "P"
      com_board = Board.new
      com_board.generate_cells
      puts new_board.render
      # Computer places pieces
      com_cruiser = Ship.new("Cruiser", 3)
      com_sub = Ship.new("Submarine", 2)
      com_board.computer_ship_placement(com_cruiser)
      com_board.computer_ship_placement(com_sub)
     
      #user shtuff
      user_board = Board.new
      user_board.generate_cells
      puts new_board.render
      # userplaces pieces
      user_cruiser = Ship.new("Cruiser", 3)
      user_sub = Ship.new("Submarine", 2)
      user_board.user_ship_placement(user_cruiser)
      user_board.user_ship_placement(user_sub)
      # method in Board class
    end

  end
end