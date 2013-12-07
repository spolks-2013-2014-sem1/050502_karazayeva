#Server 
require'./lib/library'
require'timeout'

host = ARGV[0]||"127.0.0.1"
port = ARGV[1]||"1234"
  
begin
  p_sock  = TCP.createServer(host, port)
  a_sock  = TCP.createSocket
  timeout(60) do
    a_sock, a_sock_info = p_sock.accept
  end
  
  puts ("Please, wait...")
  filename = a_sock.recv(CONST::FILE_NAME) 
  file = File.open("./#{filename}(copy)", 'w') 
  
  ok_to_read_oob = false
  received_data = 0
  
  loop do   
    except_arr = ok_to_read_oob ?  [a_sock]  : []
    has_regular, _, has_urgent = IO.select([a_sock], nil, except_arr)
   
    if sock = has_urgent.pop
      data = sock.recv(1, Socket::MSG_OOB)
      puts "received:#{received_data} bytes"
      ok_to_read_oob = false
    else
      sock = has_regular.pop
      data = sock.recv(CONST::SIZE)
      break if data.empty?
      file.write(data)
      received_data += data.size
      ok_to_read_oob = true
    end
  end
  file.close  
  a_sock.close
  p_sock.close
  puts("Transfer complete")  

rescue Timeout::Error
  puts "No one wants to connect:(" 
end

trap("SIGINT") do
  a_sock.close if a_sock 
  p_sock.close if p_sock
  exit!
end
