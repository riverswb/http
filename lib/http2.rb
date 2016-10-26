require 'socket'
require './lib/diagnostics'

class Http
  attr_reader :request_count, :tcp_server, :diagnostics
  def initialize
    @diagnostics = Diagnostics.new
    @request_count = 0
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
    # binding.pry
    # client.puts "Hello World! (#{request_count})"
    client.puts diagnostics_message
  end

  def diagnostics_message
    "<pre>\n" +
      diagnostics.output_message_verb(@request_lines) +
      diagnostics.output_message_path(@request_lines) +
      diagnostics.output_message_protocol(@request_lines) +
      diagnostics.output_message_host(@request_lines) +
      diagnostics.output_message_port(@request_lines) +
      diagnostics.output_message_origin(@request_lines) +
      diagnostics.output_message_accept(@request_lines) +
    "</pre>"
  end




end

if __FILE__ == $0
  Http.new.request
end
