#tag Class
Protected Class Request
Inherits HTTPParse.HTTPMessage
	#tag Method, Flags = &h0
		Function CacheDirective() As String
		  Return Me.GetHeader("Cache-Control")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(UseSessions As Boolean = False)
		  'Construct an empty HTTPParse.Request
		  If Not UseSessions Then Me.SessionID = "NO_SESSION"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Data As String, UseSessions As Boolean = False)
		  Dim line As String
		  line = NthField(data, CRLF, 1)
		  
		  If CountFields(line.Trim, " ") <> 3 Then
		    Dim err As New UnsupportedFormatException
		    Dim mb As MemoryBlock = line
		    If mb.Byte(0) = &h16 And mb.Byte(1) = &h03 Then 'ssl?
		      err.ErrorNumber = 1
		    End If
		    Raise err
		  End If
		  
		  data = Replace(data, line + CRLF, "")
		  Dim h As String = NthField(data, CRLF + CRLF, 1)
		  Me.Headers = New HTTPParse.Headers(h)
		  Me.MessageBody = Replace(data, h, "")
		  
		  If Me.HasHeader("Content-Type") Then
		    Dim type As String = Me.GetHeader("Content-Type")
		    If InStr(type, "multipart/form-data") > 0 Then
		      Dim boundary As String = NthField(type, "boundary=", 2).Trim
		      Me.MultiPart = MultipartForm.FromData(Me.MessageBody, boundary)
		    End If
		  End If
		  
		  If Me.Hascookie("SessionID") Then
		    Me.SessionID = Me.GetCookie("SessionID")
		  End If
		  
		  
		  Me.Method = HTTPParse.HTTPMethod(NthField(line, " ", 1).Trim)
		  If Me.Method = RequestMethod.InvalidMethod Then Me.MethodName = NthField(line, " ", 1).Trim
		  
		  Me.Path = New URI(NthField(line, " ", 2))
		  Me.ProtocolVersion = CDbl(Replace(NthField(line, " ", 3).Trim, "HTTP/", ""))
		  Me.Expires = New Date
		  Me.Expires.TotalSeconds = Me.Expires.TotalSeconds + 60
		  If Me.HasHeader("Authorization") Then
		    Dim pw As String = Me.GetHeader("Authorization")
		    pw = pw.Replace("Basic ", "")
		    pw = DecodeBase64(pw)
		    Me.AuthPassword = NthField(pw, ":", 2)
		    Me.AuthUsername = NthField(pw, ":", 1)
		  End If
		  If Not UseSessions Then Me.SessionID = "NO_SESSION"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsModifiedSince(SinceWhen As Date) As Boolean
		  If HasHeader("If-Modified-Since") Then
		    Dim d1 As Date
		    d1 = HTTPDate(GetHeader("If-Modified-Since"))
		    Return SinceWhen.TotalSeconds > d1.TotalSeconds
		    
		  ElseIf HasHeader("If-Unmodified-Since") Then
		    Dim d1 As Date
		    d1 = HTTPDate(GetHeader("If-Unmodified-Since"))
		    Return SinceWhen.TotalSeconds < d1.TotalSeconds
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim args As String
		  If Me.Path.Arguments.Ubound > -1 Then
		    args = "?" + Join(Me.Path.Arguments, "&")
		  End If
		  Dim data As String = MethodName + " " + URLEncode(Path.LocalPath) + URLEncode(args) + " " + "HTTP/" + Format(ProtocolVersion, "#.0") + CRLF
		  If Me.MultiPart <> Nil Then
		    Me.SetHeader("Content-Type", "multipart/form-data; boundary=" + Me.MultiPart.Boundary)
		    Me.MessageBody = Me.MultiPart.ToString
		    Me.SetHeader("Content-Length", Str(Me.MessageBody.LenB))
		  End If
		  data = data + Super.ToString
		  
		  Return data
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		AuthPassword As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Cookies() As HTTPParse.Cookie
	#tag EndProperty

	#tag Property, Flags = &h0
		Headers As HTTPParse.Headers
	#tag EndProperty

	#tag Property, Flags = &h0
		MultiPart As MultipartForm
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AuthPassword"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
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
