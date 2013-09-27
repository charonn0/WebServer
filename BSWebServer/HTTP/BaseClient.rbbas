#tag Class
Protected Class BaseClient
Inherits TCPSocket
	#tag Event
		Sub DataAvailable()
		  Do Until InStr(Me.Lookahead, CRLF + CRLF) = 0
		    Dim raw As String = Me.Read(InStr(Me.Lookahead, CRLF + CRLF) + 3)
		    Dim reply As New HTTP.Response(raw)
		    RaiseEvent HeadersReceived(reply)
		    raw = ""
		    If reply.HasHeader("Content-Length") Then
		      Dim contentlength As Integer = Val(reply.GetHeader("Content-Length"))
		      If contentlength < Me.Lookahead.LenB Then
		        raw = Me.Read(contentlength)
		      Else
		        While raw.LenB < contentlength And Me.BytesAvailable > 0
		          'RaiseEvent ReceiveProgress(Me.Lookahead.LenB, contentlength, Me.LookAhead)
		          raw = raw + Me.ReadAll
		          App.YieldToNextThread
		        Wend
		      End If
		    Else
		      raw = Me.ReadAll
		    End If
		    Reply.MessageBody = raw
		    RaiseEvent Response(reply)
		  Loop
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub SendRequest(HTTPRequest As HTTP.Request, TimeoutSeconds As Integer = - 1)
		  Dim URI As HTTP.URI = HTTPRequest.Path
		  HTTPRequest.SetHeader("Connection") = "close"
		  HTTPRequest.SetHeader("Host") = URI.FQDN
		  Me.Address = URI.FQDN
		  Me.Port = URI.Port
		  
		  If TimeoutSeconds > 0 Then
		    TimeOutTimer = New Timer
		    AddHandler TimeOutTimer.Action, WeakAddressOf Me.TimeOutHandler
		    TimeOutTimer.Period = TimeoutSeconds * 1000
		    TimeOutTimer.Mode = Timer.ModeSingle
		  Else
		    TimeOutTimer = Nil
		  End If
		  
		  Me.Connect
		  
		  Me.Write(HTTPRequest.ToString)
		  Me.Flush
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TimeOutHandler(Sender As Timer)
		  #pragma Unused Sender
		  Me.Disconnect
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event HeadersReceived(HeadersResponse As HTTP.Response)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Response(ServerResponse As HTTP.Response)
	#tag EndHook


	#tag Property, Flags = &h21
		Private TimeOutTimer As Timer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Address"
			Visible=true
			Group="Behavior"
			Type="String"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
