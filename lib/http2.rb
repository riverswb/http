require 'socket'
require './lib/diagnostics'

class Http
  attr_reader :request_count, :tcp_server, :diagnostics, :request_lines, :hello_requests
  def initialize
    @diagnostics = Diagnostics.new
    @request_count = 0
    @hello_requests = 0
    @tcp_server = TCPServer.new(9292)
    @request_lines = []
  end

  def request
    loop do
      client = tcp_server.accept
      get_request(client)
      @request_count += 1
      response(client)
      client.close
    end
  end

  def get_request(client)
    while line = client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
  end

  def response(client)
    client.puts choose_path(request_lines)
  end

  def diagnostics_message
    "<pre>\n" +
      diagnostics.output_message_verb(request_lines) +
      diagnostics.output_message_path(request_lines) +
      diagnostics.output_message_protocol(request_lines) +
      diagnostics.output_message_host(request_lines) +
      diagnostics.output_message_port(request_lines) +
      diagnostics.output_message_origin(request_lines) +
      diagnostics.output_message_accept(request_lines) +
    "</pre>"
  end

  def path(request_lines)
    diagnostics.output_message_path(request_lines)
  end

  def choose_path(request_lines)
    if path(request_lines) == "Path: /\n"
      diagnostics_message
    elsif path(request_lines) == "Path: /hello\n"
      @hello_requests += 1
      "Hello World! #{hello_requests}"
    elsif path(request_lines) == "Path: /datetime\n"
      Time.now.strftime('%I:%M%p on %A, %B %e, %Y')
    elsif path(request_lines) == "Path: /shutdown\n"
      p "Total Requests: #{request_count}"
      client.close
    elsif path(request_lines) == "Path: /word_search\n"
      word_is_in_dictionary(word)
    end
  end

  def word_is_in_dictionary(word)
    dictionary = File.read("/usr/share/dict/words")
    if dictionary.include?(word)
      "#{word.upcase} is a known word"
    else
      "#{word.upcase} is not a known word"
    end
  end


end

if __FILE__ == $0
  Http.new.request
end
