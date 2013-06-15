#tag Class
Protected Class HTTPMessage
	#tag Method, Flags = &h1
		Protected Shared Function ErrorPage(ErrorNumber As Integer, Param As String = "") As String
		  Dim page As String = BlankErrorPage
		  page = ReplaceAll(page, "%HTTPERROR%", HTTP.ReplyString(ErrorNumber))
		  
		  Select Case ErrorNumber
		  Case 301, 302
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested resource has moved. <a href=""" + param + """>Click here</a> if you are not automatically redirected.")
		    
		  Case 400
		    page = ReplaceAll(page, "%DOCUMENT%", "The server  did not understand your request.")
		    
		  Case 403, 401
		    page = ReplaceAll(page, "%DOCUMENT%", "Permission to access '" + Param + "' is denied.")
		    
		  Case 404
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested file, '" + Param + "', was not found on this server. ")
		    
		  Case 405
		    page = ReplaceAll(page, "%DOCUMENT%", "The specified HTTP request method '" + Param + "', is not allowed for this resource. ")
		    
		  Case 406
		    page = ReplaceAll(page, "%DOCUMENT%", "Your browser did not specify an acceptable Content-Type that was compatible with the data requested.")
		    
		  Case 410
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested file, '" + Param + "', is no longer available.")
		    
		  Case 418
		    page = ReplaceAll(page, "%DOCUMENT%", "I'm a little teapot, short and stout; here is my handle, here is my spout.")
		    
		  Case 451
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested file, '" + Param + "', is unavailable for legal reasons.")
		    
		  Case 500
		    page = ReplaceAll(page, "%DOCUMENT%", "An error ocurred while processing your request. We apologize for any inconvenience. </p><p>" + Param + "</p>")
		    
		  Case 501
		    page = ReplaceAll(page, "%DOCUMENT%", "Your browser has made a request  (verb: '" + Param + "') of this server which, while perhaps valid, is not implemented by this server.")
		    
		  Case 505
		    page = ReplaceAll(page, "%DOCUMENT%", "Your browser specified an HTTP version (" + Param + ") that is not supported by this server. This server supports HTTP 1.0 and HTTP 1.1.")
		    
		  Else
		    page = ReplaceAll(page, "%DOCUMENT%", "An HTTP error of the type specified above has occurred. No further information is available.")
		  End Select
		  
		  page = ReplaceAll(page, "%SIGNATURE%", "<em>Powered By " + HTTP.DaemonVersion + "</em><br />")
		  
		  If page.LenB < 512 Then
		    page = page + "<!--"
		    Do
		      page = page + " padding to make IE happy. "
		    Loop Until page.LenB >= 512
		    page = page + "-->"
		  End If
		  
		  
		  Return Page
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCookie(Name As String) As String
		  For i As Integer = Me.Headers.CookieCount - 1 DownTo 0
		    If Me.Headers.Cookie(i).Name = Name Then
		      Return Me.Headers.Cookie(i).Value
		    End If
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetHeader(Headername As String) As String
		  For i As Integer = 0 To Me.Headers.Count - 1
		    If Me.Headers.Name(i) = headername Then
		      Return Me.Headers.Value(i)
		    End If
		  Next
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasCookie(CookieName As String) As Boolean
		  Return GetCookie(CookieName) <> ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasHeader(HeaderName As String) As Boolean
		  For i As Integer = 0 To Me.Headers.Count - 1
		    If Me.Headers.Name(i) = HeaderName Then Return True
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Headers() As Headers
		  If mHeaders = Nil Then
		    mHeaders = New Headers
		  End If
		  return mHeaders
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Headers(Assigns HTTPHeaders As Headers)
		  mHeaders = HTTPHeaders
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
		Sub MethodName(Assigns Name As String)
		  'converts a string into an HTTP.RequestMethod. Stores the original string in mTrueMethodName and the
		  'HTTP.RequestMethod in the Method Property
		  Me.Method = HTTP.Method(Name)
		  mTrueMethodName = Name
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveCookie(Name As String)
		  For i As Integer = Me.Headers.CookieCount - 1 DownTo 0
		    If Me.Headers.Cookie(i).Name = Name Then
		      Me.Headers.Cookie(i) = Nil
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveHeader(Name As String)
		  If Me.HasHeader(Name) Then
		    Me.Headers.Delete(Name)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCookie(Name As String, Assigns Value As String)
		  Dim c As New Cookie(Name, Value)
		  Me.RemoveCookie(c.Name)
		  Me.Headers.Cookie(-1) = c
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetHeader(Name As String, Assigns Value As String)
		  Select Case Name
		  Case "Cookie", "Set-Cookie"
		    Dim n, v As String
		    n = NthField(Value, "=", 1).Trim
		    v = NthField(Value, "=", 2).Trim
		    Me.SetCookie(n) = v
		    
		  Case "Accept"
		    Dim types() As HTTPParse.ContentType = HTTPParse.ContentType.ParseTypes(Value)
		    For Each t As HTTPParse.ContentType In types
		      Me.Headers.AcceptableTypes.Append(t)
		    Next
		    
		  Else
		    RemoveHeader(Name)
		    Me.Headers.AppendHeader(Name, Value)
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ToString(HeadersOnly As Boolean) As String
		  Dim data As String
		  If Not HeadersOnly Then data = Me.MessageBody
		  If Not Me IsA HTTP.Request Then SetHeader("Content-Type") = Me.MIMEType.ToString
		  If Headers.Count > 0 Then
		    If Me IsA HTTP.Request Then
		      data = Me.Headers.Source + CRLF + CRLF + data
		    Else
		      data = Me.Headers.Source(True) + CRLF + CRLF + data
		    End If
		  End If
		  Return data
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		AuthPassword As String
	#tag EndProperty

	#tag Property, Flags = &h0
		AuthRealm As String
	#tag EndProperty

	#tag Property, Flags = &h0
		AuthUsername As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If Me.HasHeader("Expires") Then
			    Dim s As String = Me.GetHeader("Expires")
			    Return HTTPDate(s)
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value <> Nil Then
			    Me.SetHeader("Expires") = HTTPDate(value)
			  Else
			    Me.RemoveHeader("Expires")
			  End If
			End Set
		#tag EndSetter
		Expires As Date
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		MessageBody As String
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
		Private mHeaders As Headers
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mMIMEType = Nil Then
			    Dim s As String = NthField(Me.Path.ServerPath, "/", CountFields(Me.Path.ServerPath, "/"))
			    Dim f As FolderItem = SpecialFolder.Temporary.Child(s)
			    mMIMEType = New ContentType(f)
			  End If
			  return mMIMEType
			  
			  'Exception
			  'Return New ContentType("application/octet-stream")
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mMIMEType = value
			End Set
		#tag EndSetter
		MIMEType As ContentType
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mMethod As RequestMethod
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMIMEType As ContentType
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSessionID As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTrueMethodName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Path As HTTP.URI
	#tag EndProperty

	#tag Property, Flags = &h0
		ProtocolVersion As Single
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If Me.HasHeader("Range") Then
			    Dim range As String = Me.GetHeader("Range")
			    range = NthField(range, "=", 2)
			    Dim stop As Integer = Val(NthField(range, "-", 2).Trim)
			    Return stop
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.SetHeader("Range") = "bytes=" + Format(Me.RangeStart, "###################0") + "-" + Format(value, "###################0")
			End Set
		#tag EndSetter
		RangeEnd As Int64
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If Me.HasHeader("Range") Then
			    Dim range As String = Me.GetHeader("Range")
			    range = NthField(range, "=", 2)
			    Dim start As Integer = Val(NthField(range, "-", 1).Trim)
			    Return start
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.SetHeader("Range") = "bytes=" + Format(value, "###################0") + "-" + Format(Me.RangeEnd, "###################0")
			End Set
		#tag EndSetter
		RangeStart As Int64
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mSessionID = "" Then
			    If HasCookie("SessionID") Then mSessionID = GetCookie("SessionID")
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


	#tag Constant, Name = BlankErrorPage, Type = String, Dynamic = False, Default = \"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r<html xmlns\x3D\"http://www.w3.org/1999/xhtml\">\r<head>\r<meta http-equiv\x3D\"Content-Type\" content\x3D\"text/html; charset\x3Diso-8859-1\" />\r<title>%HTTPERROR%</title>\r<style type\x3D\"text/css\">\r<!--\rbody\x2Ctd\x2Cth {\r\tfont-family: Arial\x2C Helvetica\x2C sans-serif;\r\tfont-size: medium;\r}\ra:link {\r\tcolor: #0000FF;\r\ttext-decoration: none;\r}\ra:visited {\r\ttext-decoration: none;\r\tcolor: #990000;\r}\ra:hover {\r\ttext-decoration: underline;\r\tcolor: #009966;\r}\ra:active {\r\ttext-decoration: none;\r\tcolor: #FF0000;\r}\r-->\r</style></head>\r\r<body>\r<h1>%HTTPERROR%</h1>\r<p>%DOCUMENT%</p>\r<hr />\r<p>%SIGNATURE%</p>\r</body>\r</html>", Scope = Protected
	#tag EndConstant


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
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthUsername"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
