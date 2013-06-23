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
		  Me.Method = HTTP.Method(NthField(line, " ", 1).Trim)
		  If Me.Method = RequestMethod.InvalidMethod Then Me.MethodName = NthField(line, " ", 1).Trim
		  Me.ProtocolVersion = CDbl(Replace(NthField(line, " ", 1).Trim, "HTTP/", ""))
		  Me.StatusCode = Val(NthField(line, " ", 2))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CopyDoc(CachedPage As HTTP.Response, Path As String) As HTTP.Response
		  'Use this constructor to create a document from another document
		  Dim rply As HTTP.Response = GetNewResponse("")
		  rply.MessageBody = CachedPage.MessageBody
		  rply.StatusCode = 200
		  rply.Path = New HTTP.URI(Path)
		  rply.MIMEType = CachedPage.MIMEType
		  rply.Headers = CachedPage.Headers
		  rply.Expires = CachedPage.Expires
		  
		  Return rply
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetErrorResponse(ErrorCode As Integer, Param As String) As HTTP.Response
		  'Use this constructor to create an error Document with the specified HTTP ErrorCode
		  'Param is an error-dependant datum; e.g. doc = New Document(404, "/doesntexist/file.txt")
		  Dim rply As HTTP.Response = GetNewResponse("")
		  rply.StatusCode = ErrorCode
		  Dim data As String = ErrorPage(ErrorCode, Param)
		  rply.SetHeader("Content-Length") = Str(data.LenB)
		  rply.MIMEType = New ContentType("text/html")
		  rply.StatusCode = ErrorCode
		  rply.MessageBody = data
		  rply.Expires = New Date(1999, 12, 31, 23, 59, 59)
		  Return rply
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetFileResponse(page As FolderItem, Path As String, RangeStart As Integer = 0, RangeEnd As Integer = - 1) As HTTP.Response
		  'Use this constructor to create a Document from a FolderItem (file or directory)
		  Dim rply As HTTP.Response = GetNewResponse("")
		  If Not page.Directory Then
		    Dim bs As BinaryStream
		    If rangeend = -1 Then rangeend = page.Length
		    If rangestart < 0 Or rangeend > page.Length Or rangeStart > page.Length Or rangeEnd < 0 Then
		      rply = GetErrorResponse(416, "")
		      rply.SetHeader("Content-Range") = "bytes */" + Str(Page.Length)
		      Return rply
		    End If
		    bs = BinaryStream.Open(page)
		    bs.Position = RangeStart
		    rply.MessageBody = bs.Read(rangeEnd - Rangestart)
		    bs.Close
		    rply.MIMEType = New ContentType(page)
		  End If
		  rply.SetHeader("Content-Length") = Str(rply.MessageBody.LenB)
		  If rply.MIMEType = Nil Then
		    rply.MIMEType = New ContentType("text/html")
		  End If
		  If RangeStart = 0 And RangeEnd = page.Length Then
		    rply.StatusCode = 200
		  Else
		    rply.StatusCode = 206 'partial content
		    rply.SetHeader("Content-Range") = "bytes " + Str(RangeStart) + "-" + Str(RangeEnd) + "/" + Str(Page.Length)
		  End If
		  rply.Path = New HTTP.URI(Path)
		  Dim d As New Date
		  d.TotalSeconds = d.TotalSeconds + 601
		  rply.Expires = d
		  Return rply
		  
		Exception Err As IOException
		  If err.Message.Trim = "" Then
		    err.Message = "The file could not be opened for reading."
		  End If
		  #pragma BreakOnExceptions Off
		  Raise Err
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		 Shared Function GetNewResponse(Raw As String = "") As HTTP.Response
		  Return New HTTP.Response(Raw)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetRedirectResponse(Path As String, RedirectURL As String) As HTTP.Response
		  'Use this constructor to create a 302 redirect Document
		  Dim rply As HTTP.Response = GetNewResponse("")
		  rply.StatusCode = 302
		  rply.Path = New HTTP.URI(Path)
		  rply.SetHeader("Location") = RedirectURL
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
		  Return ReplyString(Me.StatusCode) + CRLF + Super.ToString(False)'
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function Virtual(VirtualURL As String) As HTTP.Response
		  'Use this constructor to create a 302 redirect Document
		  Dim rply As HTTP.Response = GetNewResponse("")
		  rply.StatusCode = 200
		  rply.Path = New URI(VirtualURL)
		  Return rply
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Compressible As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStatusMessage As String
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
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthRealm"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthUsername"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.HTTPMessage"
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
			InheritedFrom="HTTPParse.HTTPMessage"
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
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionID"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
