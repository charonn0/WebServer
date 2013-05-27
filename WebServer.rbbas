#tag Class
Protected Class WebServer
Inherits ServerSocket
	#tag Event
		Function AddSocket() As TCPSocket
		  Me.Log(CurrentMethodName, Log_Trace)
		  'Me.Log("Add socket " + Str(Me.ActiveConnections.UBound + 1), Log_Socket)
		  Dim sock As New HTTPClientSocket
		  AddHandler sock.DataAvailable, AddressOf Me.DataAvailable
		  AddHandler sock.GetSession, AddressOf Me.GetSessionHandler
		  AddHandler sock.Error, AddressOf Me.ClientErrorHandler
		  AddHandler sock.Log, AddressOf Me.ClientLogHandler
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
		Sub AddRedirect(Page As HTTPResponse)
		  Me.Log(CurrentMethodName, Log_Trace)
		  Me.Log("Add redirect for " + page.Path, Log_Debug)
		  Redirects.Value(Page.Path) = Page
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClientErrorHandler(Sender As HTTPClientSocket)
		  Me.Log(SocketErrorMessage(Sender.LastErrorCode), Log_Socket)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClientLogHandler(Sender As HTTPClientSocket, Message As String, Level As Integer)
		  #pragma Unused Sender
		  Me.Log(Message, Level)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DataAvailable(Sender As HTTPClientSocket)
		  Me.Log(CurrentMethodName, Log_Trace)
		  Me.Log("Incoming data", Log_Socket)
		  Dim data As MemoryBlock = Sender.ReadAll
		  Dim clientrequest As HTTPRequest
		  Dim doc As HTTPResponse
		  Try
		    clientrequest = New HTTPRequest(data, UseSessions)
		    Me.Log("Request is well formed", Log_Debug)
		    If clientrequest.Headers.HasHeader("Connection") Then
		      'Me.KeepAlive = (clientrequest.Headers.GetHeader("Connection") = "keep-alive")
		    End If
		    Me.Log(URLDecode(clientrequest.ToString), Log_Request)
		    If UseSessions Then
		      If Not Sender.ValidateSession(clientrequest) Then
		        Me.Log("No valid session", Log_Debug)
		        Dim s As HTTPSession = NewSession()
		        clientrequest.SessionID = s.SessionID
		        Sender.SessionID = s.SessionID
		        clientrequest.Headers.SetCookie("SessionID") = s.SessionID
		      End If
		    End If
		    
		    
		    
		    Dim tmp As HTTPRequest = clientrequest
		    If TamperRequest(tmp) Then
		      clientrequest = tmp
		    End If
		    
		    If clientrequest.ProtocolVersion < 1.0 Or clientrequest.ProtocolVersion >= 1.2 Then
		      doc = New HTTPResponse(505, Format(ClientRequest.ProtocolVersion, "#.0"))
		      Me.Log("Unsupported protocol version", Log_Error)
		    ElseIf AuthenticationRequired Then
		      Me.Log("Authenticating", Log_Debug)
		      If Not Authenticate(clientrequest) Then
		        Me.Log("Authentication failed", Log_Error)
		        doc = New HTTPResponse(401, clientrequest.Path)
		        doc.Headers.SetHeader("WWW-Authenticate", "Basic realm=""" + clientrequest.AuthRealm + """")
		      Else
		        Me.Log("Authentication Successful", Log_Debug)
		      End If
		    End If
		  Catch err As UnsupportedFormatException
		    doc = New HTTPResponse(400, "") 'bad request
		    Me.Log("Request is NOT well formed", Log_Error)
		  End Try
		  
		  If UseSessions Then
		    Dim cache As HTTPResponse
		    If clientrequest.CacheDirective <> "" Then
		      Select Case clientrequest.CacheDirective
		      Case "no-cache", "max-age=0"
		        Me.Log("Cache control override: " + clientrequest.CacheDirective, Log_Debug)
		        cache = Nil
		      End Select
		    Else
		      cache = GetCache(Sender, clientRequest.Path)
		    End If
		    Dim redir As HTTPResponse = GetRedirect(Sender, clientrequest.Path)
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
		      If UseSessions And GetSessionHandler(Sender, clientrequest.SessionID) <> Nil And clientrequest.CacheDirective <> "no-store" Then
		        Dim session As HTTPSession = GetSessionHandler(Sender, clientrequest.SessionID)
		        Session.AddCacheItem(doc)
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
		      doc = New HTTPResponse(200, "")
		      doc.Headers.SetHeader("Content-Length", Str(Data.Size))
		      doc.Headers.SetHeader("Content-Type", "message/http")
		      doc.MessageBody = Data
		    Case RequestMethod.OPTIONS
		      Me.Log("Request is a OPTIONS", Log_Debug)
		      doc = New HTTPResponse(200, "")
		      doc.MessageBody = ""
		      doc.Headers.SetHeader("Content-Length", "0")
		      doc.Headers.SetHeader("Allow", "GET, HEAD, POST, TRACE, OPTIONS")
		      doc.Headers.SetHeader("Accept-Ranges", "bytes")
		    Case RequestMethod.GET, RequestMethod.HEAD
		      Me.Log("Request is a HEAD", Log_Debug)
		      doc = New HTTPResponse(404, clientrequest.Path)
		    Else
		      If clientrequest.MethodName <> "" And clientrequest.Method = RequestMethod.InvalidMethod Then
		        doc = New HTTPResponse(501, clientrequest.MethodName) 'Not implemented
		        Me.Log("Request is not implemented", Log_Error)
		      ElseIf clientrequest.MethodName = "" Then
		        doc = New HTTPResponse(400, "") 'bad request
		        Me.Log("Request is malformed", Log_Error)
		      ElseIf clientrequest.MethodName <> "" Then
		        doc = New HTTPResponse(405, clientrequest.MethodName)
		        Me.Log("Request is a NOT ALLOWED", Log_Error)
		      End If
		    End Select
		  End If
		  
		  If clientrequest.IfModifiedSince <> Nil And doc.Modified <> Nil Then
		    If clientrequest.Method = RequestMethod.GET Or clientrequest.Method = RequestMethod.HEAD Then
		      If doc.Modified.TotalSeconds < clientrequest.IfModifiedSince.TotalSeconds Then
		        doc = New HTTPResponse(304, "")
		        doc.MessageBody = ""
		      End If
		    Else
		      If doc.Modified.TotalSeconds < clientrequest.IfModifiedSince.TotalSeconds Then
		        doc = New HTTPResponse(412, "") 'Precondition failed
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
		    Dim accepted As ContentType = doc.MIMEType
		    doc = New HTTPResponse(406, "") 'Not Acceptable
		    doc.MIMEType = accepted
		    Me.Log("Response is not Acceptable", Log_Error)
		  End If
		  SendResponse(Sender, doc)
		  
		  
		  
		Exception Err
		  Me.Log("EXCEPTION", Log_Error)
		  If Err IsA EndException Or Err IsA ThreadEndException Then Raise Err
		  'Return an HTTP 500 Internal Server Error page.
		  Dim errpage As HTTPResponse
		  Dim stack As String
		  #If DebugBuild Then
		    If UBound(Err.Stack) <= -1 Then
		      stack = "<br />(empty)<br />"
		    Else
		      stack = Join(Err.Stack, "<br />")
		    End If
		    stack = "<b>Exception<b>: " + Introspection.GetType(Err).FullName + "<br />Error Number: " + Str(Err.ErrorNumber) + "<br />Message: " + Err.Message _
		    + "<br />Stack follows:<blockquote>" + stack + "</blockquote>" + EndOfLine
		  #endif
		  errpage = New HTTPResponse(500, stack)
		  
		  Me.SendResponse(Sender, errpage)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetCache(Sender As HTTPClientSocket, Path As String) As HTTPResponse
		  Dim logID As String = "(NO_SESSION)"
		  If UseSessions Then logID = "(" + Sender.SessionID + ")"
		  Me.Log(CurrentMethodName + logID, Log_Trace)
		  If UseSessions Then
		    Dim session As HTTPSession = GetSessionHandler(Sender, Sender.SessionID)
		    If session.GetCacheItem(Path) <> Nil Then
		      Me.Log("(hit!) Get cache item: " + Path, Log_Debug)
		      Return session.GetCacheItem(Path)
		    End If
		  End If
		  Me.Log("(miss!) Get cache item: " + Path, Log_Debug)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetRedirect(Sender As HTTPClientSocket, Path As String) As HTTPResponse
		  Dim logID As String = "(NO_SESSION)"
		  If UseSessions Then logID = "(" + Sender.SessionID + ")"
		  Me.Log(CurrentMethodName + logID, Log_Trace)
		  If UseSessions THen
		    Dim session As HTTPSession = GetSessionHandler(Sender, Sender.SessionID)
		    If session.GetRedirect(Path) <> Nil Then
		      Me.Log("(session hit!) Get redirect: " + Path, Log_Debug)
		      Return session.GetRedirect(Path)
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
		Private Function GetSessionHandler(Sender As HTTPClientSocket, ID As String) As HTTPSession
		  Me.Log(CurrentMethodName + "(" + ID + ")", Log_Trace)
		  #pragma Unused Sender
		  If Not UseSessions Then Return Nil
		  If Sessions.HasKey(ID) Then
		    Me.Log("(hit!) Get session: " + ID, Log_Debug)
		    Return Sessions.Value(ID)
		  End If
		  Me.Log("(miss!) Get session: " + ID, Log_Debug)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Listen()
		  Me.Log(CurrentMethodName, Log_Trace)
		  Me.Log("Server now listening...", Log_Socket)
		  Sessions = New Dictionary
		  Super.Listen
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Log(Message As String, Type As Integer)
		  RaiseEvent Log(Message.Trim + EndofLine, Type)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NewSession() As HTTPSession
		  Me.Log(CurrentMethodName, Log_Trace)
		  If UseSessions Then
		    Dim s As New HTTPSession
		    s.NewSession = True
		    Sessions.Value(s.SessionID) = s
		    Me.Log("Session created: " + s.SessionID, Log_Debug)
		    Return s
		  End If
		End Function
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
		Private Sub SendResponse(Socket As HTTPClientSocket, ResponseDocument As HTTPResponse)
		  Dim logID As String = "(NO_SESSION)"
		  If UseSessions Then logID = "(" + Socket.SessionID + ")"
		  Me.Log(CurrentMethodName + logID, Log_Trace)
		  Dim tmp As HTTPResponse = ResponseDocument
		  If TamperResponse(tmp) Then
		    Me.Log("Outbound tamper.", Log_Debug)
		    ResponseDocument = tmp
		  End If
		  
		  If Not ResponseDocument.FromCache Then
		    #If GZIPAvailable Then
		      Me.Log("Running gzip", Log_Debug)
		      ResponseDocument.Headers.SetHeader("Content-Encoding", "gzip")
		      Dim gz As String
		      Try
		        gz = GZipPage(Replace(ResponseDocument.MessageBody, "%PAGEGZIPSTATUS%", "Compressed with GZip " + GZip.Version))
		        ResponseDocument.MessageBody = gz
		      Catch Error
		        'Just send the uncompressed data
		        ResponseDocument.Headers.SetHeader("Content-Encoding", "Identity")
		      End Try
		      ResponseDocument.Headers.SetHeader("Content-Length", Str(ResponseDocument.MessageBody.LenB))
		    #else
		      ResponseDocument.MessageBody = Replace(ResponseDocument.MessageBody, "%PAGEGZIPSTATUS%", "No compression.")
		    #endif
		  End If
		  If Me.KeepAlive Then
		    ResponseDocument.Headers.SetHeader("Connection", "keep-alive")
		  Else
		    ResponseDocument.Headers.SetHeader("Connection", "close")
		  End If
		  If ResponseDocument.Method = RequestMethod.HEAD Then
		    ResponseDocument.Headers.SetHeader("Content-Length", Str(ResponseDocument.MessageBody.LenB))
		    ResponseDocument.MessageBody = ""
		  End If
		  If ResponseDocument.StatusCode = 405 Then 'Method not allowed
		    ResponseDocument.Headers.SetHeader("Allow", "GET, HEAD, POST, TRACE")
		  End If
		  
		  If UseSessions Then
		    Dim session As HTTPSession = GetSessionHandler(Socket, Socket.SessionID)
		    If session <> Nil Then session.ExtendSession
		    If session.NewSession Then
		      Me.Log("Set session cookie: " + Session.SessionID, Log_Debug)
		      ResponseDocument.Headers.SetCookie("SessionID") = session.SessionID
		    ElseIf ResponseDocument.Headers.HasCookie("SessionID") Then
		      Me.Log("Clear session cookie", Log_Debug)
		      ResponseDocument.Headers.RemoveCookie("SessionID")
		    End If
		  End If
		  Me.Log("Sending data", Log_Socket)
		  Me.Log(HTTPReplyString(ResponseDocument.StatusCode) + CRLF + ResponseDocument.Headers.Source(True), Log_Response)
		  
		  Socket.Write(ResponseDocument.ToString)
		  Socket.Flush
		  Me.Log("Send complete", Log_Socket)
		  If ResponseDocument.Headers.GetHeader("Connection") = "close" Then Socket.Close
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
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
		  Me.Log(CurrentMethodName, Log_Trace)
		  Dim d As New Date
		  For Each Id As String In Sessions.Keys
		    Dim session As HTTPSession = Me.Sessions.Value(Id)
		    If session.LastActivity.TotalSeconds + Me.SessionTimeout < d.TotalSeconds Then
		      Me.Log("Session timed out (" + ID + ")", Log_Debug)
		      Me.Sessions.Remove(Id)
		    End If
		  Next
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Authenticate(ClientRequest As HTTPRequest) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event HandleRequest(ClientRequest As HTTPRequest) As HTTPResponse
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Log(Message As String, Severity As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TamperRequest(ByRef HTTPRequest As HTTPRequest) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TamperResponse(ByRef Response As HTTPResponse) As Boolean
	#tag EndHook


	#tag Property, Flags = &h0
		AuthenticationRealm As String = "Restricted Area"
	#tag EndProperty

	#tag Property, Flags = &h0
		AuthenticationRequired As Boolean
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
		Private mSessions As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUseSessions As Boolean = True
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

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Me.Log(CurrentMethodName, Log_Trace)
			  If mSessions = Nil Then
			    mSessions = New Dictionary
			    SessionTimer = New Timer
			    AddHandler SessionTimer.Action, AddressOf Me.TimeOutHandler
			    SessionTimer.Period = 5000
			    SessionTimer.Mode = Timer.ModeMultiple
			  End If
			  return mSessions
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.Log(CurrentMethodName, Log_Trace)
			  mSessions = value
			End Set
		#tag EndSetter
		Protected Sessions As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		SessionTimeout As Integer = 600
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SessionTimer As Timer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Me.Log(CurrentMethodName, Log_Trace)
			  return mUseSessions
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.Log(CurrentMethodName, Log_Trace)
			  mUseSessions = value
			  If IsListening Then
			    StopListening
			    Listen
			  End If
			End Set
		#tag EndSetter
		UseSessions As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = DaemonVersion, Type = String, Dynamic = False, Default = \"BoredomServe/1.0", Scope = Public
	#tag EndConstant

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
			Group="Behavior"
			InitialValue="""""Restricted Area"""""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthenticationRequired"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EnforceContentType"
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
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
