#Server
require './lib/library'
require 'timeout'

begin
  host = ARGV[0]||"127.0.0.1"
  port = ARGV[1]||"1234"
  p_sock, a_sock = Library.createServer(host, port, Socket::SOCK_STREAM)
  begin
    while p_sock
      timeout(60) do
        a_sock, a_sock_info = p_sock.accept
      end
      while  data = a_sock.gets.chomp
        break a_sock.close if (data == "quit")
        break p_sock.close if (data == "exit")
        puts "  Client said: '#{data}'" 
      end
    end
  end
  trap("SIGINT") do
    exit!
  end
  a_sock.close if a_sock
  p_sock.close if p_sock
rescue Timeout::Error
  puts "No one wants to connect:("
rescue SocketError
  puts "run application with options: filename.rb [host] [port]"
rescue Interrupt, IOError
  a_sock.close
  p_sock.close
end
 
     

