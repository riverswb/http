require './test/test_helper'
require 'faraday'

class ServerTest < Minitest::Test
i_suck_and_my_tests_are_order_dependent!()

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
    assert_equal 302, response.status
  end

  def test_when_you_make_a_guess_it_redirects_to_get_game
    response = Faraday.post("http://127.0.0.1:9292/gameguess=101")
    response_2 = Faraday.get("http://127.0.0.1:9292/game")
    assert_equal 301, response.status
    assert response_2.body.include?("Too high")
    refute response_2.body.include?("Too low")
  end

  def test_redirects_403_if_a_game_is_in_progress
    Faraday.post("http://127.0.0.1:9292/start_game")
    response = Faraday.post("http://127.0.0.1:9292/start_game")
    output = "<html><body>403 Forbidden</body></html>"
    assert_equal 403, response.status
    assert_equal output, response.body
  end

  def test_responds_with_404_if_unknown_path
    response = Faraday.post("http://127.0.0.1:9292/fofamalou")
    assert_equal 404, response.status
    assert response.body.include?("404 Not Found")
  end

  def test_force_error_responds_with_500_and_the_stack
    response = Faraday.post("http://127.0.0.1:9292/force_error")
    assert_equal 500, response.status
    assert response.body.include?("Stack:")
  end
end
