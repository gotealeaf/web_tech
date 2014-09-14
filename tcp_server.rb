require 'socket'

server = TCPServer.open('localhost', 2000)
loop do
  connection = server.accept
  puts "Opening a conneciton upon request."
  connection.puts("It is now #{Time.now.ctime}")
  connection.puts "Bye!"
  connection.close
  puts "Closing conneciton."
end

