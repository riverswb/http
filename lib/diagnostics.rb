class Diagnostics

  def output_message_verb(input)
    "VERB: #{input[0].split("/")[0].rstrip}\n"
  end #=> Verb: GET

  def output_message_path(input)
    "Path: #{input[0].split(" ")[1]}\n"
  end #=> Path: /

  def output_message_protocol(input)
    "Protocol: #{input[0].split(" ")[-1]}\n"
  end #=> Protocol: HTTP/1.1

  def output_message_host(input)
    "Host: #{input[1].split(":")[1].lstrip}\n"
  end #=> Host: 127.0.0.1

  def output_message_port(input)
    "Port: #{input[1].split(":")[-1]}\n"
  end #=> Port: 9292

  def output_message_origin(input)
    "Origin: #{input[1].split(":")[1].lstrip}\n"
  end #=> Origin: 127.0.0.1

  def output_message_accept(input)
    "#{input[6]}\n"
  end #=> Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8

end
