#Server 
require_relative'../../lib/library'
require'timeout'

host = ARGV[0]||"127.0.0.1"
port = ARGV[1]||"1234"
clients = {}

begin
  server = TCP.createServer(host, port)
  client  = TCP.createSocket

  loop do 
     timeout(20) do
       client, = server.accept
       puts client
     end
 
     fork do
       clients[Process.pid] = client
       receive_size = 0
          
       file =  File.open("#{client}", 'w')

     while data = clients[Process.pid].recv(CONST::SIZE)
       receive_size += data.size
       puts " :#{Process.pid} #{receive_size}"
       file.write(data)
       if data.size < CONST::SIZE
         puts "#{clients[Process.pid]} done"
         file.close
         break
       end
     end
   end
   puts "New client"
 end
 
rescue Timeout::Error
  puts "No one wants to connect:("
end

trap("SIGINT") do
  server.close if server
  exit!
end
