#tag Class
Protected Class WebServer
Inherits ServerSocket
	#tag Event
		Function AddSocket() As TCPSocket
		  Dim sock As New HTTPSession
		  AddHandler sock.DataAvailable, AddressOf Me.DataAvailable
		  If UseSessions Then
		    Sessions.Value(sock.SessionID) = sock
		    If Me.SessionTimer = Nil Then
		      Me.SessionTimer = New Timer
		      Me.SessionTimer = New Timer
		      Me.SessionTimer.Period = Me.SessionTimeout
		      AddHandler Me.SessionTimer.Action, AddressOf TimeOutHandler
		      Me.SessionTimer.Mode = Timer.ModeMultiple
		    End If
		  End If
		  Return sock
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddRedirect(Page As HTTPResponse)
		  Redirects.Value(Page.Path) = Page
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DataAvailable(Sender As HTTPSession)
		  Dim data As MemoryBlock = Sender.ReadAll
		  Dim clientrequest As HTTPRequest
		  Dim doc As HTTPResponse
		  Try
		    clientrequest = New HTTPRequest(data, AuthenticationRealm, DigestAuthenticationOnly)
		    If clientrequest.Headers.HasHeader("Connection") Then
		      'Me.KeepAlive = (clientrequest.Headers.GetHeader("Connection") = "keep-alive")
		    End If
		    If UseSessions Then
		      If Not Sessions.HasKey(Sender.SessionID) Then
		        Sender.NewSession = true
		        Me.Sessions.Value(Sender.SessionID) = Sender
		        AddHandler Sender.CheckRedirect, AddressOf Me.GetRedirectHandler
		      End If
		    End If
		    
		    
		    Me.Log(ClientRequest.MethodName + " " + ClientRequest.Path + " " + "HTTP/" + Format(ClientRequest.ProtocolVersion, "#.0"), 0)
		    Me.Log(ClientRequest.Headers.Source, -1)
		    
		    Dim tmp As HTTPRequest = clientrequest
		    If TamperRequest(tmp) Then
		      clientrequest = tmp
		    End If
		  Catch err As UnsupportedFormatException
		    doc = New HTTPResponse(400, "") 'bad request
		    GoTo Send
		  End Try
		  
		  If clientrequest.ProtocolVersion < 1.0 Or clientrequest.ProtocolVersion >= 1.2 Then
		    doc = New HTTPResponse(505, Format(ClientRequest.ProtocolVersion, "#.0"))
		    GoTo Send
		  End If
		  
		  If AuthenticationRequired Then
		    If Not Authenticate(clientrequest) Then
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
		  Dim cache As HTTPResponse = Sender.GetCacheItem(ClientRequest.Path)
		  Dim redir As HTTPResponse = Sender.GetRedirect(clientrequest.Path)
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
		    If UseSessions Then Sender.AddCacheItem(doc)
		  End If
		  If doc = Nil Then
		    doc = HandleRequest(clientrequest)
		  End If
		  If doc = Nil Then
		    Select Case clientrequest.Method
		    Case RequestMethod.TRACE
		      doc = New HTTPResponse(200, "")
		      doc.Headers.SetHeader("Content-Length", Str(Data.Size))
		      doc.Headers.SetHeader("Content-Type", "message/http")
		      doc.MessageBody = Data
		    Case RequestMethod.OPTIONS
		      doc = New HTTPResponse(200, "")
		      doc.MessageBody = ""
		      doc.Headers.SetHeader("Content-Length", "0")
		      doc.Headers.SetHeader("Allow", "GET, HEAD, POST, TRACE, OPTIONS")
		      doc.Headers.SetHeader("Accept-Ranges", "bytes")
		    Case RequestMethod.GET, RequestMethod.HEAD
		      doc = New HTTPResponse(404, clientrequest.Path)
		    Else
		      If clientrequest.MethodName <> "" And clientrequest.Method = RequestMethod.InvalidMethod Then
		        doc = New HTTPResponse(501, clientrequest.MethodName) 'Not implemented
		      ElseIf clientrequest.MethodName = "" Then
		        doc = New HTTPResponse(400, "") 'bad request
		      ElseIf clientrequest.MethodName <> "" Then
		        doc = New HTTPResponse(405, clientrequest.MethodName)
		      End If
		    End Select
		  End If
		  
		  If EnforceContentType Then
		    For i As Integer = 0 To UBound(clientrequest.Headers.AcceptableTypes)
		      If clientrequest.Headers.AcceptableTypes(i).Accepts(doc.MIMEType) Then
		        SendResponse(Sender, doc)
		        Return
		      End If
		    Next
		    Dim accepted As ContentType = doc.MIMEType
		    doc = New HTTPResponse(406, "") 'Not Acceptable
		    doc.MIMEType = accepted
		  End If
		  SendResponse(Sender, doc)
		  
		  
		  
		Exception Err
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
		Private Function GetRedirectHandler(Sender As HTTPSession, Path As String) As HTTPResponse
		  #pragma Unused Sender
		  If Me.Redirects.HasKey(Path) Then
		    Return Me.Redirects.Value(Path)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Log(Message As String, Severity As Integer)
		  RaiseEvent Log(Message.Trim + EndofLine, Severity)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveItem(HTTPpath As String)
		  If Redirects.HasKey(HTTPpath) Then
		    Redirects.Remove(HTTPpath)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendResponse(Socket As HTTPSession, ResponseDocument As HTTPResponse)
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
		  Else
		    ResponseDocument.Headers.SetHeader("Connection", "close")
		  End If
		  If ResponseDocument.Method = RequestMethod.HEAD Then
		    ResponseDocument.Headers.SetHeader("Content-Length", Str(ResponseDocument.MessageBody.LenB))
		    ResponseDocument.MessageBody = ""
		  End If
		  Me.Log(HTTPReplyString(ResponseDocument.StatusCode), 0)
		  Me.Log(ResponseDocument.Headers.Source(True), -1)
		  If ResponseDocument.StatusCode = 405 Then 'Method not allowed
		    ResponseDocument.Headers.SetHeader("Allow", "GET, HEAD, POST, TRACE")
		  End If
		  
		  If UseSessions Then
		    Socket.ExtendSession
		    If Socket.NewSession Then
		      Dim c As New HTTPCookie("SessionID=" + Socket.SessionID)
		      ResponseDocument.SetCookie(c)
		      Socket.NewSession = False
		    Else
		      ResponseDocument.RemoveCookie("SessionID")
		    End If
		  End If
		  
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
		      session.Close
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
	#tag EndViewBehavior
End Class
#tag EndClass
