#Client
require_relative'../../lib/library'

host = ARGV[2]||"127.0.0.1"
port = ARGV[1]||"1234"
filename = ARGV[0]||"cat.jpg"

sent = 0

puts "Source file: " + filename
client = TCP.createClient(host, port)
File.open (filename) do |file|
  while chunk = file.read(CONST::SIZE)
    client.send(chunk, 0)
    sleep(0.2)
    sent += chunk.size
    puts sent
  end
  client.close
  file.close
end
trap("SIGINT") do
  client.close
  file.close
  exit!
end
 


