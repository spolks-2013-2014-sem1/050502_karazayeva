#Server
require './lib/library'
require 'timeout'

begin
  host = ARGV[0]||"127.0.0.1"
  port = ARGV[1]||"1234"
  p_sock = TCP.createServer(host, port)
  
    while p_sock
      a_sock = TCP.createSocket
      timeout(60) do
        a_sock, a_sock_info = p_sock.accept
      end
      puts "Print 'dump' to close client" 
      puts "Print 'exit' or push Ctrl+C to close server"
      while  data = a_sock.gets.chomp
        break a_sock.close  if data == "dump"
        break p_sock.close  if data == "exit"
        puts "  Client said: '#{data}'" 
      end
    end
  
  trap("SIGINT") do
    a_sock.close if a_sock
    p_sock.close if p_sock
    exit!
  end
  
rescue Timeout::Error
  puts "No one wants to connect:("
rescue Interrupt, IOError
end
 
     

