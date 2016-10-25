require './lib/diag'
require 'socket'

class Http

  attr_reader :d
  def initialize
    @d = Diag.new
  end

  def request_response
    tcp_server = TCPServer.new(9292)
    client = tcp_server.accept

    puts "Ready for a request"
    request_lines = []
    request_count = 0
    while line = client.gets and !line.chomp.empty?
      request_count += 1
      request_lines << line.chomp
    end

    puts "Got this request:"
    puts request_lines.inspect

    puts "Sending response"
    # binding.pry
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    body = "<pre>\n" +
        d.output_message_verb(request_lines) +
        d.output_message_path(request_lines) +
        d.output_message_protocol(request_lines) +
        d.output_message_host(request_lines) +
        d.output_message_port(request_lines) +
        d.output_message_origin(request_lines) +
        d.output_message_accept(request_lines) +
        "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    puts "Hello World! (#{request_count})"
    puts ["Wrote this response:", headers, output].join("\n")
    client.close
    puts "\nResponde complete, exiting."
    puts ["Outputting Diagnostics:", body]
  end
end
