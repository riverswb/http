require './test/test_helper'

class DiagnosticsTest < Minitest::Test

  def test_output_message_verb
    d = Diagnostics.new
    input = ["GET / HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    assert_equal "VERB: GET\n", d.output_message_verb(input)
  end

  def test_output_message_path
    d = Diagnostics.new
    input = ["GET / HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    assert_equal "Path: /\n", d.output_message_path(input)
  end

  def test_output_message_protocol
    d = Diagnostics.new
    input = ["GET / HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    assert_equal "Protocol: HTTP/1.1\n", d.output_message_protocol(input)
  end

  def test_output_message_host
    d = Diagnostics.new
    input = ["GET / HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    assert_equal "Host: 127.0.0.1\n", d.output_message_host(input)
  end

  def test_output_message_port
    d = Diagnostics.new
    input = ["GET / HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    assert_equal "Port: 9292\n", d.output_message_port(input)
  end

  def test_output_message_origin
    d = Diagnostics.new
    input = ["GET / HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    assert_equal "Origin: 127.0.0.1\n", d.output_message_origin(input)
  end

  def test_output_message_accept
    d = Diagnostics.new
    input = ["GET / HTTP/1.1",
            "Host: 127.0.0.1:9292",
            "Connection: keep-alive",
            "Cache-Control: no-cache",
            "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
            "Postman-Token: 22f6e411-c3a5-b02c-d7b9-cf45ccd1b180",
            "Accept: */*",
            "Accept-Encoding: gzip, deflate, sdch, br",
            "Accept-Language: en-US,en;q=0.8"]

    assert_equal "Accept: */*\n", d.output_message_accept(input)
  end

end
