#tag Class
Protected Class ClientSocket
Inherits TCPSocket
	#tag Method, Flags = &h0
		Function ValidateSession(Request As HTTPParse.Request) As Boolean
		  Log(CurrentMethodName, Server.Log_Trace)
		  Dim s As HTTP.Session = GetSession(Request.SessionID)
		  If s = Nil Then Return False
		  If s.SessionID = Request.SessionID Then
		    Log("Validatated session: " + s.SessionID, Server.Log_Debug)
		    Me.SessionID = Request.SessionID
		    s.NewSession = False
		    Return True
		  End If
		  
		Exception
		  Return False
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event GetSession(ID As String) As HTTP.Session
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Log(Message As String, Level As Integer)
	#tag EndHook


	#tag Property, Flags = &h21
		Private mSessionID As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Log(CurrentMethodName, Server.Log_Trace)
			  If mSessionID = "" Then
			    Log("Generate new SessionID", Server.Log_Debug)
			    Dim s As HTTP.Session = GetSession("")
			    If s <> Nil Then
			      mSessionID = s.SessionID
			    End If
			  End If
			  
			  return mSessionID
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSessionID = value
			End Set
		#tag EndSetter
		SessionID As String
	#tag EndComputedProperty


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
			Name="SessionID"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
