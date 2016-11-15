require './lib/diagnostics'
require './lib/dictionary'
require './lib/game'

class Http
  attr_reader :request_count,
              :diagnostics,
              :hello_requests,
              :dictionary,
              :game,
              :start_counter

  def initialize
    @diagnostics = Diagnostics.new
    @dictionary = Dictionary.new
    @game = Game.new
    @request_count = 0
    @hello_requests = 0
    @start_counter = -1
  end

  def response(client, request_lines)
    @request_count += 1
    type = get_type(request_lines)
    response = response_build(request_lines)
    output = "<html><body>" + "#{response}" + "</body></html>"
    select_header(request_lines, output, type, client)
    client.puts output
  end

  def select_header(request_lines, output, type, client)
    if headers?(request_lines)
      client.puts headers(output)
    else client.puts redirect_headers(output, request_lines, type)
    end
  end

  def headers?(request_lines)
    if !game_post_request?(request_lines)
      if known_path(path(request_lines))
        if !force_error?(request_lines)
          true
        end
      end
    end
  end

  def get_type(request_lines)
    if  verb_post?(request_lines) && path_start_game?(request_lines)
      if !game_running?
        "start_game"
      else "game"
      end
  elsif verb_post?(request_lines) && path_game?(request_lines)
      "game"
    end
  end

  def redirect_headers(output,request_lines, type)
    ["http/1.1 #{status_codes(request_lines)}",
      "Location: http://127.0.0.1:9292/" + "#{type}",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def response_build(request_lines)
    if force_error?(request_lines)
      force_error_response
    elsif path_start_game?(request_lines)
      start_response(request_lines)
    elsif !known_path(path(request_lines))
      status_404
    else
      check_verb(request_lines)
    end
  end

  def force_error_response
    "500 Internal Source Error, Stack: #{caller.join("/n")}"
  end

  def start_response(request_lines)
    if path_start_game?(request_lines)
      @start_counter += 1
      if start_counter <= 1
        "Good Luck!"
      else
        status_403
      end
    end
  end

  def game_post_request?(request_lines)
    if verb_post?(request_lines)
      if path(request_lines).include?("game")
        true
      end
    end
  end


  def status_codes(request_lines)
    if !known_path(path(request_lines))
      status_404
    elsif path_start_game?(request_lines) && !game_running?
      game.start_game
      status_302
    elsif path_start_game?(request_lines) && game_running?
      status_403
    elsif verb_post?(request_lines) && path_game?(request_lines)
      status_301
    elsif force_error?(request_lines)
      status_500
    end
  end

  def status_500
    "500 Internal Source Error"
  end

  def status_301
    "301 Moved Permanetly"
  end

  def status_403
    "403 Forbidden"
  end

  def status_302
    "302 Redirect"
  end

  def status_404
    "404 Not Found"
  end

  def path_start_game?(request_lines)
    path(request_lines).include?("start_game")
  end

  def game_running?
    game.game_running
  end

  def force_error?(request_lines)
    if path(request_lines).include?("/force_error")
      begin
      raise Exception
      rescue Exception
      end
    end
    path(request_lines).include?("/force_error")
  end

  def known_path(path)
    known_paths.any? {|known| path.include?(known)}
  end

  def known_paths
    ["/\n", "/hello\n", "/game", "/datetime\n", "/shutdown\n", "/word_search",
     "/start_game", "/force_error"]
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

  def path_game?(request_lines)
    path(request_lines).include?("/game")
  end

  def check_verb(request_lines)
    if verb_get?(request_lines)
      choose_path(request_lines)
  elsif verb_post?(request_lines)
      post_paths(request_lines)
    else "Check your verb, please"
    end
  end

  def verb_post?(request_lines)
    diagnostics.output_message_verb(request_lines) == "VERB: POST\n"
  end
  def verb_get?(request_lines)
    diagnostics.output_message_verb(request_lines) == "VERB: GET\n"
  end

  def post_paths(request_lines)
    if path_start_game?(request_lines)
      "Good Luck!"
    elsif path_game?(request_lines)
      guess = path(request_lines).split('=')[1].to_i
      game.set_guess(guess)
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
    elsif path_game?(request_lines)
      game_information
    else "I'm sorry, try again"
    end
  end

  def game_information
      "You have made #{game.guess_count} guesses \n #{game.hint}"
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
