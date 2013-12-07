#Client
require_relative'../lib/library'

host = ARGV[0]||"127.0.0.1"
port = ARGV[1]||"1234"
filename = ARGV[2]||'./cat.jpg'

puts "Source file: " + filename

client = TCP.createClient(host, port)
File.open (filename) do |file|
  client.puts(filename)
  while chunk = file.read(CONST::SIZE)
    client.write(chunk)
  end
  client.close
end
trap("SIGINT") do
  client.close
  exit!
end
  
 


