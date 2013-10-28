#Client
require'./library'

SIZE = 64

filename = ARGV[0]||"./lab_3/cat.jpg"
puts "Source file: "+filename
client = Library.createClient('127.0.0.1', 1234, Socket::SOCK_STREAM)
File.open (filename) do |file|
  while chunk = file.read(SIZE)
    client.write(chunk)
  end
  client.close
end
trap("SIGINT") do
  client.close
  exit!
end
  
 


