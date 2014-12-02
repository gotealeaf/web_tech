require 'socket'
require 'logger'
require './surfing_app'

class TinyWebServer
  def initialize(host, port)
    @host = host
    @port = port
    @logger = Logger.new(STDOUT)
  end

  def run(app)
    server = TCPServer.open(@host, @port)
    @logger.info("HTTP Server ready to accept requests!")
    loop do
      connection = server.accept
      @logger.info "Opening a connection for request:"
      message_line = connection.gets
      @logger.info message_line
      env = parse_http_header(message_line)
      begin
        message_line = connection.gets
      end until message_line.chomp == ""
      response = app.call(env)
      @logger.info "Sending response..."
      connection.puts "HTTP/1.1 #{response[0]} #{response_status(response[0])}"
      connection.puts "Date: #{Time.now.ctime}"
      connection.puts "Content-Type: #{response[1]['Content-Type']}"
      connection.puts "Server: Tiny Web Server"
      connection.puts
      connection.puts response[2][0]
      connection.close
      @logger.info "Response sent and connection closed."
    end
  end

  def parse_http_header(header_string)
    method, path, protocol = header_string.split(' ')
    {method: method, path: path, protocol: protocol}
  end

  def response_status(response_code)
    case response_code
    when 200
      "OK"
    when 404
      "NOT FOUND"
    end
  end
end

TinyWebServer.new('localhost', 2000).run(Surfing.new)
