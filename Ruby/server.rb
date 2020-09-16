require 'socket'

# define port and address
address = 'localhost'
port = 8000
SERVER_ROOT = Dir.pwd

# start server
server = TCPServer.new(
    address,
    port
)

# print out server address and port
puts "Starting server on #{ address }:#{ port }"


def parseRequest( request )
=begin 
retrieve first line of request, parse into 
method (GET, POST, ETC...), path (file path 
to search for), version (HTTP version, 1.1 or 2)
=end
    method, path, version = request.lines[0].split
    # print components to console
    puts method, path, version
    # return components from function
    {
        method: method,
        path: path,
        version: version
    }
end

def parseHeaders(request)
=begin
parse and structure headers,
store them in a dictionary
=end
    headers = {}
    request.lines[1..-1].each do |line|
      return headers if line == "\r\n"
      header, value = line.split
      header = normalize( header )
      headers[header] = value
    end
  end

def normalize( header )
=begin
globally substitute ':' with empty string,
convert to all lowercase, and return the
symbol ( creating it if it did not prev 
exist )

So, host -> :host
    user-agent -> :"user-agent"
=end
    header.gsub(":", "").downcase.to_sym
  end

# run code between {} until ctrl+c
loop {
    client = server.accept
    # read max of 2048 bytes from client
    request = client.readpartial(2048)
    # put response to parseRequest()
    puts parseRequest( request )
    # put response to parseHeaders()
    puts parseHeaders( request )
}