#Server UDP
require_relative'../lib/library'

host = ARGV[0]||"127.0.0.1"
port = ARGV[1]||"1234"

begin
  server = UDP.createServer(host, port)
  
  filename = server.recv(CONST::FILE_NAME)
  file = File.open("./#{filename}(copy)", 'w') 
  file_size = server.recv(CONST::FILE_SIZE).to_i
  receive_size = 0

  loop do  
    data, client = server.recvfrom(CONST::SIZE)
    server.send('1', 0, client)
    receive_size += data.size
    file.write(data)  
    break if receive_size == file_size
  end 
  file.close  
  server.close
  puts("Transfer complete")
end
 
trap("SIGINT") do
  server.close 
  exit!
end
