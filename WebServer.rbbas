#tag Class
Protected Class WebServer
Inherits ServerSocket
Implements  StoredItem
	#tag Event
		Function AddSocket() As TCPSocket
		  Dim sock As New TCPSocket
		  AddHandler sock.DataAvailable, AddressOf Me.DataAvailable
		  If Me.SessionTimer = Nil Then
		    Me.SessionTimer = New Timer
		    Me.SessionTimer = New Timer
		    Me.SessionTimer.Period = 6000
		    AddHandler Me.SessionTimer.Action, AddressOf TimeOutHandler
		    Me.SessionTimer.Mode = Timer.ModeMultiple
		  End If
		  Return sock
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddItem(Page As HTTPResponse)
		  Redirects.Value(Page.Path) = Page
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CacheCleaner(Sender As Timer)
		  #pragma Unused Sender
		  For Each Path As String In PageCache.Keys
		    Dim doc As HTTPResponse = PageCache.Value(Path)
		    Dim d As New Date
		    If doc.Expires.TotalSeconds < d.TotalSeconds Then
		      PageCache.Remove(Path)
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DataAvailable(Sender As TCPSocket)
		  Dim data As MemoryBlock = Sender.ReadAll
		  Dim clientrequest As HTTPRequest
		  Dim doc As HTTPResponse
		  Try
		    clientrequest = New HTTPRequest(data, AuthenticationRealm, DigestAuthenticationOnly)
		    If clientrequest.Headers.GetCookie("SessionID") <> Nil Then
		      Dim session As String = clientrequest.Headers.GetCookie("SessionID").Value
		      If Me.Sessions.HasKey(session) Then
		        Dim s As SessionInterface = Me.Sessions.Value(session)
		        clientrequest.Session = s
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
		  
		  If Redirects.HasKey(clientrequest.Path) And doc = Nil Then
		    doc = Redirects.Value(clientrequest.Path)
		    doc.FromCache = True
		    Me.Log("Using redirect.", -2)
		  End If
		  
		  If clientrequest.Session = Nil Then
		    Dim s As New HTTPSession
		    Me.Sessions.Value(s.SessionID) = s
		    clientrequest.Session = s
		  End If
		  
		  
		  
		  Send:
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
		  
		  doc.Session = clientrequest.Session
		  If clientrequest.GetCookie("SessionID") = Nil Then
		    doc.Headers.SetCookie(New HTTPCookie("SessionID=" + doc.Session.ID))
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

	#tag Method, Flags = &h0
		Function GetItem(Path As String, Alternate As Boolean = False) As HTTPResponse
		  If Alternate Then 'Use Cache
		    If Me.PageCache.HasKey(Path) Then
		      Return Me.PageCache.Value(Path)
		    End If
		  Else 'use redirects
		    If Me.Redirects.HasKey(Path) Then
		      Return Me.Redirects.Value(Path)
		    End If
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetSessionHandler(Sender As HTTPRequest, SessionID As String) As HTTPSession
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ID() As String
		  Return ""
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
		Private Sub SendResponse(Socket As TCPSocket, ResponseDocument As HTTPResponse)
		  Dim tmp As HTTPResponse = ResponseDocument
		  If TamperResponse(tmp) Then
		    Me.Log("Outbound tamper.", -2)
		    ResponseDocument  = tmp
		  End If
		  If UseCache Then PageCache.Value(ResponseDocument.Path) = ResponseDocument
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
		    If Me.KeepAlive And ResponseDocument.Headers.GetHeader("Connection") = "keep-alive" Then
		      ResponseDocument.Headers.SetHeader("Connection", "keep-alive")
		    Else
		      ResponseDocument.Headers.SetHeader("Connection", "close")
		    End If
		    
		  End If
		  If ResponseDocument.Method = RequestMethod.HEAD Then
		    ResponseDocument.Headers.SetHeader("Content-Length", Str(ResponseDocument.MessageBody.LenB))
		    ResponseDocument.MessageBody = ""
		    If PageCache.HasKey(ResponseDocument.Path) Then PageCache.Remove(ResponseDocument.Path)
		  End If
		  Me.Log(HTTPReplyString(ResponseDocument.StatusCode), 0)
		  Me.Log(ResponseDocument.Headers.Source(True), -1)
		  If ResponseDocument.StatusCode = 405 Then 'Method not allowed
		    ResponseDocument.Headers.SetHeader("Allow", "GET, HEAD, POST, TRACE")
		  End If
		  
		  If ResponseDocument.Session <> Nil Then
		    ResponseDocument.Session.ResetTimeout
		  End If
		  
		  Socket.Write(ResponseDocument.ToString)
		  Socket.Flush
		  If ResponseDocument.Headers.GetHeader("Connection") = "close" Then Socket.Close
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TimeOutHandler(Sender As Timer)
		  #pragma Unused Sender
		  For Each Id As String In Sessions.Keys
		    Dim session As HTTPSession = Me.Sessions.Value(Id)
		    If session.TimedOut Then
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

	#tag Property, Flags = &h21
		Private CacheTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		DigestAuthenticationOnly As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepAlive As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRedirects As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSessions As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUseCache As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mPageCache = Nil Then mPageCache = New Dictionary
			  return mPageCache
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mPageCache = value
			End Set
		#tag EndSetter
		Protected PageCache As Dictionary
	#tag EndComputedProperty

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

	#tag Property, Flags = &h21
		Private SessionTimer As Timer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mUseCache 'And Not GZIPAvailable
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value Then
			    CacheTimer = New Timer
			    CacheTimer.Period = 10000
			    AddHandler CacheTimer.Action, AddressOf CacheCleaner
			    CacheTimer.Mode = Timer.ModeMultiple
			  Else
			    CacheTimer = Nil
			  End If
			  mUseCache = value
			End Set
		#tag EndSetter
		UseCache As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = DaemonVersion, Type = String, Dynamic = False, Default = \"QnDHTTPd/1.0", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AuthenticationRealm"
			Group="Behavior"
			InitialValue="""""Restricted Area"""""
			Type="String"
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
			Name="Index"
			Visible=true
			Group="ID"
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
		#tag ViewProperty
			Name="UseCache"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
