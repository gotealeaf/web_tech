require 'socket'

server = TCPServer.open('localhost', 2000)
puts "HTTP Server ready to accept requests!"

loop do
  connection = server.accept
  puts "Opening a connection for request:"
  message_line = connection.gets
  path = message_line.split(' ')[1]
  while message_line = connection.gets
    puts message_line
    break if message_line.chomp == ""
  end
  suffix = path.slice(/\.(.*)/)
  content_type = case suffix
                 when ".html" then 'text/html'
                 when ".css" then 'text/css'
                 when '.jpg' then 'image/jpeg'
                 end
  puts "Sending response.."
  connection.puts "HTTP/1.1 200 OK"
  connection.puts "Date: #{Time.now.ctime}"
  connection.puts "Content-Type: #{content_type}"
  connection.puts "Server: My Http Server"
  connection.puts
  connection.puts File.read("documents#{path}")
  connection.close
  puts "Response sent and connection closed."
end
