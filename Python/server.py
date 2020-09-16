from http.server import HTTPServer, BaseHTTPRequestHandler
import time, datetime, json, cgi, cgitb, os

full_path = os.path.dirname(__file__)
log_path = os.path.join( full_path, "Logs/" )
# creates detailed reports of errors
cgitb.enable( display = 0, logdir = log_path )

HOST, PORT = 'localhost', 8000 

class Server( BaseHTTPRequestHandler ):

    def _set_headers(self):
        """Create headers for requests."""
        self.send_response( 200 )
        self.send_header( 'Content-Type', 'application/json' )
        self.send_header( 'Content-Language', 'en' )
        self.end_headers()
    
    def do_HEAD( self ):
        """Set headers for requests."""
        self._set_headers()

    def do_GET( self ):
        """Handle GET request."""
        self._set_headers()
        
        request_path = full_path + self.path 
        if os.path.exists( request_path ):
            with open( request_path, "r" ) as f:
                print( f.read() )
                f.close()
        else:
            print( full_path + self.path )
            print( "Path: " + request_path )
        # opt + shift + down_arrow to copy highlighted line
        print( self.headers )
        self.wfile.write( json.dumps( { "status" : "200 OK", "message" : f"{ self.path }" }, indent=2 ).encode( 'utf-8' ) )
    
    def do_POST( self ):
        """Handle POST request.""" 
        self._set_headers()
        content_type = self.headers.get('content-type')
        content_length = int(self.headers.get('content-length'))

        if content_type == "application/json" or "application/x-www-form-urlencoded":
            message = json.loads( self.rfile.read( content_length ) )
            time = datetime.datetime.now().strftime("%-H:%M:%S")
            self.wfile.write( json.dumps( { "status" : "200 OK", "message" : f"{ message }", "time" : f"{ time }"}, indent=2 ).encode( 'utf-8' ) )

        else:
            self.send_response(400)
            self.end_headers()
            return

def pretty_print( message ):
    """Pretty print server messages to STDIN."""
    dashes = '-' * len( message )
    return f"\n{ dashes }\n{ message }\n{ dashes }" 


if __name__ == "__main__":
    server = HTTPServer( ( HOST, PORT ), Server )

    print( f"Server Started at http://{HOST}:{PORT}" )
    try :
        server.serve_forever()
    except KeyboardInterrupt:
        print( pretty_print( "| Shutting Down Server |" ) )
        pass
    
    server.server_close()
    print( pretty_print( "| Server stopped. |" ) )