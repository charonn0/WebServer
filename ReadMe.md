WebServer for Realbasic/REALstudio/Xojo   
Copyright (c)2013 Andrew Lambert   
http://www.boredomsoft.org/WebServer.bs   

This project implements a complete HTTP server. Primary HTTP-related logic is located in the [HTTP.BaseServer](https://github.com/charonn0/WebServer/blob/master/HTTP/BaseServer.rbbas) 
class, which is a subclass of the built-in [ServerSocket](http://docs.realsoftware.com/index.php/ServerSocket) class. 

HTTP.BaseServer
===============
The BaseServer provides the following features:

* User sessions
* GZip compression (requires the free GZip plugin)
* SSL/TLS connections and certificates.
* Basic HTTP authentication
* Global, server, and sesion-specific URL redirects
* Session-specific page caches
* HTTP cookies
	
The BaseServer handles all reads from and writes to client sockets. When a client makes a request, the BaseServer will receive and parse 
the request into an [HTTP.Request](https://github.com/charonn0/WebServer/blob/master/HTTP/Request.rbbas) object, which contains all data about the request.
This object is raised to subclasses of BaseServer in the HandleRequest event:

	Event HandleRequest(ClientRequest As HTTP.Request) As HTTP.Response

Subclasses should return an [HTTP.Response](https://github.com/charonn0/WebServer/blob/master/HTTP/Response.rbbas) object from the HandleRequest event. If
the return value is Nil, then BaseServer sends a default **404 Not Found** response.

The HTTP.Response and HTTP.Request objects are both subclassed from the [HTTPParse.HTTMessage](https://github.com/charonn0/WebServer/blob/master/HTTPParse/HTTPMessage.rbbas) class.


HTTP.FileServer
===============
The [FileServer](https://github.com/charonn0/WebServer/blob/master/HTTP/FileServer.rbbas) subclasses BaseServer and implements a general-purpose
HTTP file server. Directory index pages are automtically generated but can be turned on and off at runtime. The FileServer class is intended both
as a basis for more sophisticated file-oriented servers based on BaseServer and as a demonstration of how to use BaseServer directly. 