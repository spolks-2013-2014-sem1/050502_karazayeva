#Server 
require_relative'../../lib/library'
require'timeout'

host = ARGV[0]||"127.0.0.1"
port = ARGV[1]||"1234"
clients = {}
mutex = Mutex.new

begin
  server = TCP.createServer(host, port)
  client  = TCP.createSocket

    loop do 
       timeout(20) do
         client, = server.accept
         puts client
       end
 
       Thread.new do
         clients[Thread.current] = client
         receive_size = 0
         begin
          
           file =  File.open("#{client}", 'w')

           while data = clients[Thread.current].recv(CONST::SIZE)
             if data.size < CONST::SIZE
               puts "#{clients[Thread.current]} done"
               file.close
               break
             end
             receive_size += data.size
             puts " :#{Thread.current} #{receive_size}"
             file.write(data)
         end
     ensure
       mutex.synchronize do
         threads.delete(Thread.current)
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
