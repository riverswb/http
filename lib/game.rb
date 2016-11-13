class Game
  attr_reader :number, :guess_count
  def initialize
    @number = rand(100)
    @guess_count = 0
  end

  def hint
    if guess_count == 0
      "Hint: Make a guess first"
    end
  end
end
