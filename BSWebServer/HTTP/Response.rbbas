#tag Class
Protected Class Response
Inherits HTTP.HTTPMessage
	#tag Method, Flags = &h1000
		Sub Constructor(Raw As String)
		  Dim body As Integer = InStr(raw, CRLF + CRLF)
		  Me.MessageBody = Right(raw, raw.Len - body)
		  raw = Replace(raw, Me.MessageBody, "").Trim
		  Dim line As String
		  line = NthField(raw, CRLF, 1)
		  raw = Replace(raw, line + CRLF, "")
		  raw = Replace(raw, Me.MessageBody, "")
		  Me.Headers = New Headers(raw)
		  Me.Method = HTTP.Method(NthField(line, " ", 1).Trim)
		  If Me.Method = RequestMethod.InvalidMethod Then Me.MethodName = NthField(line, " ", 1).Trim
		  Me.ProtocolVersion = CDbl(Replace(NthField(line, " ", 1).Trim, "HTTP/", ""))
		  Me.StatusCode = Val(NthField(line, " ", 2))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return ReplyString(Me.StatusCode) + CRLF + Super.ToString(False)'
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Compressible As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		StatusCode As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return CodeToMessage(Me.StatusCode)
			End Get
		#tag EndGetter
		StatusMessage As String
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AuthPassword"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTP.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthRealm"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTP.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthUsername"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTP.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compressible"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MessageBody"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTP.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ProtocolVersion"
			Group="Behavior"
			Type="Single"
			InheritedFrom="HTTP.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionID"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTP.HTTPMessage"
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
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
