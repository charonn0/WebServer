#tag Class
Protected Class Response
Inherits HTTPParse.HTTPMessage
	#tag Method, Flags = &h1000
		Sub Constructor(Length As Integer, Type As HTTPParse.ContentType)
		  Me.SetHeader("Content-Type", Type.ToString)
		  Me.SetHeader("Content-Length", Str(Length))
		  Me.SetHeader("Server", HTTP.DaemonVersion)
		  Me.SetHeader("Content-Encoding", "Identity")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Data As String, AuthRealm As String, RequireDigestAuth As Boolean)
		  Dim body As Integer = InStr(data, CRLF + CRLF)
		  Me.MessageBody = Right(data, data.Len - body)
		  'NthField(data, CRLF + CRLF, 2)
		  data = Replace(data, Me.MessageBody, "").Trim
		  Dim line As String
		  line = NthField(data, CRLF, 1)
		  data = Replace(data, line + CRLF, "")
		  data = Replace(data, Me.MessageBody, "")
		  Me.Headers = New HTTPParse.Headers(data)
		  Me.Method = HTTPParse.HTTPMethod(NthField(line, " ", 1).Trim)
		  If Me.Method = RequestMethod.InvalidMethod Then mTrueMethodName = NthField(line, " ", 1).Trim
		  Me.ProtocolVersion = CDbl(Replace(NthField(line, " ", 1).Trim, "HTTP/", ""))
		  Me.StatusCode = Val(NthField(line, " ", 2))
		  Me.StatusMessage = HTTPCodeToMessage(Me.StatusCode)
		  Me.AuthRealm = AuthRealm
		  Me.AuthSecure = RequireDigestAuth
		  'If Me.GetHeader("Content-Encoding") = "gzip" Then
		  'Me.GZipped = True
		  '#If GZIPAvailable Then
		  'Me.MessageBody = GunZipPage(Me.MessageBody)
		  'Break
		  '#endif
		  'End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MethodName() As String
		  Select Case Me.Method
		  Case RequestMethod.GET
		    Return "GET"
		    
		  Case RequestMethod.DELETE
		    Return "DELETE"
		    
		  Case RequestMethod.HEAD
		    Return "HEAD"
		    
		  Case RequestMethod.POST
		    Return "POST"
		    
		  Case RequestMethod.PUT
		    Return "PUT"
		    
		  Case RequestMethod.TRACE
		    Return "TRACE"
		    
		  Case RequestMethod.OPTIONS
		    Return "OPTIONS"
		    
		  Else
		    Return mTrueMethodName
		  End Select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return HTTPReplyString(Me.StatusCode) + CRLF + Super.ToString
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Expires As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		FromCache As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		GZipped As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMethod
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mMethod = value
			  
			  Select Case Me.Method
			  Case RequestMethod.GET
			    mTrueMethodName = "GET"
			    
			  Case RequestMethod.DELETE
			    mTrueMethodName = "DELETE"
			    
			  Case RequestMethod.HEAD
			    mTrueMethodName = "HEAD"
			    
			  Case RequestMethod.POST
			    mTrueMethodName = "POST"
			    
			  Case RequestMethod.PUT
			    mTrueMethodName = "PUT"
			    
			  Case RequestMethod.TRACE
			    mTrueMethodName = "TRACE"
			    
			  Case RequestMethod.OPTIONS
			    mTrueMethodName = "OPTIONS"
			    
			  End Select
			  
			  
			End Set
		#tag EndSetter
		Method As RequestMethod
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mMethod As RequestMethod
	#tag EndProperty

	#tag Property, Flags = &h0
		Modified As Date
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTrueMethodName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		StatusCode As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		StatusMessage As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AuthRealm"
			Group="Behavior"
			Type="String"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthSecure"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthUsername"
			Group="Behavior"
			Type="String"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FromCache"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="GZipped"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MessageBody"
			Group="Behavior"
			Type="String"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ProtocolVersion"
			Group="Behavior"
			Type="Single"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionID"
			Group="Behavior"
			Type="String"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StatusCode"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StatusMessage"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
