require './test/test_helper'

class HttpTest < Minitest::Test

  attr_reader :start_input
  def setup
    @start_input = ["POST /start_game HTTP/1.1",
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
  end

  def test_http_exists
    assert Http.new
  end

  def test_choose_path_root

    http = Http.new
    input = ["GET / HTTP/1.1",
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

    output = "<pre>
VERB: GET
Path: /
Protocol: HTTP/1.1
Host: 127.0.0.1
Port: 9292
Origin: 127.0.0.1
Accept: */*
</pre>"

    assert_equal output,http.choose_path(input)
  end

  def test_choose_path_hello

    http = Http.new
    input = ["GET /hello HTTP/1.1",
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

    output = "Hello World! (1)"

    assert_equal output, http.choose_path(input)
  end

  def test_choose_path_date_time
    http = Http.new
    input = ["GET /datetime HTTP/1.1",
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

    output = Time.now.strftime('%I:%M%p on %A, %B %e, %Y')

    assert_equal output, http.choose_path(input)
  end

  def test_unknown_request_returns_try_again
    http = Http.new
    input = ["GET /unknown request/1.1",
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

    output = "I'm sorry, try again"

    assert_equal output, http.choose_path(input)
  end

  def test_choose_path_shutdown
    skip #this causes the rake to fail because it exits everything
    http = Http.new
    input = ["GET /shutdown HTTP/1.1",
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

    output = "Total Requests: 0"

    assert_equal output, http.choose_path(input)
  end

  def test_if_verb_is_not_get_or_post_it_tells_you
    http = Http.new
    input = ["DELETE / HTTP/1.1",
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

  def test_get_test_will_return_the_type_for_redirect_location_game
    http = Http.new
    input = ["POST /game HTTP/1.1",
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

    assert_equal "game", http.get_type(input)
  end

  def test_get_test_will_return_the_type_for_redirect_location_start_game
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

    assert_equal "start_game", http.get_type(input)
  end

  def test_response_build_responds_with_404_if_unknown_path_sarge
    http = Http.new
    input = ["POST /sarge HTTP/1.1",
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

    assert_equal "404 Not Found", http.response_build(input)
  end

  def test_force_error_checker_returns_true_if_request_is_force_error
    http = Http.new
    input = ["POST /force_error HTTP/1.1",
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

    assert http.force_error?(input)
  end

  def test_known_path_returns_true_if_path_is_known_false_if_not_known
    http = Http.new
    input = "Path: /\n"
    input_2 = "Path: /sarge"

    assert http.known_path(input)
    refute http.known_path(input_2)
  end

  def test_path_returns_path_when_given_request
    http = Http.new
    input = ["POST /force_error HTTP/1.1",
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

    assert http.path(input).include?("force_error")
  end

  def test_verb_returns_verb_when_given_request
    http = Http.new
    input = ["POST /force_error HTTP/1.1",
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

    assert http.verb(input).include?("POST")
  end

  def test_path_game_returns_true_if_request_is_a_game_request
    http = Http.new
    input = ["POST /game HTTP/1.1",
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

    assert http.path_game?(input)
  end

  def test_path_game_returns_false_if_request_is_not_a_game_request
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

    refute http.path_game?(input)
  end

  def test_verb_post_returns_true_if_request_verb_is_post
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

    assert http.verb_post?(input)
  end

  def test_verb_post_returns_false_if_request_verb_is_not_a_post
    http = Http.new
    input = ["GET /start_game HTTP/1.1",
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

    refute http.verb_post?(input)
  end

  def test_game_running_returns_true_if_game_is_running_false_if_not_running
    http = Http.new

    refute http.game_running?

    http.game.start_game

    assert http.game_running?
  end
end
