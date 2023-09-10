class Battleship
  def start
    puts "Welcome to BATTLESHIP"
    puts "Enter p to play. Enter q to quit."
    setup_response = gets.chomp

    if setup_response == "q" || "Q"
    elsif setup_response == "p" || "P"
    end
  end
end