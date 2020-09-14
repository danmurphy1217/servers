# Overview of how to use this Node Server

There are two components to using this server:
1. the server itself
2. telnet, a useful command-line tool for interacting with servers

To use `(1)`, you must clone this repository and install the necessary dependencies (See `requirements.txt`). To run the server, follow these steps:
1. `cd ~/{Desktop}/servers/Python`
2. `python3 server.py`

Then, to use `(2)`, first make sure you have `telnet` properly running on your OS. It should come pre-installed on Unix and Linux systems (telnet is useful for connecting to a remote computer and running programs remotely). Then, following these steps:
1. open a terminal window
2. type `telnet localhost 8000`
3. test out **GET** and **POST** requests
