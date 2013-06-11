#tag Module
Protected Module HTTP
	#tag Method, Flags = &h1
		Protected Function CodeToMessage(Code As Integer) As String
		  Select Case Code
		  Case 100
		    Return "Continue"
		    
		  Case 101
		    Return "Switching Protocols"
		    
		  Case 102
		    Return "Processing"
		    
		  Case 200
		    Return "OK"
		    
		  Case 201
		    Return "Created"
		    
		  Case 202
		    Return "Accepted"
		    
		  Case 203
		    Return "Non-Authoritative Information"
		    
		  Case 204
		    Return "No Content"
		    
		  Case 205
		    Return "Reset Content"
		    
		  Case 206
		    Return "Partial Content"
		    
		  Case 207
		    Return "Multi-Status"
		    
		  Case 208
		    Return "Already Reported"
		    
		    
		  Case 226
		    Return "IM Used"
		    
		  Case 300
		    Return "Multiple Choices"
		    
		  Case 301
		    Return "Moved Permanently"
		    
		  Case 302
		    Return "Found"
		    
		  Case 303
		    Return "See Other"
		    
		  Case 304
		    Return "Not Modified"
		    
		  Case 305
		    Return "Use Proxy"
		    
		  Case 306
		    Return "Switch Proxy"
		    
		  Case 307
		    Return "Temporary Redirect"
		    
		  Case 308 ' https://tools.ietf.org/html/draft-reschke-http-status-308-07
		    Return "Permanent Redirect"
		    
		  Case 400
		    Return "Bad Request"
		    
		  Case 401
		    Return "Unauthorized"
		    
		  Case 403
		    Return "Forbidden"
		    
		  Case 404
		    Return "Not Found"
		    
		  Case 405
		    Return "Method Not Allowed"
		    
		  Case 406
		    Return "Not Acceptable"
		    
		  Case 407
		    Return "Proxy Authentication Required"
		    
		  Case 408
		    Return "Request Timeout"
		    
		  Case 409
		    Return "Conflict"
		    
		  Case 410
		    Return "Gone"
		    
		  Case 411
		    Return "Length Required"
		    
		  Case 412
		    Return "Precondition Failed"
		    
		  Case 413
		    Return "Request Entity Too Large"
		    
		  Case 414
		    Return "Request-URI Too Long"
		    
		  Case 415
		    Return "Unsupported Media Type"
		    
		  Case 416
		    Return "Requested Range Not Satisfiable"
		    
		  Case 417
		    Return "Expectation Failed"
		    
		  Case 418
		    Return "I'm a teapot" ' https://tools.ietf.org/html/rfc2324
		    
		  Case 420
		    Return "Enhance Your Calm" 'Nonstandard, from Twitter API
		    
		  Case 422
		    Return "Unprocessable Entity"
		    
		  Case 423
		    Return "Locked"
		    
		  Case 424
		    Return "Failed Dependency"
		    
		  Case 425
		    Return "Unordered Collection" 'Draft, https://tools.ietf.org/html/rfc3648
		    
		  Case 426
		    Return "Upgrade Required"
		    
		  Case 428
		    Return "Precondition Required"
		    
		  Case 429
		    Return "Too Many Requests"
		    
		  Case 431
		    Return "Request Header Fields Too Large"
		    
		  Case 444
		    Return "No Response" 'Nginx
		    
		  Case 449
		    Return "Retry With" 'Nonstandard, from Microsoft http://msdn.microsoft.com/en-us/library/dd891478.aspx
		    
		  Case 450
		    Return "Blocked By Windows Parental Controls" 'Nonstandard, from Microsoft
		    
		  Case 451
		    Return "Unavailable For Legal Reasons" 'Draft, https://tools.ietf.org/html/draft-tbray-http-legally-restricted-status-00
		    
		  Case 494
		    Return "Request Header Too Large" 'nginx
		    
		  Case 495
		    Return "Cert Error" 'nginx
		    
		  Case 496
		    Return "No Cert" 'nginx
		    
		  Case 497
		    Return "HTTP to HTTPS" 'nginx
		    
		  Case 499
		    Return "Client Closed Request" 'nginx
		    
		  Case 500
		    Return "Internal Server Error"
		    
		  Case 501
		    Return "Not Implemented"
		    
		  Case 502
		    Return "Bad Gateway"
		    
		  Case 503
		    Return "Service Unavailable"
		    
		  Case 504
		    Return "Gateway Timeout"
		    
		  Case 505
		    Return "HTTP Version Not Supported"
		    
		  Case 506
		    Return "Variant Also Negotiates" 'WEBDAV https://tools.ietf.org/html/rfc2295
		    
		  Case 507
		    Return "Insufficient Storage" 'WEBDAV https://tools.ietf.org/html/rfc4918
		    
		  Case 508
		    Return "Loop Detected" 'WEBDAV https://tools.ietf.org/html/rfc5842
		    
		  Case 509
		    Return "Bandwidth Limit Exceeded" 'Apache, others
		    
		  Case 510
		    Return "Not Extended"  'https://tools.ietf.org/html/rfc2774
		    
		  Case 511
		    Return "Network Authentication Required" 'https://tools.ietf.org/html/rfc6585
		    
		  Else
		    Return "Unknown Status Code"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function HeaderComment(HeaderName As String, HeaderValue As String) As String
		  Select Case HeaderName
		  Case "Date"
		    Dim d As Date = HTTPDate(HeaderValue)
		    Dim e As New Date
		    d.GMTOffset = e.GMTOffset
		    Return d.ShortDate + " " + d.ShortTime + "(Local time)"
		    
		  Case "Content-Length"
		    Return FormatBytes(Val(HeaderValue))
		    
		  Case "Location"
		    Return "Redirect address"
		    
		  Case "Authorization", "WWW-Authenticate"
		    Return "HTTP Authentication"
		    
		  Case "Connection"
		    If HeaderValue = "close" Then
		      Return "Connection will close"
		    ElseIf HeaderValue = "keep-alive" Then
		      Return "Connection will be maintained"
		    End If
		    
		  Case "Content-Encoding", "Accept-Encoding", "Transfer-Encoding"
		    Return "Message body encoding"
		    
		  Case "Host"
		    Return "Domain the request is directed at"
		    
		  Case "Range"
		    Return "Partial download requested"
		    
		  Case "Accept-Ranges"
		    Return "Partial download supported"
		    
		  Case "Referer"
		    Return "Referring URL"
		    
		  Case "User-Agent"
		    Return "Client-side program name"
		    
		  Case "Server"
		    Return "Server-side program name"
		    
		  Case "Via"
		    Return "Intermediary Web Proxy"
		    
		  Case "Warning"
		    Return "General warning about message body"
		    
		  Case "DNT"
		    Return "Do Not Track (i.e. cookies)"
		    
		  Case "X-Forwarded-For"
		    Return "Requestor's IP as seen by a proxy"
		    
		  Case "Allow"
		    Return "Server supported HTTP methods"
		    
		  Case "Content-Location"
		    Return "Alternate URL for this resource"
		    
		  Case "ETag"
		    Return "Opaque document version marker"
		    
		  Case "Expires"
		    Dim d As Date = HTTPDate(HeaderValue)
		    Dim e As New Date
		    d.GMTOffset = e.GMTOffset
		    Return d.ShortDate + " " + d.ShortTime + "(Local time)"
		    
		  Case "Last-Modified"
		    Dim d As Date = HTTPDate(HeaderValue)
		    Dim e As New Date
		    d.GMTOffset = e.GMTOffset
		    Return d.ShortDate + " " + d.ShortTime + "(Local time)"
		    
		  Case "Link"
		    Return "URL to a related document (e.g. RSS feed)"
		    
		  Case "P3P"
		    Return "P3P policy, often invalid"
		    
		  Case "Refresh"
		    Return "Redirect URL with optional delay"
		    
		  End Select
		  
		Exception
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Method(Method As String) As RequestMethod
		  Select Case Method
		  Case "GET"
		    Return HTTP.RequestMethod.GET
		  Case "HEAD"
		    Return HTTP.RequestMethod.HEAD
		  Case "DELETE"
		    Return HTTP.RequestMethod.DELETE
		  Case "POST"
		    Return HTTP.RequestMethod.POST
		  Case "PUT"
		    Return HTTP.RequestMethod.PUT
		  Case "TRACE"
		    Return HTTP.RequestMethod.TRACE
		  Case "OPTIONS"
		    Return RequestMethod.OPTIONS
		  Case "PATCH"
		    Return RequestMethod.PATCH
		  Case "CONNECT"
		    Return RequestMethod.CONNECT
		  Else
		    Return HTTP.RequestMethod.InvalidMethod
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ReplyString(Code As Integer) As String
		  'Returns the properly formatted HTTP response line for a given HTTP status code.
		  'e.g. HTTP.Response(404) = "HTTP/1.1 404 Not Found"
		  
		  Dim msg As String = HTTP.CodeToMessage(code)
		  Return "HTTP/1.1 " + Str(Code) + " " + msg
		End Function
	#tag EndMethod


	#tag Enum, Name = RequestMethod, Flags = &h0
		GET
		  HEAD
		  POST
		  PUT
		  DELETE
		  TRACE
		  OPTIONS
		  PATCH
		  CONNECT
		InvalidMethod
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
