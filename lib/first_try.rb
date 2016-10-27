require './lib/diagnostics'
require 'socket'

class Http

  attr_reader :diagnostics
  def initialize
    @diagnostics = Diagnostics.new
  end

  def request
    tcp_server = TCPServer.new(9292)
    client = tcp_server.accept

    puts "Ready for a request"
    request_lines = []
    request_count = 0
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    # get_request(client, tcp_server, request_lines, request_count)
    puts "Got this request:"
    puts request_lines.inspect
    request_count += 1
    response(request_lines, request_count, tcp_server, client)
  end

  def response(input, request_count, tcp_server, client)
    puts "Sending response"
    response = "<pre>" + input.join("\n") + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    # binding.pry
    client.puts choose_path(input, request_count, client)
  end

  def body(input)
    "<pre>\n" +
      diagnostics.output_message_verb(input) +
      diagnostics.output_message_path(input) +
      diagnostics.output_message_protocol(input) +
      diagnostics.output_message_host(input) +
      diagnostics.output_message_port(input) +
      diagnostics.output_message_origin(input) +
      diagnostics.output_message_accept(input) +
    "</pre>"
  end

  def path(input)
    diagnostics.output_message_path(input)
  end

  def choose_path(input, request_count, client)
    # binding.pry
    hello_requests = 0
    if path(input) == "Path: /\n"
      body(input)
    elsif path(input) == "Path: /hello\n"
      hello_requests += 1
      "Hello World! #{hello_requests}"
    elsif path(input) == "Path: /datetime\n"
      Time.now.strftime('%I:%M%p on %A, %B %e, %Y')
    elsif path(input) == "Path: /shutdown\n"
      p "Total Requests: #{request_count}"
      client.close
    end
  end
end

if __FILE__ == $0
  Http.new.request
end
