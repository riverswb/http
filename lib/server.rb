require 'socket'
require './lib/http'

class Server
  attr_reader :tcp_server,
              :client,
              :request_count,
              :request_lines,
              :http
  def initialize
    @tcp_server = TCPServer.new(9292)
    @request_lines = []
    @http = Http.new
  end

  def request
    loop {
      client = tcp_server.accept
      get_request(client)
      http.response(client, request_lines)
      client.close
    }
  end

  def get_request(client)
    @request_lines = []
    while line = client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
  end

end

if __FILE__ == $0
  Server.new.request
end
