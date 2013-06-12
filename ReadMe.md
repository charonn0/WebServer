WebServer for Realbasic/REALstudio/Xojo   
Copyright (c)2013 Andrew Lambert   
http://www.boredomsoft.org/WebServer.bs   

This project implements a complete HTTP server. Primary HTTP-related logic is located in the [HTTP.BaseServer](https://github.com/charonn0/WebServer/wiki/HTTP.BaseServer) 
class, which is a subclass of the built-in [ServerSocket](http://docs.realsoftware.com/index.php/ServerSocket) class. 

Some of the implemented features include:

* User sessions
* GZip compression (requires the free GZip plugin)
* SSL/TLS connections and certificates.
* Basic HTTP authentication
* Global, server, and session-specific URL redirects
* Session-specific page caches
* HTTP cookies
* Threaded I/O and network transactions
	


## Getting Started
### Core Wiki Pages
* [BaseServer](https://github.com/charonn0/WebServer/wiki/HTTP.BaseServer)
* [HTTP Requests](https://github.com/charonn0/WebServer/wiki/HTTP.Request)
* [HTTP Responses](https://github.com/charonn0/WebServer/wiki/HTTP.Response)

### Example Subclasses
* [File Server](https://github.com/charonn0/WebServer/wiki/Webserver.fileserver)
