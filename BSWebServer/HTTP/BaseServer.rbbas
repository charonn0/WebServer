#tag Class
Protected Class BaseServer
Inherits ServerSocket
	#tag Event
		Function AddSocket() As TCPSocket
		  Me.Log(CurrentMethodName, Log_Socket)
		  Dim sock As New SSLSocket
		  If Me.ConnectionType <> ConnectionTypes.Insecure Then
		    sock.CertificatePassword = Me.CertificatePassword
		    sock.CertificateFile = Me.CertificateFile
		    sock.Secure = True
		  End If
		  
		  Select Case Me.ConnectionType
		  Case ConnectionTypes.SSLv3
		    Sock.ConnectionType = SSLSocket.SSLv3
		  Case ConnectionTypes.TLSv1
		    Sock.ConnectionType = SSLSocket.TLSv1
		  Case ConnectionTypes.Insecure
		    sock.Secure = False
		  End Select
		  AddHandler sock.DataAvailable, WeakAddressOf Me.DataAvailable
		  AddHandler sock.Error, WeakAddressOf Me.ClientErrorHandler
		  AddHandler sock.SendComplete, WeakAddressOf Me.SendCompleteHandler
		  
		  If Me.Threading Then
		    Me.Log("Create idle worker thread", Log_Trace)
		    Dim worker As New Thread
		    AddHandler worker.Run, WeakAddressOf Me.ThreadRun
		    IdleThreads.Insert(0, worker)
		  End If
		  
		  Return sock
		End Function
	#tag EndEvent

	#tag Event
		Sub Error(ErrorCode as Integer)
		  Me.Log(CurrentMethodName, Log_Trace)
		  Dim err As String = FormatSocketError(ErrorCode)
		  
		  If ErrorCode <> 102 Then
		    Me.Log(err, Log_Error)
		  Else
		    Me.Log(err, Log_Socket)
		  End If
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddRedirect(Page As HTTP.Response)
		  ' This method adds the passed HTTP.Response ("Page") to the list of server-wide redirects.
		  ' Set the Path property of the Page to the path you want redirection from.
		  ' When a request is made against the redirected path, the server responds with the
		  ' Page object and does *not* pass the request on to the HandleRequest event.
		  ' See also: RemoveRedirect
		  
		  Me.Log(CurrentMethodName, Log_Trace)
		  Me.Log("Add redirect for " + page.Path.ServerPath, Log_Debug)
		  Redirects.Value(page.Path.ServerPath) = Page
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CheckAuth(ClientRequest As HTTP.Request) As HTTP.Response
		  ' If AuthenticationRequired is True, all HTTP requests must present their credentials
		  ' in the "WWW-Authenticate" header. This method raises the Authenticate event. If the
		  ' Authenticate event returns False (not authenticated) then an error (HTTP 401 Unauthorized)
		  ' is returned to client.
		  ' On success, or if AuthenticationRequired is False, then this method returns Nil
		  
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim doc As HTTP.Response
		  If AuthenticationRequired Then
		    Me.Log("Authenticating", Log_Trace)
		    If Not Authenticate(clientrequest) Then
		      Me.Log("Authentication failed", Log_Error)
		      doc = GetErrorResponse(401, clientrequest.Path.ServerPath)
		      doc.SetHeader("WWW-Authenticate") = "Basic realm=""" + AuthenticationRealm + """"
		    Else
		      Me.Log("Authentication Successful", Log_Debug)
		    End If
		  End If
		  Return doc
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CheckCache(ClientRequest As HTTP.Request, Session As HTTP.Session) As HTTP.Response
		  ' This method checks the session cache for cached responses. If a cached response
		  ' is found, then it is returned to the client. If no cached response is found, or
		  ' if the request explicitly overrides the cache then this function returns Nil.
		  
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim cache As HTTP.Response
		  If UseSessions Then
		    If clientrequest.CacheDirective <> "" Then
		      Select Case clientrequest.CacheDirective
		      Case "no-cache", "max-age=0"
		        Me.Log("Cache control override: " + clientrequest.CacheDirective, Log_Trace)
		        cache = Nil
		      End Select
		    Else
		      cache = GetCache(Session, clientRequest.Path.ToString)
		    End If
		    If cache <> Nil Then
		      cache.Compressible = False
		      Me.Log("Page from cache", Log_Debug)
		      Cache.Expires = New Date
		      Cache.Expires.TotalSeconds = Cache.Expires.TotalSeconds + 60
		      If clientrequest.IsModifiedSince(Cache.Expires) Then
		        If clientrequest.Method = RequestMethod.GET Or clientrequest.Method = RequestMethod.HEAD Then
		          Cache = GetErrorResponse(304, "")
		          Cache.MessageBody = ""
		        Else
		          Cache = GetErrorResponse(412, "") 'Precondition failed
		          Cache.MessageBody = ""
		        End If
		      End If
		    End If
		  End If
		  Return cache
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CheckProtocol(ClientRequest As HTTP.Request) As HTTP.Response
		  ' This method verifies that the request was made using a supported version
		  ' of the HTTP protocol. This server implementation supports HTTP 1.0 and 1.1
		  ' If the request specifies an unsupported protocol version, an HTTP 505 error
		  ' is returned to the client. If the specified version is supported, this function
		  ' returns Nil.
		  
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim doc As HTTP.Response
		  If clientrequest.ProtocolVersion < 1.0 Or clientrequest.ProtocolVersion >= 1.2 Then
		    doc = GetErrorResponse(505, Format(ClientRequest.ProtocolVersion, "#.0"))
		    Me.Log("Unsupported protocol version", Log_Error)
		  End If
		  
		  Return doc
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CheckRedirect(ClientRequest As HTTP.Request, Session As HTTP.Session) As HTTP.Response
		  ' This method checks the session and server-wide redirects for redirected responses.
		  ' If a redirected response is found, then it is returned to the client. If no redirected
		  ' response is found then this function returns Nil.
		  
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  While Not RedirectsLock.TrySignal
		    App.YieldToNextThread
		  Wend
		  Dim redir As HTTP.Response = GetRedirect(Session, clientrequest.Path.ServerPath)
		  RedirectsLock.Release
		  If redir <> Nil Then Me.Log("Using redirect.", Log_Trace)
		  Return redir
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckType(ClientRequest As HTTP.Request, ByRef doc As HTTP.Response)
		  ' This method verifies that the response is proper for a given response.
		  ' On success this method returns Nil. On error, it returns an error page document.
		  
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim tcount As Integer
		  #If GZIPAvailable Then
		    ' If the GZip plugin is used, we must confirm that the client has requested
		    ' gzip-encoded responses. Compression only takes place if the client asks for it.
		    Dim types() As String = Split(ClientRequest.GetHeader("Accept-Encoding"), ",")
		    doc.Compressible = False
		    tcount = UBound(types)
		    For i As Integer = 0 To tcount
		      If types(i).Trim = "gzip" Then
		        doc.Compressible = True
		        Exit For
		      End If
		    Next
		  #endif
		  
		  ' If the request uses HTTP 1.1 or newer and EnforceContentType is True
		  ' the server will check the request for an "Accept" header, and then confirm
		  ' that the requested document's actual MIMEType is acceptable. If the
		  ' response is not acceptable, an error (HTTP 406 Nat Acceptable) is returned to
		  ' client.
		  If EnforceContentType And ClientRequest.ProtocolVersion > 1.0 And doc.StatusCode < 300 And doc.StatusCode >= 200 Then
		    Me.Log("Checking Accepts", Log_Trace)
		    tcount = UBound(clientrequest.Headers.AcceptableTypes)
		    For i As Integer = 0 To tcount
		      If clientrequest.Headers.AcceptableTypes(i).Accepts(doc.MIMEType) Then
		        Me.Log("Response is a Acceptable", Log_Debug)
		        Return
		      End If
		    Next
		    Dim accepted As ContentType = doc.MIMEType
		    doc = GetErrorResponse(406, "") 'Not Acceptable
		    doc.MIMEType = accepted
		    Me.Log("Response is not Acceptable", Log_Error)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClientErrorHandler(Sender As SSLSocket)
		  If Sender.LastErrorCode = 102 Then
		    Me.Log(FormatSocketError(Sender.LastErrorCode), Log_Socket)
		  Else
		    Me.Log(FormatSocketError(Sender.LastErrorCode), Log_Error)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DataAvailable(Sender As SSLSocket)
		  Me.Log(CurrentMethodName, Log_Trace)
		  If Me.Threading Then
		    ' Grab a thread from the pool and associate it with the requesting socket.
		    ' The ThreadRun method handles the Thread.Run event of the worker thread,
		    ' which in turn calls the DefaultHandler method within the thread's context.
		    Dim worker As Thread = GetThread(Sender)
		    If worker = Nil Then
		      worker = IdleThreads.Pop
		      Threads.Value(worker) = Sender
		    End If
		    If worker.State <> Thread.Running Then worker.Run
		    
		  Else
		    ' Just call the DefaultHandler method on the current thread.
		    DefaultHandler(Sender)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DefaultHandler(Sender As SSLSocket)
		  ' This method receives and processes all requests made to the server,
		  ' raises the HandleRequest event, and sends the response to the client.
		  
		  
		  Do Until InStr(Sender.Lookahead, CRLF + CRLF) = 0
		    Dim doc As HTTP.Response
		    Dim data As MemoryBlock = Sender.Read(InStr(Sender.Lookahead, CRLF + CRLF))
		    Dim clientrequest As HTTP.Request
		    Dim session As HTTP.Session
		    Try
		      clientrequest = New HTTP.Request(data, UseSessions)
		      Me.Log("Request is well formed", Log_Debug)
		      Me.Log(DecodeURLComponent(clientrequest.ToString), Log_Request)
		      If clientrequest.HasHeader("Content-Length") Then
		        Dim cl As Integer = Val(clientrequest.GetHeader("Content-Length"))
		        If cl + 3 <= Sender.Lookahead.LenB Then
		          Dim msg As String = Sender.Read(cl + 3)
		          clientrequest.MessageBody = msg
		        Else ' still data coming
		          Dim d As String
		          Do
		            d = d + Sender.ReadAll
		            App.YieldToNextThread
		          Loop Until d.LenB >= cl
		          clientrequest.MessageBody = d
		        End If
		      End If
		      
		      If UseSessions Then
		        Dim ID As String = clientrequest.GetCookie("SessionID") ' grab the Session ID if it's there
		        If ID = "" Then
		          Session = GetSession(Sender) ' No session ID, generate a new one
		        Else
		          Session = GetSession(ID) ' the session ID is there, find the session
		          Sockets.Value(Sender) = Session.SessionID ' associate the session ID with the socket
		        End If
		        clientrequest.SessionID = Session.SessionID ' assign the session ID to the request
		      End If
		      
		      
		      
		      Dim tmp As HTTP.Request = clientrequest
		      If TamperRequest(tmp) Then ' allows subclasses to modify requests before they are processed
		        clientrequest = tmp
		      End If
		      
		      ' start processing the request. As soon as doc <> Nil, we're done.
		      Do
		        doc = CheckAuth(clientrequest)
		        If doc <> Nil Then Exit Do ' Bad auth, done.
		        
		        doc = CheckProtocol(clientrequest)
		        If doc <> Nil Then Exit Do ' Bad protocol, done.
		        
		        doc = CheckCache(clientrequest, session)
		        If doc <> Nil Then Exit Do ' Cache hit, done.
		        
		        doc = CheckRedirect(clientrequest, session)
		        If doc <> Nil Then Exit Do ' Redirected, done.
		        
		        Me.Log("Running HandleRequest event", Log_Debug)
		        doc = HandleRequest(clientrequest) ' Ask the subclass to handle it
		        If doc <> Nil Then Exit Do ' Subclass handled it, done.
		        
		        ' No one handled the request, so we send an error message of some sort
		        Me.Log("Sending default response for " + clientrequest.MethodName, Log_Debug)
		        Select Case clientrequest.Method
		        Case RequestMethod.HEAD, RequestMethod.GET
		          doc = GetErrorResponse(404, clientrequest.Path.ServerPath)
		        Case RequestMethod.TRACE
		          doc = GetErrorResponse(200, "")
		          doc.SetHeader("Content-Length") = Str(Data.Size)
		          doc.MIMEType = New ContentType("message/http")
		          doc.MessageBody = Data
		        Case RequestMethod.OPTIONS
		          doc = GetErrorResponse(200, "")
		          doc.MessageBody = ""
		          doc.SetHeader("Content-Length") = "0"
		          doc.SetHeader("Allow") = "GET, HEAD, POST, TRACE, OPTIONS"
		        Else
		          If clientrequest.MethodName <> "" And clientrequest.Method = RequestMethod.InvalidMethod Then
		            doc = GetErrorResponse(501, clientrequest.MethodName) 'Not implemented
		            Me.Log("Request is not implemented", Log_Error)
		          ElseIf clientrequest.MethodName = "" Then
		            doc = GetErrorResponse(400, "") 'bad request
		            Me.Log("Request is malformed", Log_Error)
		          ElseIf clientrequest.MethodName <> "" Then
		            doc = GetErrorResponse(405, clientrequest.MethodName)
		            Me.Log("Request is a NOT ALLOWED", Log_Error)
		          End If
		        End Select
		        Exit Do 'Done constructing the error message
		      Loop
		      
		      doc.Path = clientrequest.Path
		      'doc.SetHeader("Connection") = "close"
		      
		      CheckType(clientrequest, doc)
		      
		    Catch err As UnsupportedFormatException
		      doc = GetErrorResponse(400, "") 'bad request
		      Me.Log("Request is NOT well formed", Log_Error)
		    End Try
		    
		    ' Finally, send the response to the client
		    SendResponse(Sender, doc)
		  Loop
		  
		  
		  
		Exception Err
		  If Err IsA EndException Or Err IsA ThreadEndException Then Raise Err
		  'Return an HTTP 500 Internal Server Error page.
		  Dim errpage As HTTP.Response
		  Dim htmlstack, logstack, funcName As String
		  #If DebugBuild Then
		    Dim s() As String = HTTP.Helpers.CleanStack(Err)
		    funcName = Introspection.GetType(Err).FullName
		    If UBound(s) <= -1 Then
		      htmlstack = "<br />(empty)<br />"
		      logstack = "    (empty)" + EndOfLine
		    Else
		      htmlstack = Join(s, "<br />    ")
		      logstack = Join(s, EndOfLine + "    ")
		    End If
		    htmlstack = "<b>Exception</b>: " + funcName + "<br /><b>Error Number</b>: " + Str(Err.ErrorNumber) + "<br /><b>Message</b>: " _
		    + Err.Message + "<br /><b>Stack trace</b>:<blockquote>    " + htmlstack + "</blockquote>" + EndOfLine
		    
		    logstack = "Exception: " + funcName + EndOfLine + "Error Number: " + Str(Err.ErrorNumber) + EndOfLine + "Message: " _
		    + Err.Message + EndOfLine + "Stack trace:" + EndOfLine + "    " + logstack
		  #endif
		  Me.Log("Runtime exception!" + EndOfLine + logstack , Log_Error)
		  errpage = GetErrorResponse(500, htmlstack)
		  errpage.Compressible = False
		  Me.SendResponse(Sender, errpage)
		  Sender.Purge
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function ErrorPage(ErrorNumber As Integer, Param As String = "") As String
		  Dim page As String = BlankErrorPage
		  page = ReplaceAll(page, "%HTTPERROR%", HTTP.ReplyString(ErrorNumber))
		  
		  Select Case ErrorNumber
		  Case 301, 302
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested resource has moved. <a href=""" + param + """>Click here</a> if you are not automatically redirected.")
		    
		  Case 400
		    page = ReplaceAll(page, "%DOCUMENT%", "The server  did not understand your request.")
		    
		  Case 403, 401
		    page = ReplaceAll(page, "%DOCUMENT%", "Permission to access '" + Param + "' is denied.")
		    
		  Case 404
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested file, '" + Param + "', was not found on this server. ")
		    
		  Case 405
		    page = ReplaceAll(page, "%DOCUMENT%", "The specified HTTP request method '" + Param + "', is not allowed for this resource. ")
		    
		  Case 406
		    page = ReplaceAll(page, "%DOCUMENT%", "Your browser did not specify an acceptable Content-Type that was compatible with the data requested.")
		    
		  Case 410
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested file, '" + Param + "', is no longer available.")
		    
		  Case 416
		    page = ReplaceAll(page, "%DOCUMENT%", "The resource does not contain the requested range.")
		    
		  Case 418
		    page = ReplaceAll(page, "%DOCUMENT%", "I'm a little teapot, short and stout; here is my handle, here is my spout.")
		    
		  Case 451
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested file, '" + Param + "', is unavailable for legal reasons.")
		    
		  Case 500
		    page = ReplaceAll(page, "%DOCUMENT%", "An error ocurred while processing your request. We apologize for any inconvenience. </p><p>" + Param + "</p>")
		    
		  Case 501
		    page = ReplaceAll(page, "%DOCUMENT%", "Your browser has made a request  (verb: '" + Param + "') of this server which, while perhaps valid, is not implemented by this server.")
		    
		  Case 505
		    page = ReplaceAll(page, "%DOCUMENT%", "Your browser specified an HTTP version (" + Param + ") that is not supported by this server. This server supports HTTP 1.0 and HTTP 1.1.")
		    
		  Else
		    page = ReplaceAll(page, "%DOCUMENT%", "An HTTP error of the type specified above has occurred. No further information is available.")
		  End Select
		  
		  page = ReplaceAll(page, "%SIGNATURE%", "<em>Powered By " + HTTP.DaemonVersion + "</em><br />")
		  
		  If page.LenB < 512 Then
		    page = page + "<!--"
		    Do
		      page = page + " padding to make IE happy. "
		    Loop Until page.LenB >= 512
		    page = page + "-->"
		  End If
		  
		  
		  Return Page
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetCache(Sender As HTTP.Session, Path As String) As HTTP.Response
		  Dim logID As String = "NO_SESSION"
		  If UseSessions Then logID = Sender.SessionID
		  If UseSessions Then
		    If Sender.GetCacheItem(Path) <> Nil Then
		      Me.Log("(hit!) Get cache item: " + Path, Log_Debug)
		      Return Sender.GetCacheItem(Path)
		    End If
		  End If
		  Me.Log("(miss!) Get cache item: " + Path, Log_Trace)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function GetErrorResponse(ErrorCode As Integer, Param As String) As HTTP.Response
		  'Use this constructor to create an error Document with the specified HTTP ErrorCode
		  'Param is an error-dependant datum; e.g. doc = New Document(404, "/doesntexist/file.txt")
		  Dim rply As HTTP.Response = GetNewResponse("")
		  rply.StatusCode = ErrorCode
		  Dim data As String = ErrorPage(ErrorCode, Param)
		  rply.SetHeader("Content-Length") = Str(data.LenB)
		  rply.MIMEType = New ContentType("text/html")
		  rply.StatusCode = ErrorCode
		  rply.MessageBody = data
		  rply.Expires = New Date(1999, 12, 31, 23, 59, 59)
		  Return rply
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetFileResponse(page As FolderItem, Path As String, RangeStart As Integer = 0, RangeEnd As Integer = - 1) As HTTP.Response
		  'Use this constructor to create a Document from a FolderItem (file or directory)
		  Dim rply As HTTP.Response = GetNewResponse("")
		  If Not page.Directory Then
		    Dim bs As BinaryStream
		    If rangeend = -1 Then rangeend = page.Length
		    If rangestart < 0 Or rangeend > page.Length Or rangeStart > page.Length Or rangeEnd < 0 Then
		      rply = GetErrorResponse(416, "")
		      rply.SetHeader("Content-Range") = "bytes */" + Str(Page.Length)
		      Return rply
		    End If
		    bs = BinaryStream.Open(page)
		    bs.Position = RangeStart
		    rply.MessageBody = bs.Read(rangeEnd - Rangestart)
		    bs.Close
		    rply.MIMEType = ContentType.GetType(page.Name)
		  End If
		  rply.SetHeader("Content-Length") = Str(rply.MessageBody.LenB)
		  If rply.MIMEType = Nil Then
		    rply.MIMEType = New ContentType("text/html")
		  End If
		  If RangeStart = 0 And RangeEnd = page.Length Then
		    rply.StatusCode = 200
		  Else
		    rply.StatusCode = 206 'partial content
		    rply.SetHeader("Content-Range") = "bytes " + Str(RangeStart) + "-" + Str(RangeEnd) + "/" + Str(Page.Length)
		  End If
		  rply.Path = New HTTP.URI(Path)
		  Dim d As New Date
		  d.TotalSeconds = d.TotalSeconds + 601
		  rply.Expires = d
		  Return rply
		  
		Exception Err As IOException
		  If err.Message.Trim = "" Then
		    err.Message = "The file could not be opened for reading."
		  End If
		  #pragma BreakOnExceptions Off
		  Raise Err
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1001
		Protected Shared Function GetNewResponse(Raw As String = "") As HTTP.Response
		  Return New HTTP.Response(Raw)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetRedirect(Sender As HTTP.Session, Path As String) As HTTP.Response
		  If Sender <> Nil Then
		    'If Right(Path, 1) = "/" And Path <> "/" Then Path = Left(Path, Path.Len - 1)
		    Dim logID As String = "NO_SESSION"
		    If UseSessions Then logID = Sender.SessionID
		    Me.Log(CurrentMethodName + "(" + Path + ") for session " + logID, Log_Trace)
		    If UseSessions THen
		      If Sender.GetRedirect(Path) <> Nil Then
		        Me.Log("(session hit!) Get redirect: " + Path, Log_Debug)
		        Return Sender.GetRedirect(Path)
		      End If
		    End If
		  End If
		  
		  Me.Log(CurrentMethodName + "(" + Path + ")", Log_Trace)
		  
		  If Me.Redirects.HasKey(Path) Then
		    Me.Log("(server hit!) Get redirect: " + Path, Log_Debug)
		    Return Me.Redirects.Value(Path)
		  End If
		  
		  If Me.GlobalRedirects.HasKey(Path) Then
		    Me.Log("(GLOBAL hit!) Get redirect: " + Path, Log_Debug)
		    Return Me.GlobalRedirects.Value(Path)
		  End If
		  
		  Me.Log("(miss!) Get redirect: " + Path, Log_Trace)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetRedirectResponse(Path As String, RedirectURL As String) As HTTP.Response
		  'Use this constructor to create a 302 redirect Document
		  Dim rply As HTTP.Response = GetNewResponse("")
		  rply.StatusCode = 302
		  rply.Path = New HTTP.URI(Path)
		  rply.SetHeader("Location") = RedirectURL
		  rply.Expires = New Date(1999, 12, 31, 23, 59, 59)
		  rply.MessageBody = ErrorPage(302, RedirectURL)
		  rply.MIMEType = New ContentType("text/html")
		  If rply.MIMEType = Nil Then
		    rply.MIMEType = New ContentType("text/html")
		  End If
		  Return rply
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetSession(Socket As SSLSocket) As HTTP.Session
		  Me.Log(CurrentMethodName + "(0x" + Left(Hex(Socket.Handle) + "00000000", 8) + ")", Log_Trace)
		  Dim Session As HTTP.Session
		  If UseSessions Then
		    If Me.Sockets.HasKey(Socket) Then
		      Session = Me.GetSession(Me.Sockets.Value(Socket).StringValue)
		    Else
		      Session = Me.GetSession("New_Session")
		      Sockets.Value(Socket) = Session.SessionID
		    End If
		  End If
		  Return Session
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetSession(SessionID As String) As HTTP.Session
		  Me.Log(CurrentMethodName + "(" + SessionID + ")", Log_Trace)
		  Dim session As HTTP.Session
		  If UseSessions Then
		    If Me.Sessions.HasKey(SessionID) Then
		      Me.Log("Session found: " + SessionID, Log_Debug)
		      While Not SessionsLock.TrySignal
		        App.YieldToNextThread
		      Wend
		      Session = Me.Sessions.Value(SessionID)
		      SessionsLock.Release
		    Else
		      session = New HTTP.Session
		      AddHandler session.Log, WeakAddressOf Me.SessionLog
		      Session.NewSession = True
		      While Not SessionsLock.TrySignal
		        App.YieldToNextThread
		      Wend
		      Sessions.Value(Session.SessionID) = Session
		      SessionsLock.Release
		      Me.Log("Session created: " + Session.SessionID, Log_Debug)
		    End If
		  End If
		  Return session
		  
		Finally
		  SessionsLock.Release
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetSocket(ClientThread As Thread) As SSLSocket
		  Me.Log(CurrentMethodName, Log_Trace)
		  Dim Socket As SSLSocket
		  If Me.Threads.HasKey(ClientThread) Then
		    Socket = Me.Threads.Value(ClientThread)
		  End If
		  Return Socket
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetThread(Sender As SSLSocket) As Thread
		  Me.Log(CurrentMethodName, Log_Trace)
		  For Each w As Thread In Threads.Keys
		    If Threads.Value(w) Is Sender Then
		      Return w
		    End If
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GZipResponse(ByRef ResponseDocument As HTTP.Response)
		  If ResponseDocument.MessageBody.LenB > 0 And ResponseDocument.Compressible Then
		    #If GZIPAvailable And TargetHasGUI Then
		      If Not Me.UseCompression Then
		        If Not ResponseDocument.HasHeader("Content-Encoding") Then ResponseDocument.SetHeader("Content-Encoding") = "Identity"
		        ResponseDocument.MessageBody = Replace(ResponseDocument.MessageBody, "%COMPRESSION%", "No compression.")
		        Return
		      End If
		      
		      Me.Log(CurrentMethodName + "(" + ResponseDocument.SessionID + ")", Log_Trace)
		      Dim gz As MemoryBlock = ResponseDocument.MessageBody
		      If gz.Byte(0) = &h1F And gz.Byte(1) = &h8B Then Return
		      Try
		        Dim size As Integer = ResponseDocument.MessageBody.LenB
		        gz = GZipPage(Replace(ResponseDocument.MessageBody, "%COMPRESSION%", "Compressed with GZip " + GZip.Version))
		        ResponseDocument.MessageBody = gz
		        ResponseDocument.SetHeader("Content-Encoding") ="gzip"
		        size = gz.LenB * 100 / size
		        Me.Log("GZipped page to " + Format(size, "##0.0##\%") + " of original", Log_Debug)
		        ResponseDocument.SetHeader("Content-Length") = Str(gz.LenB)
		      Catch Error
		        'Just send the uncompressed data
		      End Try
		    #else
		      ResponseDocument.SetHeader("Content-Encoding") = "Identity"
		      ResponseDocument.MessageBody = Replace(ResponseDocument.MessageBody, "%COMPRESSION%", "No compression.")
		    #endif
		  Else
		    ResponseDocument.SetHeader("Content-Encoding") = "Identity"
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Listen()
		  Me.Log(CurrentMethodName, Log_Trace)
		  Me.Log("Server now listening...", Log_Socket)
		  Sessions = New Dictionary
		  Sockets = New Dictionary
		  Super.Listen
		  Sessions = New Dictionary
		  SessionTimer = New Timer
		  AddHandler SessionTimer.Action, WeakAddressOf Me.TimeOutHandler
		  SessionTimer.Period = 5000
		  SessionTimer.Mode = Timer.ModeMultiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Log(Message As String, Type As Integer)
		  #If DebugBuild Then
		    System.DebugLog(Str(Type) + " " + Message.Trim)
		  #endif
		  RaiseEvent Log(Message.Trim + EndofLine, Type)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PrepareResponse(ByRef ResponseDocument As HTTP.Response, Socket As SSLSocket)
		  Dim logID As String = "NO_SESSION"
		  If UseSessions Then logID = ResponseDocument.SessionID + ")"
		  Me.Log(CurrentMethodName + "(" + logID + ")", Log_Trace)
		  If ResponseDocument.Method = RequestMethod.HEAD Then
		    ResponseDocument.SetHeader("Content-Length") = Str(ResponseDocument.MessageBody.LenB)
		    ResponseDocument.MessageBody = ""
		  End If
		  If ResponseDocument.StatusCode = 405 Then 'Method not allowed
		    ResponseDocument.SetHeader("Allow") = "GET, HEAD, POST, TRACE"
		  End If
		  If Socket.SSLConnected Then
		    ResponseDocument.MessageBody = Replace(ResponseDocument.MessageBody, "%SECURITY%", "&#x1f512;")'</acronym>")
		  Else
		    ResponseDocument.MessageBody = Replace(ResponseDocument.MessageBody, "%SECURITY%", "")
		  End If
		  If Socket.BytesAvailable > 0 Then
		    ResponseDocument.SetHeader("Connection") = "keep-alive"
		  Else
		    ResponseDocument.SetHeader("Connection") = "close"
		  End If
		  ResponseDocument.SetHeader("Accept-Ranges") = "bytes"
		  ResponseDocument.SetHeader("Server") = HTTP.DaemonVersion
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PrepareSession(ByRef ResponseDocument As HTTP.Response, ByRef Session As HTTP.Session)
		  Dim logID As String = "NO_SESSION"
		  If UseSessions Then logID = Session.SessionID
		  Me.Log(CurrentMethodName + "(" + logID + ")", Log_Trace)
		  If UseSessions Then
		    Session.ExtendSession
		    If Session.NewSession Then
		      Me.Log("Set session cookie: " + Session.SessionID, Log_Trace)
		      Dim c As New Cookie("SessionID=" + Session.SessionID)
		      c.Secure = (Me.ConnectionType <> ConnectionTypes.Insecure)
		      c.Path = "/"
		      c.Port = Me.Port
		      ResponseDocument.Headers.Cookie(-1) = c
		      'ResponseDocument.Headers.Cookie
		      Session.NewSession = False
		    ElseIf ResponseDocument.HasCookie("SessionID") Then
		      Me.Log("Clear session cookie", Log_Debug)
		      ResponseDocument.RemoveCookie("SessionID")
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveRedirect(HTTPpath As String)
		  ' This method removes the passed path from the list of server-wide redirects.
		  ' See also: AddRedirect
		  
		  Me.Log(CurrentMethodName + "(" + HTTPpath + ")", Log_Trace)
		  Me.Log(CurrentMethodName, Log_Trace)
		  If Redirects.HasKey(HTTPpath) Then
		    Me.Log("Removed redirect: " + HTTPPath, Log_Debug)
		    Redirects.Remove(HTTPpath)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendCompleteHandler(Sender As SSLSocket, UserAborted As Boolean)
		  #pragma Unused UserAborted
		  Me.Log("Send complete", Log_Socket)
		  Sender.Close
		  Me.Log("Socket closed", Log_Trace)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendResponse(Socket As SSLSocket, ResponseDocument As HTTP.Response)
		  Dim logID As String = "NO_SESSION"
		  Dim session As HTTP.Session
		  If UseSessions Then
		    session = GetSession(Socket)
		    logID = Session.SessionID
		  End If
		  Me.Log(CurrentMethodName + "(" + LogID + ")", Log_Trace)
		  Dim tmp As HTTP.Response = ResponseDocument
		  If TamperResponse(tmp) Then
		    Me.Log("Outbound tamper.", Log_Debug)
		    ResponseDocument = tmp
		  End If
		  
		  PrepareResponse(ResponseDocument, Socket)
		  PrepareSession(ResponseDocument, session)
		  GZipResponse(ResponseDocument)
		  
		  Me.Log("Sending data", Log_Socket)
		  Socket.Write(ResponseDocument.ToString)
		  Me.Log(ReplyString(ResponseDocument.StatusCode) + CRLF + ResponseDocument.Headers.Source(True), Log_Response)
		  If UseSessions And ResponseDocument.Method = RequestMethod.GET And ResponseDocument.StatusCode = 200 Then
		    Session.AddCacheItem(ResponseDocument)
		  End If
		  Socket.Flush
		  If ResponseDocument.GetHeader("Connection") <> "keep-alive" Then
		    Socket.Close
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SessionLog(Sender As HTTP.Session, Message As String, Severity As Integer)
		  #pragma Unused Sender
		  Me.Log(Message, Severity)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopListening()
		  Me.Log(CurrentMethodName, Log_Trace)
		  Super.StopListening
		  Me.Log("Server stopped listening.", Log_Socket)
		  
		  Me.Sessions = New Dictionary
		  Me.Sockets = New Dictionary
		  Me.Threads = New Dictionary
		  ReDim IdleThreads(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ThreadRun(Sender As Thread)
		  If Me.Threading Then Me.Log("Your server today is 0x" + Left(Hex(Sender.ThreadID) + "00000000", 8), Log_Trace)
		  DefaultHandler(GetSocket(Sender))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TimeOutHandler(Sender As Timer)
		  #pragma Unused Sender
		  Dim d As New Date
		  For Each Id As String In Sessions.Keys
		    Dim session As HTTP.Session = Me.Sessions.Value(Id)
		    If session.LastActivity.TotalSeconds + Me.SessionTimeout < d.TotalSeconds Then
		      Me.Log("Session timed out (" + ID + ")", Log_Debug)
		      Me.Sessions.Remove(Id)
		    End If
		  Next
		  
		  For Each Socket As SSLSocket In Me.Sockets.Keys
		    If Not Sessions.HasKey(Me.Sockets.Value(Socket)) Or Not Socket.IsConnected Then
		      Me.Log("Socket destroyed", Log_Socket)
		      Socket.Close
		      Me.Sockets.Remove(Socket)
		    End If
		  Next
		  
		  For Each t As Thread In Me.Threads.Keys
		    If t.State <> 0 Then
		      Me.Log("Thread destroyed", Log_Trace)
		      Me.Threads.Remove(t)
		    End If
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function VirtualResponse(VirtualURL As String) As HTTP.Response
		  'Use this constructor to create a 302 redirect Document
		  Dim rply As HTTP.Response = GetNewResponse("")
		  rply.StatusCode = 200
		  rply.Path = New URI(VirtualURL)
		  Return rply
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Authenticate(ClientRequest As HTTP.Request) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event HandleRequest(ClientRequest As HTTP.Request) As HTTP.Response
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Log(Message As String, Severity As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TamperRequest(ByRef Request As HTTP.Request) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TamperResponse(ByRef Response As HTTP.Response) As Boolean
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mAuthenticationRealm
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.Log(CurrentMethodName + "=" + value, Log_Trace)
			  mAuthenticationRealm = value
			End Set
		#tag EndSetter
		AuthenticationRealm As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mAuthenticationRequired
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mAuthenticationRequired = value
			  Me.Log(CurrentMethodName + "=" + Str(value), Log_Trace)
			End Set
		#tag EndSetter
		AuthenticationRequired As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mCertificateFile
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCertificateFile = value
			  Dim valpath As String
			  If value <> Nil Then
			    #If RBVersion >= 2013 Then
			      valpath = value.NativePath
			    #Else
			      valpath = value.AbsolutePath
			    #endif
			  Else
			    valPath = "Nil"
			  End If
			  
			  Me.Log(CurrentMethodName + "=" + valPath, Log_Trace)
			End Set
		#tag EndSetter
		CertificateFile As FolderItem
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mCertificatePassword
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mCertificatePassword = value
			  Me.Log(CurrentMethodName + "=""" + value + """", Log_Trace)
			End Set
		#tag EndSetter
		CertificatePassword As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mConnectionType
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Select Case value
			  Case ConnectionTypes.Insecure
			    Me.Log(CurrentMethodName + "=Insecure", Log_Trace)
			  Case ConnectionTypes.SSLv3
			    Me.Log(CurrentMethodName + "=SSLv3", Log_Trace)
			  Case ConnectionTypes.TLSv1
			    Me.Log(CurrentMethodName + "=TLSv1", Log_Trace)
			  Else
			    Me.Log(CurrentMethodName + "=Unknown!", Log_Trace)
			  End Select
			  mConnectionType = value
			End Set
		#tag EndSetter
		ConnectionType As ConnectionTypes
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mEnforceContentType
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mEnforceContentType = value
			  Me.Log(CurrentMethodName + "=" + Str(value), Log_Trace)
			End Set
		#tag EndSetter
		EnforceContentType As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mGlobalRedirects = Nil Then
			    mGlobalRedirects = New Dictionary
			  End If
			  Return mGlobalRedirects
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mGlobalRedirects = value
			End Set
		#tag EndSetter
		Shared GlobalRedirects As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected Shared GlobalsInited As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IdleThreads() As Thread
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAuthenticationRealm As String = """Restricted Area"""
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAuthenticationRequired As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCertificateFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCertificatePassword As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mConnectionType As ConnectionTypes = ConnectionTypes.Insecure
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEnforceContentType As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mGlobalRedirects As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRedirects As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRedirectsLock As Semaphore
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSessionsLock As Semaphore
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The number of seconds of inactivity after which the session is deemed inactive. The default is 10 minutes (600 seconds.)
			Actual timeout periods have a resolution of ±5 seconds. Setting this value to <=5 will result in all sessions being
			timedout at the next run of the TimeOutTimer action event.
		#tag EndNote
		Private mSessionTimeout As Integer = 600
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mThreading As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mThreads As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUseCompression As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUseSessions As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mRedirects = Nil Then
			    mRedirects = New Dictionary
			    Me.Log("Global redirects dictionary initialized", Log_Trace)
			  End If
			  return mRedirects
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.Log(CurrentMethodName, Log_Trace)
			  mRedirects = value
			End Set
		#tag EndSetter
		Protected Redirects As Dictionary
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  If mRedirectsLock = Nil Then mRedirectsLock = New Semaphore
			  return mRedirectsLock
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mRedirectsLock = value
			End Set
		#tag EndSetter
		Private RedirectsLock As Semaphore
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected Sessions As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  If mSessionsLock = Nil Then mSessionsLock = New Semaphore
			  return mSessionsLock
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSessionsLock = value
			End Set
		#tag EndSetter
		Private SessionsLock As Semaphore
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mSessionTimeout
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSessionTimeout = value
			  Me.Log(CurrentMethodName + "=" + Str(value), Log_Trace)
			End Set
		#tag EndSetter
		SessionTimeout As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private SessionTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Sockets As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mThreading
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.Log(CurrentMethodName + "=" + Str(value), Log_Trace)
			  If Me.IsListening Then
			    If value Then
			      While Me.MinimumSocketsAvailable > Me.IdleThreads.Ubound + 1
			        Dim worker As New Thread
			        AddHandler worker.Run, WeakAddressOf Me.ThreadRun
			        IdleThreads.Insert(0, worker)
			      Wend
			    Else
			      ReDim IdleThreads(-1)
			    End If
			  End If
			  mThreading = value
			End Set
		#tag EndSetter
		Threading As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  If mThreads = Nil Then mThreads = New Dictionary
			  return mThreads
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mThreads = value
			End Set
		#tag EndSetter
		Private Threads As Dictionary
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mUseCompression
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.Log(CurrentMethodName + "=" + Str(value), Log_Trace)
			  mUseCompression = value
			End Set
		#tag EndSetter
		UseCompression As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mUseSessions
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.Log(CurrentMethodName + "=" + Str(value), Log_Trace)
			  mUseSessions = value
			End Set
		#tag EndSetter
		UseSessions As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = BlankErrorPage, Type = String, Dynamic = False, Default = \"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r<html xmlns\x3D\"http://www.w3.org/1999/xhtml\">\r<head>\r<meta http-equiv\x3D\"Content-Type\" content\x3D\"text/html; charset\x3Diso-8859-1\" />\r<title>%HTTPERROR%</title>\r<style type\x3D\"text/css\">\r<!--\rbody\x2Ctd\x2Cth {\r\tfont-family: Arial\x2C Helvetica\x2C sans-serif;\r\tfont-size: medium;\r}\ra:link {\r\tcolor: #0000FF;\r\ttext-decoration: none;\r}\ra:visited {\r\ttext-decoration: none;\r\tcolor: #990000;\r}\ra:hover {\r\ttext-decoration: underline;\r\tcolor: #009966;\r}\ra:active {\r\ttext-decoration: none;\r\tcolor: #FF0000;\r}\r-->\r</style></head>\r\r<body>\r<h1>%HTTPERROR%</h1>\r<p>%DOCUMENT%</p>\r<hr />\r<p>%SIGNATURE%</p>\r</body>\r</html>", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Log_Debug, Type = Double, Dynamic = False, Default = \"-1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Error, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Request, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Response, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Socket, Type = Double, Dynamic = False, Default = \"-3.0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Status, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Trace, Type = Double, Dynamic = False, Default = \"-2", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AuthenticationRealm"
			Visible=true
			Group="Behavior"
			InitialValue="Restricted Area"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthenticationRequired"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CertificatePassword"
			Visible=true
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EnforceContentType"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumSocketsConnected"
			Visible=true
			Group="Behavior"
			InitialValue="10"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumSocketsAvailable"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionTimeout"
			Visible=true
			Group="Behavior"
			InitialValue="600"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Threading"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseCompression"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseSessions"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
