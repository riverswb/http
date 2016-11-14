class Game
  attr_reader :number,
              :guess_count,
              :guess,
              :game_running
  def initialize
    @number = rand(100)
    @guess_count = 0
    @guess = guess
    @game_running = false
  end

  def start_game
    @game_running = true
  end

  def set_guess(input)
    if input.class == Fixnum
      @guess_count += 1
      @guess = (input)
    else "Please make guesses as a whole number, between 0 and 100"
    end
  end

  def hint
    if guess_count == 0
      "Hint: Make a guess first"
    elsif guess.class == Fixnum
      if guess < number
        "Too low"
      elsif guess > number
        "Too high"
      elsif guess == number
        "Winner!"
      end
    end
  end

end
