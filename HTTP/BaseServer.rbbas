#tag Class
Protected Class BaseServer
Inherits ServerSocket
	#tag Event
		Function AddSocket() As TCPSocket
		  Me.Log(CurrentMethodName, Log_Trace)
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
		Sub AddRedirect(Page As HTTPParse.Response)
		  Me.Log(CurrentMethodName, Log_Trace)
		  Me.Log("Add redirect for " + page.Path, Log_Debug)
		  Redirects.Value(Page.Path) = Page
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClientErrorHandler(Sender As TCPSocket)
		  Me.Log(SocketErrorMessage(Sender.LastErrorCode), Log_Socket)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClientLogHandler(Sender As TCPSocket, Message As String, Level As Integer)
		  #pragma Unused Sender
		  Me.Log(Message, Level)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DataAvailable(Sender As TCPSocket)
		  Me.Log(CurrentMethodName, Log_Trace)
		  Me.Log("Incoming data", Log_Socket)
		  Dim data As MemoryBlock = Sender.ReadAll
		  Dim clientrequest As HTTPParse.Request
		  Dim doc As HTTPParse.Response
		  Try
		    clientrequest = New HTTPParse.Request(data, UseSessions)
		    Me.Log("Request is well formed", Log_Debug)
		    If clientrequest.HasHeader("Connection") Then
		      'Me.KeepAlive = (clientrequest.GetHeader("Connection") = "keep-alive")
		    End If
		    Me.Log(URLDecode(clientrequest.ToString), Log_Request)
		    If UseSessions Then
		      Dim ID As String = clientrequest.GetCookie("SessionID")
		      Dim s As HTTP.Session
		      If ID = "" Then
		        s = GetSession(Sender)
		      Else
		        s = GetSession(ID)
		        Sockets.Value(Sender) = s.SessionID
		      End If
		      clientrequest.SessionID = s.SessionID
		      
		    End If
		    
		    
		    
		    Dim tmp As HTTPParse.Request = clientrequest
		    If TamperRequest(tmp) Then
		      clientrequest = tmp
		    End If
		    
		    If clientrequest.ProtocolVersion < 1.0 Or clientrequest.ProtocolVersion >= 1.2 Then
		      doc = New HTTPParse.ErrorResponse(505, Format(ClientRequest.ProtocolVersion, "#.0"))
		      Me.Log("Unsupported protocol version", Log_Error)
		    ElseIf AuthenticationRequired Then
		      Me.Log("Authenticating", Log_Debug)
		      If Not Authenticate(clientrequest) Then
		        Me.Log("Authentication failed", Log_Error)
		        doc = New HTTPParse.ErrorResponse(401, clientrequest.Path)
		        doc.SetHeader("WWW-Authenticate", "Basic realm=""" + clientrequest.AuthRealm + """")
		      Else
		        Me.Log("Authentication Successful", Log_Debug)
		      End If
		    End If
		  Catch err As UnsupportedFormatException
		    doc = New HTTPParse.ErrorResponse(400, "") 'bad request
		    Me.Log("Request is NOT well formed", Log_Error)
		  End Try
		  
		  If UseSessions Then
		    Dim cache As HTTPParse.Response
		    If clientrequest.CacheDirective <> "" Then
		      Select Case clientrequest.CacheDirective
		      Case "no-cache", "max-age=0"
		        Me.Log("Cache control override: " + clientrequest.CacheDirective, Log_Debug)
		        cache = Nil
		      End Select
		    Else
		      cache = GetCache(GetSession(Sender), clientRequest.Path)
		    End If
		    Dim redir As HTTPParse.Response = GetRedirect(GetSession(Sender), clientrequest.Path)
		    If redir <> Nil Then
		      doc = redir
		      Me.Log("Using redirect.", Log_Debug)
		    ElseIf cache <> Nil Then
		      'Cache hit
		      doc = Cache
		      doc.FromCache = True
		      Me.Log("Page from cache", Log_Debug)
		      Cache.Expires = New Date
		      Cache.Expires.TotalSeconds = Cache.Expires.TotalSeconds + 60
		    ElseIf doc = Nil Then
		      doc = HandleRequest(clientrequest)
		      If UseSessions And GetSession(clientrequest.SessionID) <> Nil And clientrequest.CacheDirective <> "no-store" Then
		        GetSession(clientrequest.SessionID).AddCacheItem(doc)
		      End If
		    End If
		  End If
		  If doc = Nil Then
		    Me.Log("Running HandleRequest event", Log_Debug)
		    doc = HandleRequest(clientrequest)
		  End If
		  If doc = Nil Then
		    Select Case clientrequest.Method
		    Case RequestMethod.TRACE
		      Me.Log("Request is a TRACE", Log_Debug)
		      doc = New HTTPParse.ErrorResponse(200, "")
		      doc.SetHeader("Content-Length", Str(Data.Size))
		      doc.SetHeader("Content-Type", "message/http")
		      doc.MessageBody = Data
		    Case RequestMethod.OPTIONS
		      Me.Log("Request is a OPTIONS", Log_Debug)
		      doc = New HTTPParse.ErrorResponse(200, "")
		      doc.MessageBody = ""
		      doc.SetHeader("Content-Length", "0")
		      doc.SetHeader("Allow", "GET, HEAD, POST, TRACE, OPTIONS")
		      doc.SetHeader("Accept-Ranges", "bytes")
		    Case RequestMethod.GET, RequestMethod.HEAD
		      Me.Log("Request is a HEAD", Log_Debug)
		      doc = New HTTPParse.ErrorResponse(404, clientrequest.Path)
		    Else
		      If clientrequest.MethodName <> "" And clientrequest.Method = RequestMethod.InvalidMethod Then
		        doc = New HTTPParse.ErrorResponse(501, clientrequest.MethodName) 'Not implemented
		        Me.Log("Request is not implemented", Log_Error)
		      ElseIf clientrequest.MethodName = "" Then
		        doc = New HTTPParse.ErrorResponse(400, "") 'bad request
		        Me.Log("Request is malformed", Log_Error)
		      ElseIf clientrequest.MethodName <> "" Then
		        doc = New HTTPParse.ErrorResponse(405, clientrequest.MethodName)
		        Me.Log("Request is a NOT ALLOWED", Log_Error)
		      End If
		    End Select
		  End If
		  
		  If clientrequest.IfModifiedSince <> Nil And doc.Modified <> Nil Then
		    If clientrequest.Method = RequestMethod.GET Or clientrequest.Method = RequestMethod.HEAD Then
		      If doc.Modified.TotalSeconds < clientrequest.IfModifiedSince.TotalSeconds Then
		        doc = New HTTPParse.ErrorResponse(304, "")
		        doc.MessageBody = ""
		      End If
		    Else
		      If doc.Modified.TotalSeconds < clientrequest.IfModifiedSince.TotalSeconds Then
		        doc = New HTTPParse.ErrorResponse(412, "") 'Precondition failed
		        doc.MessageBody = ""
		      End If
		    End If
		  End If
		  
		  If EnforceContentType Then
		    Me.Log("Checking Accepts", Log_Debug)
		    For i As Integer = 0 To UBound(clientrequest.Headers.AcceptableTypes)
		      If clientrequest.Headers.AcceptableTypes(i).Accepts(doc.MIMEType) Then
		        Me.Log("Response is a Acceptable", Log_Debug)
		        SendResponse(Sender, doc)
		        Return
		      End If
		    Next
		    Dim accepted As HTTPParse.ContentType = doc.MIMEType
		    doc = New HTTPParse.ErrorResponse(406, "") 'Not Acceptable
		    doc.MIMEType = accepted
		    Me.Log("Response is not Acceptable", Log_Error)
		  End If
		  SendResponse(Sender, doc)
		  
		  
		  
		Exception Err
		  If Err IsA EndException Or Err IsA ThreadEndException Then Raise Err
		  'Return an HTTP 500 Internal Server Error page.
		  Dim errpage As HTTPParse.Response
		  Dim stack As String
		  #If DebugBuild Then
		    If UBound(Err.Stack) <= -1 Then
		      stack = "<br />(empty)<br />"
		    Else
		      stack = Join(Err.Stack, "<br />")
		    End If
		    stack = "<b>Exception<b>: " + Introspection.GetType(Err).FullName + "<br />Error Number: " + Str(Err.ErrorNumber) + "<br />Message: " + Err.Message _
		    + "<br />Stack follows:<blockquote>" + stack + "</blockquote>" + EndOfLine
		    Dim logtxt As String = "Exception: " + Introspection.GetType(Err).FullName + EndOfLine + "Error Number: " + Str(Err.ErrorNumber) + EndOfLine + "Message: " + Err.Message _
		    + EndOfLine + "Stack follows:" + EndOfLine + Join(Err.Stack, EndOfLine)
		    Me.Log(logtxt , Log_Error)
		  #endif
		  errpage = New HTTPParse.ErrorResponse(500, stack)
		  
		  Me.SendResponse(Sender, errpage)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetCache(Sender As HTTP.Session, Path As String) As HTTPParse.Response
		  Dim logID As String = "(NO_SESSION)"
		  If UseSessions Then logID = "(" + Sender.SessionID + ")"
		  Me.Log(CurrentMethodName + logID, Log_Trace)
		  If UseSessions Then
		    If GetSession(Sender.SessionID).GetCacheItem(Path) <> Nil Then
		      Me.Log("(hit!) Get cache item: " + Path, Log_Debug)
		      Return GetSession(Sender.SessionID).GetCacheItem(Path)
		    End If
		  End If
		  Me.Log("(miss!) Get cache item: " + Path, Log_Debug)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetRedirect(Sender As HTTP.Session, Path As String) As HTTPParse.Response
		  Dim logID As String = "(NO_SESSION)"
		  If UseSessions Then logID = "(" + Sender.SessionID + ")"
		  Me.Log(CurrentMethodName + logID, Log_Trace)
		  If UseSessions THen
		    If GetSession(Sender.SessionID).GetRedirect(Path) <> Nil Then
		      Me.Log("(session hit!) Get redirect: " + Path, Log_Debug)
		      Return GetSession(Sender.SessionID).GetRedirect(Path)
		    End If
		  End If
		  
		  If Me.Redirects.HasKey(Path) Then
		    Me.Log("(global hit!) Get redirect: " + Path, Log_Debug)
		    Return Me.Redirects.Value(Path)
		  End If
		  Me.Log("(miss!) Get redirect: " + Path, Log_Debug)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetSession(SessionID As String) As HTTP.Session
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
		Private Function GetSession(Socket As TCPSocket) As HTTP.Session
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

	#tag Method, Flags = &h0
		Sub Listen()
		  Me.Log(CurrentMethodName, Log_Trace)
		  Me.Log("Server now listening...", Log_Socket)
		  Sessions = New Dictionary
		  Super.Listen
		  If Not Redirects.HasKey("/robots.txt") Then
		    Dim doc As New HTTPParse.ErrorResponse(200, "")
		    doc.Path = "/robots.txt"
		    doc.MIMEType = doc.MIMEType.GetType("robots.txt")
		    doc.MessageBody = "User-Agent: *" + CRLF + "Disallow: /" + CRLF + CRLF
		    AddRedirect(doc)
		  End If
		  Sessions = New Dictionary
		  SessionTimer = New Timer
		  AddHandler SessionTimer.Action, AddressOf Me.TimeOutHandler
		  SessionTimer.Period = 5000
		  SessionTimer.Mode = Timer.ModeMultiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Log(Message As String, Type As Integer)
		  RaiseEvent Log(Message.Trim + EndofLine, Type)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveRedirect(HTTPpath As String)
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
		  Sender.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendResponse(Socket As TCPSocket, ResponseDocument As HTTPParse.Response)
		  Dim logID As String = "(NO_SESSION)"
		  If UseSessions Then logID = "(" + GetSession(Socket).SessionID + ")"
		  Me.Log(CurrentMethodName + logID, Log_Trace)
		  Dim tmp As HTTPParse.Response = ResponseDocument
		  If TamperResponse(tmp) Then
		    Me.Log("Outbound tamper.", Log_Debug)
		    ResponseDocument = tmp
		  End If
		  
		  If Not ResponseDocument.FromCache Then
		    #If GZIPAvailable Then
		      ResponseDocument.SetHeader("Content-Encoding", "gzip")
		      Dim gz As String
		      Try
		        Dim size As Integer = ResponseDocument.MessageBody.LenB
		        gz = GZipPage(Replace(ResponseDocument.MessageBody, "%PAGEGZIPSTATUS%", "Compressed with GZip " + GZip.Version))
		        ResponseDocument.MessageBody = gz
		        size = gz.LenB * 100 / size
		        Me.Log("GZipped page to " + Format(size, "##0.0##\%") + " of original", Log_Debug)
		      Catch Error
		        'Just send the uncompressed data
		      End Try
		      ResponseDocument.SetHeader("Content-Length", Str(ResponseDocument.MessageBody.LenB))
		    #else
		      ResponseDocument.MessageBody = Replace(ResponseDocument.MessageBody, "%PAGEGZIPSTATUS%", "No compression.")
		    #endif
		  End If
		  If Me.KeepAlive Then
		    ResponseDocument.SetHeader("Connection", "keep-alive")
		  Else
		    ResponseDocument.SetHeader("Connection", "close")
		  End If
		  If ResponseDocument.Method = RequestMethod.HEAD Then
		    ResponseDocument.SetHeader("Content-Length", Str(ResponseDocument.MessageBody.LenB))
		    ResponseDocument.MessageBody = ""
		  End If
		  If ResponseDocument.StatusCode = 405 Then 'Method not allowed
		    ResponseDocument.SetHeader("Allow", "GET, HEAD, POST, TRACE")
		  End If
		  
		  If UseSessions Then
		    GetSession(Socket).ExtendSession
		    If GetSession(Socket).NewSession Then
		      Me.Log("Set session cookie: " + GetSession(Socket).SessionID, Log_Debug)
		      ResponseDocument.SetCookie("SessionID") = GetSession(Socket).SessionID
		      GetSession(Socket).NewSession = False
		    ElseIf ResponseDocument.HasCookie("SessionID") Then
		      Me.Log("Clear session cookie", Log_Debug)
		      ResponseDocument.RemoveCookie("SessionID")
		    End If
		  End If
		  Me.Log("Sending data", Log_Socket)
		  Me.Log(HTTPReplyString(ResponseDocument.StatusCode) + CRLF + ResponseDocument.ToString(True), Log_Response)
		  
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
		Event Authenticate(ClientRequest As HTTPParse.Request) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event HandleRequest(ClientRequest As HTTPParse.Request) As HTTPParse.Response
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Log(Message As String, Severity As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TamperRequest(ByRef Request As HTTPParse.Request) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TamperResponse(ByRef Response As HTTPParse.Response) As Boolean
	#tag EndHook


	#tag Property, Flags = &h0
		AuthenticationRealm As String = "Restricted Area"
	#tag EndProperty

	#tag Property, Flags = &h0
		AuthenticationRequired As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		CertificateFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		CertificatePassword As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ConnectionType As ConnectionTypes = ConnectionTypes.Insecure
	#tag EndProperty

	#tag Property, Flags = &h0
		EnforceContentType As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepAlive As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRedirects As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSockets As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Me.Log(CurrentMethodName, Log_Trace)
			  If mRedirects = Nil Then mRedirects = New Dictionary
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

	#tag Property, Flags = &h0
		#tag Note
			The number of seconds of inactivity after which the session is deemed inactive. The default is 10 minutes (600 seconds.)
			Actual timeout periods have a resolution of ±5 seconds. Setting this value to <=5 will result in all sessions being
			timedout at the next run of the TimeOutTimer action event.
		#tag EndNote
		SessionTimeout As Integer = 600
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SessionTimer As Timer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mSockets = Nil Then mSockets = New Dictionary
			  return mSockets
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSockets = value
			End Set
		#tag EndSetter
		Protected Sockets As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		UseSessions As Boolean = True
	#tag EndProperty


	#tag Constant, Name = Log_Debug, Type = Double, Dynamic = False, Default = \"-1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Error, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Request, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Response, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Socket, Type = Double, Dynamic = False, Default = \"-2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Log_Trace, Type = Double, Dynamic = False, Default = \"-3", Scope = Public
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
			Group="Behavior"
			Type="String"
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
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepAlive"
			Visible=true
			Group="Behavior"
			Type="Boolean"
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
