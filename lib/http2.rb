require 'socket'

class Http
  attr_reader :request_count, :tcp_server
  def initialize
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
    client.puts "Hello World! (#{request_count})"
  end





end

if __FILE__ == $0
  Http.new.request
end
