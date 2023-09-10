require "./spec/spec_helper"

class Battleship
  def start
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    setup_response = gets.chomp

    if setup_response == "q" || setup_response == "Q"
      puts 'Game over'
    elsif setup_response == "p" || setup_response == "P"
      new_board = Board.new
      new_board.generate_cells
      puts new_board.render
    end
  end
end

battleship = Battleship.new
battleship.start