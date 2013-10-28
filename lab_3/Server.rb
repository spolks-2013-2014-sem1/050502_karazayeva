#Server for lab_2

require'./library'
require'timeout'

SIZE = 64

begin
  host = "127.0.0.1"
  port = "1234"
  p_sock, a_sock = Library.createServer(host, port, Socket::SOCK_STREAM)
  file = File.open("./lab_3/out_file", 'w') 
  begin
    loop do
      timeout(100) do
        a_sock, a_sock_info = p_sock.accept
      end
      puts ("Please, wait...")
      while  data = a_sock.read(SIZE)
          file.write(data)
        end
      file.close  
      a_sock.close
      p_sock.close
      puts("Transfer complete")
      break
    end
  end
trap("SIGINT") do
  exit!
end
rescue Timeout::Error
  puts "No one wants to connect:("
rescue Interrupt
  a_sock.close if a_sock 
  p_sock.close
end