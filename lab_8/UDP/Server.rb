#Server 
require_relative'../../lib/library'
require'timeout'

host = ARGV[0]||"127.0.0.1"
port = ARGV[1]||"1234"

begin
  server = UDP.createServer(host, port)
  
  receive_size = 0
  client, data = nil
  clients = {}
  processes = {}

  loop do  
      timeout(20) do
        data, client = server.recvfrom(CONST::SIZE)
      end
      
      server.send('1', 0, client)
      client_ip = client.ip_unpack[1]
      unless processes[client_ip] 
        
        clients[client_ip] = [0, data]
        processes[client_ip] = fork do
          file = File.open("#{client_ip}_#{clients[client_ip][1]}", 'w')
          file.close
        end
      else
        processes[client_ip]= fork do 
        clients[client_ip][0] += data.size
        file = File.open("#{client_ip}_#{clients[client_ip][1]}", 'a+') 
        file.write(data)
        puts "#{processes[client_ip]} : #{clients[client_ip]}"
        file.close
      end
    end      
  end 
  server.close
  puts("Transfer complete")
 
rescue Timeout::Error
  puts "No one wants to connect:("
end

trap("SIGINT") do
  server.close if server
  exit!
end
