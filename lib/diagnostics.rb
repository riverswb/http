class Diagnostics

  def output_message_verb(input)
    "VERB: #{input[0].split("/")[0].rstrip}\n"
  end

  def output_message_path(input)
    "Path: #{input[0].split(" ")[1]}\n"
  end

  def output_message_protocol(input)
    "Protocol: #{input[0].split(" ")[-1]}\n"
  end

  def output_message_host(input)
    "Host: #{input[1].split(":")[1].lstrip}\n"
  end

  def output_message_port(input)
    "Port: #{input[1].split(":")[-1]}\n"
  end

  def output_message_origin(input)
    "Origin: #{input[1].split(":")[1].lstrip}\n"
  end

  def output_message_accept(input)
    "#{input[6]}\n"
  end

  def full_output_message(request_lines)
    "<pre>\n" +
    output_message_verb(request_lines) +
    output_message_path(request_lines) +
    output_message_protocol(request_lines) +
    output_message_host(request_lines) +
    output_message_port(request_lines) +
    output_message_origin(request_lines) +
    output_message_accept(request_lines) +
    "</pre>"
  end
end
