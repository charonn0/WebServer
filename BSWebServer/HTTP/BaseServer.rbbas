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
		  AddHandler sock.DataAvailable, AddressOf Me.DataAvailable
		  AddHandler sock.Error, AddressOf Me.ClientErrorHandler
		  AddHandler sock.SendComplete, AddressOf Me.SendCompleteHandler
		  Return sock
		End Function
	#tag EndEvent

	#tag Event
		Sub Error(ErrorCode as Integer)
		  Me.Log(CurrentMethodName, Log_Trace)
		  Dim err As String = SocketErrorMessage(ErrorCode)
		  
		  If ErrorCode <> 102 Then
		    Me.Log(err, Log_Error)
		  Else
		    Me.Log(err, Log_Socket)
		  End If
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddRedirect(Page As HTTP.Response)
		  Me.Log(CurrentMethodName, Log_Trace)
		  Me.Log("Add redirect for " + page.Path.ServerPath, Log_Debug)
		  Redirects.Value(page.Path.ServerPath) = Page
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CheckAuth(ClientRequest As HTTP.Request) As HTTP.Response
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim doc As HTTP.Response
		  If AuthenticationRequired Then
		    Me.Log("Authenticating", Log_Debug)
		    If Not Authenticate(clientrequest) Then
		      Me.Log("Authentication failed", Log_Error)
		      doc = doc.GetErrorResponse(401, clientrequest.Path.ServerPath)
		      doc.SetHeader("WWW-Authenticate", "Basic realm=""" + clientrequest.AuthRealm + """")
		    Else
		      Me.Log("Authentication Successful", Log_Debug)
		    End If
		  End If
		  Return doc
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CheckCache(ClientRequest As HTTP.Request, Session As HTTP.Session) As HTTP.Response
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim cache As HTTP.Response
		  If UseSessions Then
		    If clientrequest.CacheDirective <> "" Or clientrequest.Path.Arguments.Ubound > -1 Then
		      Select Case clientrequest.CacheDirective
		      Case "no-cache", "max-age=0"
		        Me.Log("Cache control override: " + clientrequest.CacheDirective, Log_Debug)
		        cache = Nil
		      End Select
		    Else
		      cache = GetCache(Session, clientRequest.Path.ToString)
		    End If
		    If cache <> Nil Then
		      cache.Compressable = False
		      Me.Log("Page from cache", Log_Debug)
		      Cache.Expires = New Date
		      Cache.Expires.TotalSeconds = Cache.Expires.TotalSeconds + 60
		      If clientrequest.IsModifiedSince(Cache.Expires) Then
		        If clientrequest.Method = RequestMethod.GET Or clientrequest.Method = RequestMethod.HEAD Then
		          Cache = Cache.GetErrorResponse(304, "")
		          Cache.MessageBody = ""
		        Else
		          Cache = Cache.GetErrorResponse(412, "") 'Precondition failed
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
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim doc As HTTP.Response
		  If clientrequest.ProtocolVersion < 1.0 Or clientrequest.ProtocolVersion >= 1.2 Then
		    doc = doc.GetErrorResponse(505, Format(ClientRequest.ProtocolVersion, "#.0"))
		    Me.Log("Unsupported protocol version", Log_Error)
		  End If
		  
		  Return doc
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CheckRedirect(ClientRequest As HTTP.Request, Session As HTTP.Session) As HTTP.Response
		  
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim redir As HTTP.Response = GetRedirect(Session, clientrequest.Path.ServerPath)
		  If redir <> Nil Then Me.Log("Using redirect.", Log_Debug)
		  Return redir
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckType(ClientRequest As HTTP.Request, ByRef doc As HTTP.Response)
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  If EnforceContentType Then
		    Me.Log("Checking Accepts", Log_Debug)
		    For i As Integer = 0 To UBound(clientrequest.Headers.AcceptableTypes)
		      If clientrequest.Headers.AcceptableTypes(i).Accepts(doc.MIMEType) Then
		        Me.Log("Response is a Acceptable", Log_Debug)
		        Return
		      End If
		    Next
		    Dim accepted As ContentType = doc.MIMEType
		    doc = doc.GetErrorResponse(406, "") 'Not Acceptable
		    doc.MIMEType = accepted
		    Me.Log("Response is not Acceptable", Log_Error)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClientErrorHandler(Sender As SSLSocket)
		  Me.Log(SocketErrorMessage(Sender.LastErrorCode), Log_Socket)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DataAvailable(Sender As SSLSocket)
		  Me.Log(CurrentMethodName, Log_Trace)
		  Dim msg As String = "Incoming request from: " + Sender.RemoteAddress + "(0x" + Left(Hex(Sender.Handle) + "0000", 4)
		  If Sender.Secure Then
		    If Me.ConnectionType = ConnectionTypes.SSLv3 Then
		      msg = msg + ") security=SSLv3"
		    Else
		      msg = msg + ") security=TLSv1"
		    End If
		  Else
		    msg = msg + ")"
		  End If
		  Me.Log(msg, Log_Status)
		  Dim data As MemoryBlock
		  Dim la As String = Sender.Lookahead
		  If AllowPipeLinedRequests And (Left(la, 3) = "GET" or Left(la, 4) = "HEAD") Then
		    Dim length As Integer = InStr(la, CRLF + CRLF)
		    data = Sender.Read(length + 3)
		    Me.Log("HTTP Pipelining mode is selected", Log_Debug)
		  Else
		    Me.Log("HTTP Pipelining mode is NOT selected", Log_Debug)
		    data = Sender.ReadAll
		  End If
		  
		  Dim clientrequest As HTTP.Request
		  Dim doc As HTTP.Response
		  Dim session As HTTP.Session
		  Try
		    clientrequest = New HTTP.Request(data, UseSessions)
		    Me.Log("Request is well formed", Log_Debug)
		    Me.Log(DecodeURLComponent(clientrequest.ToString), Log_Request)
		    If UseSessions Then
		      Dim ID As String = clientrequest.GetCookie("SessionID")
		      If ID = "" Then
		        Session = GetSession(Sender)
		      Else
		        Session = GetSession(ID)
		        Sockets.Value(Sender) = Session.SessionID
		      End If
		      clientrequest.SessionID = Session.SessionID
		      
		    End If
		    
		    
		    
		    Dim tmp As HTTP.Request = clientrequest
		    If TamperRequest(tmp) Then
		      clientrequest = tmp
		    End If
		    
		    
		    Do
		      doc = CheckAuth(clientrequest)
		      If doc <> Nil Then Exit Do
		      doc = CheckProtocol(clientrequest)
		      If doc <> Nil Then Exit Do
		      doc = CheckCache(clientrequest, session)
		      If doc <> Nil Then Exit Do
		      doc = CheckRedirect(clientrequest, session)
		      If doc <> Nil Then Exit Do
		      Exit Do
		    Loop
		    
		    If doc = Nil Then
		      Me.Log("Running HandleRequest event", Log_Debug)
		      doc = HandleRequest(clientrequest)
		    End If
		    If doc = Nil Then doc = DefaultHandler(clientrequest, Data)
		    
		    doc.Path = clientrequest.Path
		    If Sender.Lookahead.Trim <> "" And AllowPipeLinedRequests Then
		      clientrequest.SetHeader("Connection", "keep-alive")
		    Else
		      clientrequest.SetHeader("Connection", "close")
		    End If
		    
		    CheckType(clientrequest, doc)
		    
		  Catch err As UnsupportedFormatException
		    If err.ErrorNumber = 1 Then 'ssl?
		      doc = doc.GetErrorResponse(101, "") 'Switch protocols
		      doc.MessageBody = ""
		      doc.Headers.DeleteAllHeaders
		      doc.SetHeader("Upgrade", "HTTP/1.0")
		      Me.Log("Request is NOT well formed", Log_Error)
		    Else
		      doc = doc.GetErrorResponse(400, "") 'bad request
		      Me.Log("Request is NOT well formed", Log_Error)
		    End If
		  End Try
		  SendResponse(Sender, doc)
		  
		  
		  
		Exception Err
		  If Err IsA EndException Or Err IsA ThreadEndException Then Raise Err
		  'Return an HTTP 500 Internal Server Error page.
		  Dim errpage As HTTP.Response
		  Dim htmlstack, logstack, funcName As String
		  #If DebugBuild Then
		    Dim s() As String = Err.CleanStack
		    funcName = Introspection.GetType(Err).FullName
		    If UBound(s) <= -1 Then
		      htmlstack = "<br />(empty)<br />"
		      logstack = "    (empty)" + EndOfLine
		    Else
		      htmlstack = Join(s, "<br />    ")
		      logstack = Join(s, EndOfLine + "    ")
		    End If
		    htmlstack = "<b>Exception<b>: " + funcName + "<br />Error Number: " + Str(Err.ErrorNumber) + "<br />Message: " _
		    + Err.Message + "<br />Stack trace:<blockquote>    " + htmlstack + "</blockquote>" + EndOfLine
		    
		    logstack = "Exception: " + funcName + EndOfLine + "Error Number: " + Str(Err.ErrorNumber) + EndOfLine + "Message: " _
		    + Err.Message + EndOfLine + "Stack trace:" + EndOfLine + "    " + logstack
		  #endif
		  Me.Log("Runtime exception!" + EndOfLine + logstack , Log_Error)
		  errpage = doc.GetErrorResponse(500, htmlstack)
		  
		  Me.SendResponse(Sender, errpage)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DefaultHandler(ClientRequest As HTTP.Request, Data As MemoryBlock) As HTTP.Response
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim doc As HTTP.Response
		  Me.Log("Sending default response for " + clientrequest.MethodName, Log_Debug)
		  Select Case clientrequest.Method
		  Case RequestMethod.HEAD, RequestMethod.GET
		    doc = doc.GetErrorResponse(404, clientrequest.Path.ServerPath)
		  Case RequestMethod.TRACE
		    doc = doc.GetErrorResponse(200, "")
		    doc.SetHeader("Content-Length", Str(Data.Size))
		    doc.SetHeader("Content-Type", "message/http")
		    doc.MessageBody = Data
		  Case RequestMethod.OPTIONS
		    doc = doc.GetErrorResponse(200, "")
		    doc.MessageBody = ""
		    doc.SetHeader("Content-Length", "0")
		    doc.SetHeader("Allow", "GET, HEAD, POST, TRACE, OPTIONS")
		    doc.SetHeader("Accept-Ranges", "bytes")
		  Else
		    If clientrequest.MethodName <> "" And clientrequest.Method = RequestMethod.InvalidMethod Then
		      doc = doc.GetErrorResponse(501, clientrequest.MethodName) 'Not implemented
		      Me.Log("Request is not implemented", Log_Error)
		    ElseIf clientrequest.MethodName = "" Then
		      doc = doc.GetErrorResponse(400, "") 'bad request
		      Me.Log("Request is malformed", Log_Error)
		    ElseIf clientrequest.MethodName <> "" Then
		      doc = doc.GetErrorResponse(405, clientrequest.MethodName)
		      Me.Log("Request is a NOT ALLOWED", Log_Error)
		    End If
		  End Select
		  
		  Return doc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetCache(Sender As HTTP.Session, Path As String) As HTTP.Response
		  Dim logID As String = "NO_SESSION"
		  If UseSessions Then logID = Sender.SessionID
		  Me.Log(CurrentMethodName + logID, Log_Trace)
		  If UseSessions Then
		    If Sender.GetCacheItem(Path) <> Nil Then
		      Me.Log("(hit!) Get cache item: " + Path, Log_Debug)
		      Return Sender.GetCacheItem(Path)
		    End If
		  End If
		  Me.Log("(miss!) Get cache item: " + Path, Log_Debug)
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
		    If Sender <> Nil Then Sender.AddCacheItem(Me.GlobalRedirects.Value(Path))
		    Return Me.GlobalRedirects.Value(Path)
		  End If
		  
		  Me.Log("(miss!) Get redirect: " + Path, Log_Debug)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetSession(Socket As SSLSocket) As HTTP.Session
		  Me.Log(CurrentMethodName + "(0x" + Left(Hex(Socket.Handle) + "0000", 4) + ")", Log_Trace)
		  If UseSessions Then
		    If Me.Sockets.HasKey(Socket) Then
		      Return Me.GetSession(Me.Sockets.Value(Socket).StringValue)
		    Else
		      Dim s As HTTP.Session = Me.GetSession("New_Session")
		      Sockets.Value(Socket) = s.SessionID
		      Return s
		    End If
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetSession(SessionID As String) As HTTP.Session
		  Me.Log(CurrentMethodName + "(" + SessionID + ")", Log_Trace)
		  If UseSessions Then
		    If Me.Sessions.HasKey(SessionID) Then
		      Me.Log("Session found: " + SessionID, Log_Debug)
		      Return Me.Sessions.Value(SessionID)
		    Else
		      Dim s As New HTTP.Session
		      s.NewSession = True
		      Sessions.Value(s.SessionID) = s
		      Me.Log("Session created: " + s.SessionID, Log_Debug)
		      Return s
		    End If
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GZipResponse(ByRef ResponseDocument As HTTP.Response)
		  Me.Log(CurrentMethodName + "(" + ResponseDocument.SessionID + ")", Log_Trace)
		  If ResponseDocument.MessageBody.LenB > 0 And ResponseDocument.Compressable Then
		    #If GZIPAvailable Then
		      ResponseDocument.SetHeader("Content-Encoding", "gzip")
		      Dim gz As String
		      Try
		        Dim size As Integer = ResponseDocument.MessageBody.LenB
		        gz = GZipPage(Replace(ResponseDocument.MessageBody, "%COMPRESSION%", "Compressed with GZip " + GZip.Version))
		        ResponseDocument.MessageBody = gz
		        size = gz.LenB * 100 / size
		        Me.Log("GZipped page to " + Format(size, "##0.0##\%") + " of original", Log_Debug)
		      Catch Error
		        'Just send the uncompressed data
		      End Try
		      ResponseDocument.SetHeader("Content-Length", Str(ResponseDocument.MessageBody.LenB))
		    #else
		      ResponseDocument.MessageBody = Replace(ResponseDocument.MessageBody, "%COMPRESSION%", "No compression.")
		    #endif
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
		  AddHandler SessionTimer.Action, AddressOf Me.TimeOutHandler
		  SessionTimer.Period = 5000
		  SessionTimer.Mode = Timer.ModeMultiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Log(Message As String, Type As Integer)
		  #If DebugBuild Then
		    System.DebugLog(Str(Type) + " " + Message)
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
		    ResponseDocument.SetHeader("Content-Length", Str(ResponseDocument.MessageBody.LenB))
		    ResponseDocument.MessageBody = ""
		  End If
		  If ResponseDocument.StatusCode = 405 Then 'Method not allowed
		    ResponseDocument.SetHeader("Allow", "GET, HEAD, POST, TRACE")
		  End If
		  If Socket.SSLConnected Then
		    ResponseDocument.MessageBody = Replace(ResponseDocument.MessageBody, "%SECURITY%", "&#x1f512;")'</acronym>")
		  Else
		    ResponseDocument.MessageBody = Replace(ResponseDocument.MessageBody, "%SECURITY%", "")
		  End If
		  If Socket.Lookahead <> "" And AllowPipeLinedRequests Then
		    ResponseDocument.SetHeader("Connection", "keep-alive")
		  Else
		    ResponseDocument.SetHeader("Connection", "close")
		  End If
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
		      Me.Log("Set session cookie: " + Session.SessionID, Log_Debug)
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
		  Me.Log(CurrentMethodName + "(" + HTTPpath + ")", Log_Trace)
		  Me.Log(CurrentMethodName, Log_Trace)
		  Me.Log("Remove redirect: " + HTTPPath, Log_Debug)
		  If Redirects.HasKey(HTTPpath) Then
		    Redirects.Remove(HTTPpath)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendCompleteHandler(Sender As SSLSocket, UserAborted As Boolean)
		  #pragma Unused UserAborted
		  Me.Log("Send complete", Log_Socket)
		  If Sender.Lookahead.Trim <> "" And AllowPipeLinedRequests Then
		    Me.Log("Socket kept alive", Log_Debug)
		  Else
		    Sender.Close
		    Me.Log("Socket closed", Log_Debug)
		  End If
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
		  Me.Log(ReplyString(ResponseDocument.StatusCode) + CRLF + ResponseDocument.GetHeaders, Log_Response)
		  
		  Socket.Write(ResponseDocument.ToString)
		  Socket.Flush
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopListening()
		  Me.Log(CurrentMethodName, Log_Trace)
		  Super.StopListening
		  Me.Log("Server stopped listening.", Log_Socket)
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
		      Me.Sockets.Remove(Socket)
		    End If
		  Next
		  
		  
		End Sub
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


	#tag Property, Flags = &h0
		AllowPipeLinedRequests As Boolean = False
	#tag EndProperty

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
			  #If RBVersion >= 2013 Then
			    valpath = value.NativePath
			  #Else
			    valpath = value.AbsolutePath
			  #endif
			  
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
			  Me.Log(CurrentMethodName + "=" + value, Log_Trace)
			End Set
		#tag EndSetter
		CertificatePassword As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		ConnectionType As ConnectionTypes = ConnectionTypes.Insecure
	#tag EndProperty

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
		Private mEnforceContentType As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mGlobalRedirects As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRedirects As Dictionary
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

	#tag Property, Flags = &h1
		Protected Sessions As Dictionary
	#tag EndProperty

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
			  return mUseSessions
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mUseSessions = value
			  
			  Me.Log(CurrentMethodName + "=" + Str(value), Log_Trace)
			End Set
		#tag EndSetter
		UseSessions As Boolean
	#tag EndComputedProperty


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

	#tag Constant, Name = VirtualRoot, Type = String, Dynamic = False, Default = \"_bsdaemon", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllowPipeLinedRequests"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
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
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="ServerSocket"
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