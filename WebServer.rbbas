#tag Class
Protected Class WebServer
Inherits ServerSocket
	#tag Event
		Function AddSocket() As TCPSocket
		  Me.Log("Add socket", -2)
		  Dim sock As New HTTPClientSocket
		  AddHandler sock.DataAvailable, AddressOf Me.DataAvailable
		  AddHandler sock.GetSession, AddressOf Me.GetSessionHandler
		  Return sock
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddRedirect(Page As HTTPResponse)
		  Me.Log("Add redirect for " + page.Path, -2)
		  Redirects.Value(Page.Path) = Page
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DataAvailable(Sender As HTTPClientSocket)
		  Me.Log("Request received", -2)
		  Dim data As MemoryBlock = Sender.ReadAll
		  Dim clientrequest As HTTPRequest
		  Dim doc As HTTPResponse
		  Try
		    clientrequest = New HTTPRequest(data, AuthenticationRealm, DigestAuthenticationOnly)
		    Me.Log("Request is well formed", -2)
		    If clientrequest.Headers.HasHeader("Connection") Then
		      'Me.KeepAlive = (clientrequest.Headers.GetHeader("Connection") = "keep-alive")
		    End If
		    If UseSessions Then
		      If Not Sender.ValidateSession(clientrequest) Then
		        Me.Log("No valid session", -2)
		        Dim s As HTTPSession = NewSession()
		        clientrequest.SessionID = s.SessionID
		        Sender.SessionID = s.SessionID
		        clientrequest.Headers.SetCookie("SessionID") = s.SessionID
		      End If
		    End If
		    
		    
		    Me.Log(clientrequest.ToString, 0)
		    
		    Dim tmp As HTTPRequest = clientrequest
		    If TamperRequest(tmp) Then
		      clientrequest = tmp
		    End If
		  Catch err As UnsupportedFormatException
		    doc = New HTTPResponse(400, "") 'bad request
		    Me.Log("Request is NOT well formed", -2)
		    GoTo Send
		  End Try
		  
		  If clientrequest.ProtocolVersion < 1.0 Or clientrequest.ProtocolVersion >= 1.2 Then
		    doc = New HTTPResponse(505, Format(ClientRequest.ProtocolVersion, "#.0"))
		    Me.Log("Unsupported protocol version", -2)
		    GoTo Send
		  End If
		  
		  If AuthenticationRequired Then
		    Me.Log("Authenticating", -2)
		    If Not Authenticate(clientrequest) Then
		      Me.Log("Authentication failed", -2)
		      doc = New HTTPResponse(401, clientrequest.Path)
		      If DigestAuthenticationOnly Or clientrequest.AuthDigest Then
		        'digest
		        'Work in progress
		        Dim rand As New Random
		        doc.Headers.SetHeader("WWW-Authenticate", "Digest realm=""" + clientrequest.AuthRealm + """,nonce=""" + Str(Rand.InRange(50000, 100000)) + """")
		      Else 'basic
		        doc.Headers.SetHeader("WWW-Authenticate", "Basic realm=""" + clientrequest.AuthRealm + """")
		        
		      End If
		    End If
		  End If
		  
		  Send:
		  Dim cache As HTTPResponse = GetCache(Sender, clientRequest.Path)
		  Dim redir As HTTPResponse = GetRedirect(Sender, clientrequest.Path)
		  If redir <> Nil Then
		    doc = redir
		    Me.Log("Using redirect.", -2)
		  ElseIf cache <> Nil Then
		    'Cache hit
		    doc = Cache
		    doc.FromCache = True
		    Me.Log("Page from cache", -2)
		    Cache.Expires = New Date
		    Cache.Expires.TotalSeconds = Cache.Expires.TotalSeconds + 60
		  ElseIf doc = Nil Then
		    doc = HandleRequest(clientrequest)
		    If UseSessions And GetSessionHandler(Sender, clientrequest.SessionID) <> Nil Then
		      Dim session As HTTPSession = GetSessionHandler(Sender, clientrequest.SessionID)
		      Session.AddCacheItem(doc)
		    End If
		  End If
		  If doc = Nil Then
		    Me.Log("Running HandleRequest event", -2)
		    doc = HandleRequest(clientrequest)
		  End If
		  If doc = Nil Then
		    Select Case clientrequest.Method
		    Case RequestMethod.TRACE
		      Me.Log("Request is a TRACE", -2)
		      doc = New HTTPResponse(200, "")
		      doc.Headers.SetHeader("Content-Length", Str(Data.Size))
		      doc.Headers.SetHeader("Content-Type", "message/http")
		      doc.MessageBody = Data
		    Case RequestMethod.OPTIONS
		      Me.Log("Request is a OPTIONS", -2)
		      doc = New HTTPResponse(200, "")
		      doc.MessageBody = ""
		      doc.Headers.SetHeader("Content-Length", "0")
		      doc.Headers.SetHeader("Allow", "GET, HEAD, POST, TRACE, OPTIONS")
		      doc.Headers.SetHeader("Accept-Ranges", "bytes")
		    Case RequestMethod.GET, RequestMethod.HEAD
		      Me.Log("Request is a HEAD", -2)
		      doc = New HTTPResponse(404, clientrequest.Path)
		    Else
		      If clientrequest.MethodName <> "" And clientrequest.Method = RequestMethod.InvalidMethod Then
		        doc = New HTTPResponse(501, clientrequest.MethodName) 'Not implemented
		        Me.Log("Request is not implemented", -2)
		      ElseIf clientrequest.MethodName = "" Then
		        doc = New HTTPResponse(400, "") 'bad request
		        Me.Log("Request is malformed", -2)
		      ElseIf clientrequest.MethodName <> "" Then
		        doc = New HTTPResponse(405, clientrequest.MethodName)
		        Me.Log("Request is a NOT ALLOWED", -2)
		      End If
		    End Select
		  End If
		  
		  If EnforceContentType Then
		    Me.Log("Checking Accepts", -2)
		    For i As Integer = 0 To UBound(clientrequest.Headers.AcceptableTypes)
		      If clientrequest.Headers.AcceptableTypes(i).Accepts(doc.MIMEType) Then
		        Me.Log("Response is a Acceptable", -2)
		        SendResponse(Sender, doc)
		        Return
		      End If
		    Next
		    Dim accepted As ContentType = doc.MIMEType
		    doc = New HTTPResponse(406, "") 'Not Acceptable
		    doc.MIMEType = accepted
		    Me.Log("Response is not Acceptable", -2)
		  End If
		  SendResponse(Sender, doc)
		  
		  
		  
		Exception Err
		  Me.Log("EXCEPTION", -2)
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
		  Me.Log("Get cache item: " + Path, -2)
		  Dim session As HTTPSession = GetSessionHandler(Sender, Sender.SessionID)
		  If session.GetCacheItem(Path) <> Nil Then
		    Return session.GetCacheItem(Path)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetRedirect(Sender As HTTPClientSocket, Path As String) As HTTPResponse
		  Me.Log("Get redirect: " + Path, -2)
		  Dim session As HTTPSession = GetSessionHandler(Sender, Sender.SessionID)
		  If session.GetRedirect(Path) <> Nil Then
		    Return session.GetRedirect(Path)
		  End If
		  
		  If Me.Redirects.HasKey(Path) Then
		    Return Me.Redirects.Value(Path)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetSessionHandler(Sender As HTTPClientSocket, ID As String) As HTTPSession
		  #pragma Unused Sender
		  Me.Log("Get session: " + ID, -2)
		  If Sessions.HasKey(ID) Then
		    Return Sessions.Value(ID)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Log(Message As String, Severity As Integer)
		  RaiseEvent Log(Message.Trim + EndofLine, Severity)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NewSession() As HTTPSession
		  Dim s As New HTTPSession
		  s.NewSession = True
		  Sessions.Value(s.SessionID) = s
		  Me.Log("Session created: " + s.SessionID, -2)
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveRedirect(HTTPpath As String)
		  Me.Log("Remove redirect: " + HTTPPath, -2)
		  If Redirects.HasKey(HTTPpath) Then
		    Redirects.Remove(HTTPpath)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendResponse(Socket As HTTPClientSocket, ResponseDocument As HTTPResponse)
		  Dim tmp As HTTPResponse = ResponseDocument
		  If TamperResponse(tmp) Then
		    Me.Log("Outbound tamper.", -2)
		    ResponseDocument = tmp
		  End If
		  
		  If Not ResponseDocument.FromCache Then
		    #If GZIPAvailable Then
		      Me.Log("Running gzip", -2)
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
		    Me.Log("Set keep-alive", -2)
		  Else
		    ResponseDocument.Headers.SetHeader("Connection", "close")
		    Me.Log("Set keep-alive=FALSE", -2)
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
		      Me.Log("Set session cookie: " + Session.SessionID, -2)
		      ResponseDocument.Headers.SetCookie("SessionID") = session.SessionID
		    ElseIf ResponseDocument.Headers.HasCookie("SessionID") Then
		      Me.Log("Clear session cookie", -2)
		      ResponseDocument.Headers.RemoveCookie("SessionID")
		    End If
		  End If
		  
		  Me.Log(HTTPReplyString(ResponseDocument.StatusCode) + CRLF + ResponseDocument.Headers.Source(True), 0)
		  
		  Socket.Write(ResponseDocument.ToString)
		  Socket.Flush
		  If ResponseDocument.Headers.GetHeader("Connection") = "close" Then Socket.Close
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TimeOutHandler(Sender As Timer)
		  #pragma Unused Sender
		  Dim d As New Date
		  For Each Id As String In Sessions.Keys
		    Dim session As HTTPSession = Me.Sessions.Value(Id)
		    If session.LastActivity.TotalSeconds + Me.SessionTimeout < d.TotalSeconds Then
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
		AuthenticationRealm As String = """Restricted Area"""
	#tag EndProperty

	#tag Property, Flags = &h0
		AuthenticationRequired As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		DigestAuthenticationOnly As Boolean = False
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

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mRedirects = Nil Then mRedirects = New Dictionary
			  return mRedirects
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mRedirects = value
			End Set
		#tag EndSetter
		Protected Redirects As Dictionary
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mSessions = Nil Then mSessions = New Dictionary
			  return mSessions
			End Get
		#tag EndGetter
		#tag Setter
			Set
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

	#tag Property, Flags = &h0
		UseSessions As Boolean = True
	#tag EndProperty


	#tag Constant, Name = DaemonVersion, Type = String, Dynamic = False, Default = \"QnDHTTPd/1.0", Scope = Public
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
			Name="DigestAuthenticationOnly"
			Group="Behavior"
			InitialValue="False"
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
