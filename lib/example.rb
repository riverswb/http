require 'socket'

class Http
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

  puts "Sending respone."
  response = "<pre>" + request_lines.join("\n") + "</pre>"
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

end
