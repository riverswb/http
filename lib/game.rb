class Game
  attr_reader :guess_count, :last_guess, :number
  def initialize
    @guess_count = 0
    @last_guess = 0
    @number = number
  end

  def number_generator
    @number = (0..100).to_a.sample
  end

  def set_number(input)
    @number = input
  end

  def make_guess(guess)
    @guess_count += 1
    @last_guess = guess
    "You guessed #{guess}"
  end

  def feedback
    if last_guess > number
      "Last guess was too high"
    elsif last_guess < number
      "Last guess was too low"
    elsif last_guess == number
      "That is correct"
    end
  end

  def start_game
    number_generator
    puts "Good Luck"
  end
end
