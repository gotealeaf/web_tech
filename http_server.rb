require 'socket'

server = TCPServer.open('localhost', 2000)
puts "HTTP Server ready to accept requests!"

loop do
  connection = server.accept
  puts "Opening a connection for request:"
  while message_line = connection.gets
    puts message_line
    break if message_line.chomp == ""
  end
  puts "Sending response.."
  connection.puts "HTTP/1.1 200 OK"
  connection.puts "Date: #{Time.now.ctime}"
  connection.puts "Content-Type: text/html"
  connection.puts "Server: My Http Server"
  connection.puts
  connection.puts "Hi there, greetings from the server!"
  connection.close
  puts "Response sent and connection closed."
end
