#Server 
require'./lib/library'
require'timeout'

host = ARGV[0]||"127.0.0.1"
port = ARGV[1]||"1234"

begin
  p_sock = TCP.createServer(host, port)
  a_sock = TCP.createSocket
  timeout(60) do
    a_sock, a_sock_info = p_sock.accept
  end
  puts ("Please, wait...")
  filename = a_sock.gets.chomp
  file = File.open("./#{filename}(copy)", 'w') 
  while  data = a_sock.read(CONST::SIZE)
    file.write(data)
  end
  file.close  
  a_sock.close
  p_sock.close
  puts("Transfer complete")

rescue Timeout::Error
  puts "No one wants to connect:("
end

trap("SIGINT") do
  exit!
end
