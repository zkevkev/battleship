require "./spec/spec_helper"

class Game
  def setup
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    setup_response = gets.chomp

    if setup_response == "q" || setup_response == "Q"
      puts 'Game over'
    elsif setup_response == "p" || setup_response == "P"
      new_board = Board.new
      new_board.generate_cells
      puts new_board.render
      # Computer places pieces
      cruiser = Ship.new("Cruiser", 3)
      submarine = Ship.new("Submarine", 2)
      new_board.computer_ship_placement(cruiser)
      new_board.computer_ship_placement(submarine)
      puts new_board.render
      # method in Board class
    end

  end
end