require 'socket'
require './lib/diagnostics'
require './lib/game'
require './lib/server'
require 'pry'

class Http
  attr_reader :request_count,
              :tcp_server,
              :diagnostics,
              :request_lines,
              :hello_requests,
              :game,
              :client,
              :server
  def initialize
    @diagnostics = Diagnostics.new
    @game = Game.new
    # @tcp_server = tcp_server
    # @request_count = 0
    @hello_requests = 0
    # @request_lines = []
    # @client = client
    @server = Server.new
  end

  # def request
  #   loop {
  #     @tcp_server = TCPServer.new(9292)
  #     client = tcp_server.accept
  #     get_request(client)
  #     @request_count += 1
  #     response(client)
  #     client.close
  #   }
  # end

  # def get_request(client)
  #   while line = client.gets and !line.chomp.empty?
  #     @request_lines << line.chomp
  #   end
  # end

  def response(client)
    # game_response = [game_check(request_lines), game.number]
    response = choose_path(request_lines)
    # binding.pry
    output = "<html><head></head><body>#{response}</body></html>"
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
    # binding.pry
    if path(request_lines) == "Path: /\n"
      diagnostics.full_output_message(request_lines)
    elsif path(request_lines) == "Path: /hello\n"
      @hello_requests += 1
      "Hello World! (#{hello_requests})"
    elsif path(request_lines) == "Path: /datetime\n"
      Time.now.strftime('%I:%M%p on %A, %B %e, %Y')
    elsif path(request_lines) == "Path: /shutdown\n"
      p "Total Requests: #{request_count}"
      tcp_server.accept.close
    elsif path(request_lines).include?("word_search")
      word = path(request_lines).split("=")[1]
      word_is_in_dictionary(word)
    elsif path(request_lines).include?("game")
      game_check(request_lines)
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

  def game_check(request_lines)
    if path(request_lines) == "PATH: start_game\n"
      game.start_game
      "Good Luck"
    elsif path(request_lines) == "game"
      "Last guess was #{game.last_guess}\n #{game.feedback}"
    end
  end


end

# if __FILE__ == $0
#   Http.new.request
# end
