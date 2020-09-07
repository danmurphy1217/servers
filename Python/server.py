from http.server import HTTPServer, BaseHTTPRequestHandler
import time
import json 
import cgi
import cgitb
import os

path = os.path.dirname(__file__)
log_path = os.path.join(path, "Logs/")
# creates detailed reports of errors
cgitb.enable(display=0, logdir= log_path)

HOST, PORT = 'localhost', 8080

class Server(BaseHTTPRequestHandler):

    def _set_headers(self):
        """Create headers for requests."""
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Language', 'en')
        self.end_headers()
    
    def do_HEAD(self):
        """Set headers for requests."""
        self._set_headers()

    def do_GET(self):
        """Handle GET request."""
        self._set_headers()
        # opt + shift + down_arrow to copy highlighted line
        print(self.headers)
        self.wfile.write(json.dumps({"status":"200 OK", "message":f"{self.path}"}, indent=2).encode('utf-8'))
    
    def do_POST(self):
        """Handle POST request."""
        self._set_headers()
        print(self.headers)




    

if __name__ == "__main__":
    server = HTTPServer((HOST, PORT), Server)
    print(f"Server Started at http://{HOST}:{PORT}")
    try :
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    
    server.server_close()
    print("Server stopped.")
        