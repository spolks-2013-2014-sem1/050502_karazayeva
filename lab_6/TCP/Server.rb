#Server 
require_relative'../../library'
require'timeout'

host = ARGV[0]||"127.0.0.1"
port = ARGV[1]||"1234"

clients = {}
readers = []
  
begin
  p_sock  = TCP.createServer(host, port)
  a_sock  = TCP.createSocket
  
  loop do    
    timeout(20) do
      a_sock, a_sock_info = p_sock.accept
      readers << a_sock
    end
    
    read,_,_ = IO.select(readers, nil, nil)
      
    read.each do |sock|
      puts "read"
      sleep(1)
      
      received_data = 0
      clients[sock] = File.open("#{sock}", 'w')
      while data = sock.recv(CONST::SIZE)
        clients[sock].write(data)
        received_data += data.size
        break if data.empty?
        puts "#{ clients[sock]}:#{received_data}"
      end
      
      sock.close
      clients[sock].close
      readers.delete(sock)
    end
  end

rescue Timeout::Error
  p_sock.close
  puts("Transfer complete") 
end

trap("SIGINT") do
  p_sock.close 
  exit!
end