require 'minitest/autorun'
require 'minitest/emoji'
require 'faraday'
require './lib/http2'
require 'pry'

class HttpTest < Minitest::Test





  def test_word_in_dictionary
    http = Http.new

    word = "cat"
    assert_equal "#{word.upcase} is a known word", http.word_is_in_dictionary(word)
  end

  def test_not_everything_is_in_dictionary
    http = Http.new

    word = "clearlynotaword"
    assert_equal "#{word.upcase} is not a known word", http.word_is_in_dictionary(word)
  end

  def test_starts_game_if_path_and_verb_call_for_it
    http = Http.new
    input = ["POST /startgame HTTP/1.1",
                "Host: 127.0.0.1:9292",
                "Connection: keep-alive",
                "Cache-Control: no-cache",
                "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
                "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
                "Accept: */*",
                "Accept-Encoding: gzip, deflate, sdch, br",
                "Accept-Language: en-US,en;q=0.8"]

    assert_output ("Good Luck\n"){http.game_check(input)}
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
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
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
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
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
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    output = Time.now.strftime('%I:%M%p on %A, %B %e, %Y')

    assert_equal output, http.choose_path(input)
  end

#   def test_choose_path_shutdown
#     http = Http.new
      # client = tcp_server.accept
#     input = ["GET /shutdown HTTP/1.1",
#             "Host: 127.0.0.1:9292",
#             "Connection: keep-alive",
#             "Cache-Control: no-cache",
#             "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
#             "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
#             "Accept: */*",
#             "Accept-Encoding: gzip, deflate, sdch, br",
#             "Accept-Language: en-US,en;q=0.8"]
#
#     output = "Total Requests: 1"
#
#     assert_equal output, http.choose_path(input, client)
#   end
# #
# #   def test_request_path_shutdown
# # skip
# #     http = Http.new
# #     tcp_server = Faraday.get("")
# #     client = tcp_server.accept
# #
# #     input = ["GET /shutdown HTTP/1.1",
# #             "Host: 127.0.0.1:9292",
# #             "Connection: keep-alive",
# #             "Cache-Control: no-cache",
# #             "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
# #             "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
# #             "Accept: */*",
# #             "Accept-Encoding: gzip, deflate, sdch, br",
# #             "Accept-Language: en-US,en;q=0.8"]
# #
# #     output = "Total Requests: 1"
# #
# #     assert_equal output, http.response(input, 1, tcp_server, client)
# #   end
#
#
end
