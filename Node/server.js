const net = require('net');
const fs = require('fs');

const server = net.createServer((socket) => {
    // socket is used to communicate info between server and client. Server 
    // waits for the client to send info to the socket, and the server will
    // read information from the socket once this occurs.
    socket.on("data", buffer => {
        const requestData = buffer.toString('utf-8')
        const requestParsed = parseRequest(requestData)
        
        if (requestParsed.method == "GET"){
            if (fs.existsSync(`.${requestParsed.path}`)){
                const fileContents = fs.readFileSync(`.${requestParsed.path}`, (err, contents) => {
                    console.log(contents);
                })
                socket.write("HTTP/1.0 200 OK\n")            
                socket.write(fileContents)
            }
            else {
                socket.write("404 File Not Found.")
            }
        }

    })
})

const parseRequest = (requestData) => {
    [method, path, protocol] = requestData.split(" "); // split request into three components:
    return {
        method, // GET, POST, etc...
        path, // "/", "/home", etc...
        protocol // HTTP/1.1 or HTTP/2
    }
}

const port = 8080
server.listen(port, () => console.log(`listening on ${ port }`))