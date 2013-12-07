#Library
require 'socket'

module CONST
  SIZE = 1024
  FILE_NAME = 100
  FILE_SIZE = 100
end

module TCP
  def self.createServer (host, port) 
    server = createSocket 
    server = Socket.new( Socket::PF_INET, Socket::SOCK_STREAM, 0)       
    server.setsockopt(:SOCKET, :REUSEADDR, true)             
    sock_addr = Socket.pack_sockaddr_in(port, host) 
    server.bind (sock_addr)
    server.listen(5)
    server
  end

  def self.createClient (host, port)
    client = createSocket        
    sock_addr = Socket.pack_sockaddr_in(port, host)
    client.connect(sock_addr)
    client
  end
  
  def self.createSocket
    socket = Socket.new( Socket::AF_INET, Socket::SOCK_STREAM, 0)
    socket.setsockopt(:SOCKET, :REUSEADDR, true) 
    socket
  end
end

module UDP
  def self.createServer (host, port)
    server = self.createSocket
    sock_addr = Socket.pack_sockaddr_in(port, host) 
    server.bind (sock_addr)
    server
  end

  def self.createClient (host, port)
    client = self.createSocket    
    sock_addr = Socket.pack_sockaddr_in(port, host)
    client.connect(sock_addr)
    client
  end
  
  def self.createSocket
    socket = Socket.new( Socket::AF_INET, Socket::SOCK_DGRAM, 0)
    socket.setsockopt(:SOCKET, :REUSEADDR, true) 
    socket
  end
end


  
  
