require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'

class GameTest < Minitest::Test

  def test_game_can_generate_a_random_number
    game = Game.new
    assert_includes (0..100), game.number_generator
  end

  def test_player_can_make_a_guess
    game = Game.new
    guess = 101
    assert_equal "You guessed #{guess}", game.make_guess(guess)
  end

  def test_server_keeps_track_of_guess_count
    game = Game.new
    game.make_guess(101)
    assert_equal 1, game.guess_count
    10.times {game.make_guess(102)}
    assert_equal 11, game.guess_count
  end

  def test_game_knows_the_most_recent_guess
    game = Game.new
    game.make_guess(101)
    assert_equal 101, game.last_guess
  end

  def test_game_knows_if_last_guess_was_too_high
    game = Game.new
    game.number_generator
    game.make_guess(101)
    assert_equal "Last guess was too high", game.feedback
  end

  def test_game_knows_if_last_guess_was_too_low
    game = Game.new
    game.number_generator
    game.make_guess(-1)
    assert_equal "Last guess was too low", game.feedback
  end

  def test_game_knows_if_last_guess_was_correct
    game = Game.new
    game.set_number(8)
    game.make_guess(8)
    assert_equal "That is correct", game.feedback
  end
end
