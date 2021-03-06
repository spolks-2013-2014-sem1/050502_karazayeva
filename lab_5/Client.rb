#Client UDP
require_relative'../lib/library'
require'timeout'

host = ARGV[0]||"127.0.0.1"
port = ARGV[1]||"1234"
filename = ARGV[2]||"cat.jpg"

puts "Source file: " + filename
client = UDP.createClient(host, port)

ok_to_read_ask = false
sent = 0

File.open (filename) do |file|
  client.send(filename, 0)
  client.send(file.size.to_s,0)
  loop do  
    readers, writers = ok_to_read_ask ? [[client],[]] : [[],[client]] 
    has_urgent, has_regular, = IO.select(readers,writers,nil )
   
    if sock = has_urgent.pop
      timeout(5) do
        while  data = sock.recv(1)
          break if data == '1'
        end
      end
      ok_to_read_ask = false
    end
    
    if  sock = has_regular.pop
      chunk = file.read(CONST::SIZE)
      sock.send(chunk, 0)
      break if chunk.length < CONST::SIZE
      ok_to_read_ask = true
    end
  end
  client.close 
end

trap("SIGINT") do
  client.close
  exit!
end


 


