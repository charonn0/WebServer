#tag Class
Protected Class Response
Inherits HTTPParse.HTTPMessage
	#tag Method, Flags = &h1001
		Protected Sub Constructor(ResponseCode As Integer, Type As ContentType, Method As HTTP.RequestMethod, Body As String = "")
		  Me.StatusCode = ResponseCode
		  Me.MIMEType = Type
		  Me.Method = Method
		  Me.MessageBody = body
		End Sub
	#tag EndMethod

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
		  Me.Method = HTTPParse.HTTPMethod(NthField(line, " ", 1).Trim)
		  If Me.Method = RequestMethod.InvalidMethod Then mTrueMethodName = NthField(line, " ", 1).Trim
		  Me.ProtocolVersion = CDbl(Replace(NthField(line, " ", 1).Trim, "HTTP/", ""))
		  Me.StatusCode = Val(NthField(line, " ", 2))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CopyDoc(CachedPage As HTTP.Response, Path As String) As HTTP.Response
		  'Use this constructor to create a document from another document
		  Dim rply As HTTP.Response = NewResponse("")
		  rply.MessageBody = CachedPage.MessageBody
		  rply.StatusCode = 200
		  rply.Path = Path
		  rply.MIMEType = CachedPage.MIMEType
		  rply.Headers = CachedPage.Headers
		  rply.Expires = CachedPage.Expires
		  
		  Return rply
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ErrorResponse(ErrorCode As Integer, Param As String) As HTTP.Response
		  'Use this constructor to create an error Document with the specified HTTP ErrorCode
		  'Param is an error-dependant datum; e.g. doc = New Document(404, "/doesntexist/file.txt")
		  Dim rply As HTTP.Response = NewResponse("")
		  rply.StatusCode = ErrorCode
		  Dim data As String = ErrorPage(ErrorCode, Param)
		  rply.SetHeader("Content-Length", Str(data.LenB))
		  rply.MIMEType = New ContentType("text/html")
		  rply.StatusCode = ErrorCode
		  rply.MessageBody = data
		  rply.Expires = New Date(1999, 12, 31, 23, 59, 59)
		  Return rply
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function FromFile(page As FolderItem, Path As String) As HTTP.Response
		  'Use this constructor to create a Document from a FolderItem (file or directory)
		  Dim rply As HTTP.Response = NewResponse("")
		  If Not page.Directory Then
		    Dim bs As BinaryStream = BinaryStream.Open(page)
		    rply.MessageBody = bs.Read(bs.Length)
		    bs.Close
		    rply.MIMEType = New ContentType(page)
		  End If
		  rply.SetHeader("Content-Length", Str(rply.MessageBody.LenB))
		  If rply.MIMEType = Nil Then
		    rply.MIMEType = New ContentType("text/html")
		  End If
		  rply.StatusCode = 200
		  rply.Path = Path
		  Dim d As New Date
		  d.TotalSeconds = d.TotalSeconds + 601
		  rply.Expires = d
		  Return rply
		End Function
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

	#tag Method, Flags = &h1000
		 Shared Function NewResponse(Raw As String = "") As HTTP.Response
		  Return New HTTP.Response(Raw)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Redirector(Path As String, RedirectURL As String) As HTTP.Response
		  'Use this constructor to create a 302 redirect Document
		  Dim rply As HTTP.Response = NewResponse("")
		  rply.StatusCode = 302
		  rply.Path = Path
		  rply.SetHeader("Location", RedirectURL)
		  rply.Expires = New Date(1999, 12, 31, 23, 59, 59)
		  rply.MessageBody = ErrorPage(302, RedirectURL)
		  rply.MIMEType = New ContentType("text/html")
		  If rply.MIMEType = Nil Then
		    rply.MIMEType = New ContentType("text/html")
		  End If
		  Return rply
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return HTTPReplyString(Me.StatusCode) + CRLF + Super.ToString(False)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Virtual(VirtualURL As String) As HTTP.Response
		  'Use this constructor to create a 302 redirect Document
		  Dim rply As HTTP.Response = NewResponse("")
		  rply.StatusCode = 200
		  rply.Path = VirtualURL
		  Return rply
		End Function
	#tag EndMethod


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

	#tag Property, Flags = &h21
		Private mStatusMessage As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTrueMethodName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		StatusCode As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return HTTPCodeToMessage(Me.StatusCode)
			End Get
		#tag EndGetter
		StatusMessage As String
	#tag EndComputedProperty


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
