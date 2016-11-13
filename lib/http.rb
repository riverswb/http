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

  def check_verb(request_lines)
    # binding.pry
    if diagnostics.output_message_verb(request_lines) == "VERB: GET\n"
      choose_path(request_lines)
    elsif diagnostics.output_message_verb(request_lines) == "VERB: POST\n"
      post_paths(request_lines)
    else "Check your verb, please"
    end
  end

  def post_paths(request_lines)
    if path(request_lines) == "Path: /start_game\n"
      path_game
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
    else "I'm sorry, try again"
    end
  end

  def path_game
    @game = Game.new
    "Good Luck!"
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
