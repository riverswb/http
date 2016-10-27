require './lib/diagnostics'
require './lib/dictionary'

class Http
  attr_reader :request_count,
              :diagnostics,
              :hello_requests,
              :dictionary
  def initialize
    @diagnostics = Diagnostics.new
    @dictionary = Dictionary.new
    @request_count = 0
    @hello_requests = 0
  end

  def response(client, request_lines)
    @request_count += 1
    response = choose_path(request_lines)
    output = "<html><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
  end

  def path(request_lines)
    diagnostics.output_message_path(request_lines)
  end

  def verb(request_lines)
    diagnostics.output_message_verb(request_lines)
  end

  def choose_path(request_lines)
    if path(request_lines) == "Path: /\n"
      diagnostics.full_output_message(request_lines)
    elsif path(request_lines) == "Path: /hello\n"
      @hello_requests += 1
      "Hello World! (#{hello_requests})"
    elsif path(request_lines) == "Path: /datetime\n"
      Time.now.strftime('%I:%M%p on %A, %B %e, %Y')
    elsif path(request_lines) == "Path: /shutdown\n"
      p "Total Requests: #{request_count}"
      exit
    elsif path(request_lines).include?("word_search")
      word = path(request_lines).split("=")[1]
      dictionary.word_is_in_dictionary(word)
    else "I'm sorry, try again"
    end
  end
end
