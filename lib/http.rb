require './lib/diagnostics'
require './lib/dictionary'
require './lib/game'

class Http
  attr_reader :request_count,
              :diagnostics,
              :hello_requests,
              :dictionary,
              :game
  def initialize
    @diagnostics = Diagnostics.new
    @dictionary = Dictionary.new
    # @game = Game.new
    @request_count = 0
    @hello_requests = 0
  end

  def response(client, request_lines)
    @request_count += 1
    response = check_verb(request_lines)
    output = "<html><body>" + %Q(#{response}) + "</body></html>"
    client.puts headers(output) if !game_post_request?(request_lines) && known_path(path(request_lines))
    client.puts redirect_headers(output, request_lines) if game_post_request?(request_lines) || !known_path(path(request_lines))
    client.puts output
  end

  def game_post_request?(request_lines)
    if diagnostics.output_message_verb(request_lines) == "VERB: POST\n"
      if path(request_lines).include?("start_game")
        # game.game_running = true
        true
      elsif path(request_lines).include?("/game")
        true
      end
    end
  end

  def redirect_headers(output,request_lines)
    ["http/1.1 #{status_codes(request_lines)}",
      "Location: http://127.0.0.1:9292/game",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def status_codes(request_lines)
    if !known_path(path(request_lines))
      "404 Not Found"
    elsif path(request_lines).include?("start_game") && game.game_running == false
      game.start_game
      return "301 Moved Permanetly"
    elsif diagnostics.output_message_verb(request_lines).include?("POST") && path(request_lines).include?("/game")
      "301 Moved Permanetly"
    elsif path(request_lines).include?("start_game") && game.game_running == true
      "403 Forbidden"
    end
  end

  def known_path(path)
    known_paths.any? {|known| path.include?(known)}
  end

  def known_paths
    ["/\n", "/hello\n", "/game", "/datetime\n", "/shutdown\n", "/word_search", "/start_game"]
    end

  def headers(output)
    ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def path(request_lines)
    diagnostics.output_message_path(request_lines)
  end

  def verb(request_lines)
    diagnostics.output_message_verb(request_lines)
  end

  def check_verb(request_lines)
    if diagnostics.output_message_verb(request_lines) == "VERB: GET\n"
      choose_path(request_lines)
    elsif diagnostics.output_message_verb(request_lines) == "VERB: POST\n"
      post_paths(request_lines)
    else "Check your verb, please"
    end
  end

  def post_paths(request_lines)
    if path(request_lines) == "Path: /start_game\n"
      path_game if game.nil?
      "Good Luck!"
    elsif path(request_lines).include?("/game")
      if game
        guess = path(request_lines).split('=')[1].to_i
        game.set_guess(guess)
      else
        "Start a game"
      end
    end
  end


  def choose_path(request_lines)
    if path(request_lines) == "Path: /\n"
      path_root(request_lines)
    elsif path(request_lines) == "Path: /hello\n"
      path_hello(request_lines)
    elsif path(request_lines) == "Path: /datetime\n"
      path_time(request_lines)
    elsif path(request_lines) == "Path: /shutdown\n"
      path_shutdown(request_lines)
    elsif path(request_lines).include?("word_search")
      path_dictionary(request_lines)
    elsif path(request_lines) == "Path: /game\n"
      if game
        game_information
      else "Start a game first!"
      end
    else "I'm sorry, try again"
    end
  end

  def game_information
    "You have made #{game.guess_count} guesses\n #{game.hint}"
  end

  def path_game
    @game = Game.new
  end

  def path_root(request_lines)
    diagnostics.full_output_message(request_lines)
  end

  def path_hello(request_lines)
    @hello_requests += 1
    "Hello World! (#{hello_requests})"
  end

  def path_time(request_lines)
    Time.now.strftime('%I:%M%p on %A, %B %e, %Y')
  end

  def path_shutdown(request_lines)
    p "Total Requests: #{request_count}"
    exit
  end

  def path_dictionary(request_lines)
    word = path(request_lines).split("=")[1]
    dictionary.word_is_in_dictionary(word)
  end
end
