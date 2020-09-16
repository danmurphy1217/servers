# Overview of how to use this Python Server

There are two components to using this server:
1. the server itself
2. the requests made to the server

To use `(1)`, you must clone this repository and install the necessary dependencies (See `requirements.txt`). To run the server, follow these steps:
1. `cd ~/{Desktop}/servers/Python`
2. `python3 server.py`

Then, to use `(2)`, first you must make sure curl is installed on your system. It should already be installed on Unix and Linux systems. To test **GET** requests, use the following command:

`$ curl -X GET http://localhost:8000/<enter a message here>`
`response`: 
    {
      "status": "200 OK",
      "message": "`<your message will appear here>`"
    }

# Example
`$ curl -X GET http://localhost:8000/?message=hi`
`response`: 
    {
      "status": "200 OK",
      "message": "`/?message=hi`"
    }

To test **POST** requests, use the following:
`$ curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:8000/\?message\=hello+this+is+dan -d '{"hello":"world"}'`
`response`:
    {
      "status": "200 OK",
      "message": "{'hello': 'world'}",
      "time": "21:01:52"
    }

# Extensions
This server can be modified further to handle specific requests in specific ways. For example, we can allow and disallow certain requests for resources based on headers and where the request originates from. We can also build a more robust `POST` request handler.****

# Updates
This server can now take relative file paths, search for them, and, if they exist, return their contents.
This functionality largely relies on `os.path.exists()`