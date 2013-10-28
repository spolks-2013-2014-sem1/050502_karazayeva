#Library
require 'socket'

module Library
  
  def self.createServer (host, port, type)
    a_sock = Socket.new( Socket::AF_INET,  type, 0)       #active socket
    p_sock = Socket.new( Socket::PF_INET,  type, 0)       #passive socket
    p_sock.setsockopt(:SOCKET, :REUSEADDR, true)          #no more Errno::EADDRINUSE
    p_sockaddr = Socket.pack_sockaddr_in(port, host) 
    p_sock.bind (p_sockaddr)
    p_sock.listen(2)
    puts'Ctrl+C for exit'
    [p_sock, a_sock]
  end

  def self.createClient (host, port, type)
    client = Socket.new( Socket::AF_INET, type, 0)
    sock_addr = Socket.pack_sockaddr_in(1234, '127.0.0.1')
    client.connect(sock_addr)
    client
  end
end


  
  