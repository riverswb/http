require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/http'
require "pry"

class ServerTest < Minitest::Test
  attr_reader :request_count,
              :hello_count
  def setup
    @request_count = 0
    @hello_count = 0
  end

  def test_server_status_is_200
    response = Faraday.get("http://127.0.0.1:9292/")

    assert_equal 200, response.status
  end

  def test_server_prints_hello_world
    @hello_count += 1
    response = Faraday.get("http://127.0.0.1:9292/hello")
    body = "<html><body>Hello World! (#{hello_count})</body></html>"
    assert_equal body, response.body
  end

  def test_server_can_tell_if_a_word_is_known
    response = Faraday.get("http://127.0.0.1:9292/word_search?param=cat")
    body = "<html><body>CAT
 is a known word</body></html>"
    assert_equal body, response.body
  end

  def test_server_not_everything_is_in_dictionary
    response = Faraday.get("http://127.0.0.1:9292/word_search?param=clearlynotaword")
    body = "<html><body>CLEARLYNOTAWORD
 is not a known word</body></html>"
    assert_equal body, response.body
  end
end
