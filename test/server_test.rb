require './test/test_helper'
require 'faraday'

class ServerTest < Minitest::Test

  def test_server_status_is_200
    response = Faraday.get("http://127.0.0.1:9292/")
    assert_equal 200, response.status
  end

  def test_server_prints_hello_world
    response = Faraday.get("http://127.0.0.1:9292/hello")

    assert_equal true, response.body.include?("Hello World!")
    assert_equal 200, response.status
  end

  def test_server_can_tell_if_a_word_is_known
    response = Faraday.get("http://127.0.0.1:9292/word_search?param=cat")
    body = "<html><body>CAT
 is a known word</body></html>"
    assert_equal body, response.body
    assert_equal 200, response.status
  end

  def test_server_not_everything_is_in_dictionary
    response = Faraday.get("http://127.0.0.1:9292/word_search?param=clearlynotaword")
    body = "<html><body>CLEARLYNOTAWORD
 is not a known word</body></html>"
    assert_equal body, response.body
    assert_equal 200, response.status
  end

  def test_path_is_start_game
    response = Faraday.post("http://127.0.0.1:9292/start_game")
    output = "<html><body>Good Luck!</body></html>"
    assert_equal output, response.body
    assert_equal 200, response.status
  end

  def test_when_you_make_a_guess_it_redirects_to_get_game
    response = Faraday.post("http://127.0.0.1:9292/gameguess=101")
    response_2 = Faraday.get("http://127.0.0.1:9292/game")
    assert_equal 302, response.status
    assert response_2.body.include?("Too high")
  end
end
