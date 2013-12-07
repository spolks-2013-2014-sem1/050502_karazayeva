#Client
require_relative'../lib/library'

host = ARGV[0]||"127.0.0.1"
port = ARGV[1]||"1234"
filename = ARGV[2]||"cat.jpg"

puts "Source file: " + filename
client = TCP.createClient(host, port)
client.puts(filename, 0)
File.open (filename) do |file|
  while chunk = file.read(CONST::SIZE)
    client.send(chunk, 0)
    sleep(0.1)
    client.send('*', Socket::MSG_OOB)
  end
  client.close
end
trap("SIGINT") do
  client.close
  exit!
end

 


