require './test/test_helper'
require './lib/game'
require './lib/http'

class GameTest < Minitest::Test
  attr_reader :start_game, :http
  def setup
    @http = Http.new
    input = ["POST /start_game HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1)
              AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71
              Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    @start_game = http.check_verb(input)
  end

  def test_game_exists
    assert_instance_of Game, Game.new
  end

  def test_when_starting_a_game_a_number_is_picked
    game = Game.new

    assert_equal true, (0..100).include?(game.number)
  end

  def test_when_path_is_start_game_it_prints_good_luck
    http = Http.new
    input = ["POST /start_game HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1)
              AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71
              Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]
    output = "Good Luck!"
    assert_equal output, http.check_verb(input)
  end

  def test_get_to_game_tells_how_many_guesses_and_a_hint
    start_game
    input = ["GET /game HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1)
              AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71
              Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    output = "You have made 0 guesses\n Hint: Make a guess first"
    assert_equal output, http.check_verb(input)
  end

  def test_it_only_accepts_get_and_post_verbs
    input = ["PUT /game HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1)
              AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71
              Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    output = "Check your verb, please"
    assert_equal output, http.check_verb(input)
  end
end