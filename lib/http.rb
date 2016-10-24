require 'socket'

class Http
  tcp_server = TCPServer.new(9292)
  client = tcp_server.accept

end
