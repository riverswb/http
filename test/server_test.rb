require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/http'
require "pry"

class ServerTest < Minitest::Test

  def test_server_status_is_200
    skip #passes
    response = Faraday.get("http://127.0.0.1:9292/")

    assert_equal 200, response.status
  end

  def test_server_prints_hello_world
    skip #passes
    response = Faraday.get("http://127.0.0.1:9292/hello")
    body = "<html><head></head><body>Hello World! (1)</body></html>"
    assert_equal body, response.body
  end

  def test_server_can_tell_if_a_word_is_known
    skip #passes
    response = Faraday.get("http://127.0.0.1:9292/word_search?param=cat")
    body = "<html><head></head><body>CAT
 is a known word</body></html>"
    assert_equal body, response.body
  end

  def test_server_not_everything_is_in_dictionary
    skip #passes
    response = Faraday.get("http://127.0.0.1:9292/word_search?param=clearlynotaword")
    body = "<html><head></head><body>CLEARLYNOTAWORD
 is not a known word</body></html>"
    assert_equal body, response.body
  end

  def test_server_starts_game
    # skip #passes
    response = Faraday.get("http://127.0.0.1:9292/start_game/post")
    body = "<html><head></head><body>Good Luck</body></html>"

    assert_equal body, response.body
  end

  def test_server_can_get_feedback
    skip #passes
      response = Faraday.get("http://127.0.0.1:9292/game/")
      body = "<html><head></head><body>Last guess was 0
 That is correct</body></html>"

      assert_equal body, response.body
    end

    def test_sever_game_can_generate_a_random_number
      skip
      response = Faraday.get("http://127.0.0.1:9292/start_game/post")
      binding.pry
      assert_includes (0..100), response.number_generator
    end

    # def test_player_can_make_a_guess
    #   game = Game.new
    #   guess = 101
    #   assert_equal "You guessed #{guess}", game.make_guess(guess)
    # end

end
