#tag Class
Protected Class HTTPResponse
	#tag Method, Flags = &h0
		Sub Constructor(page As FolderItem, Path As String)
		  'Use this constructor to create a Document from a FolderItem (file or directory)
		  If page.Directory Then
		    Me.MessageBody = DirectoryIndex(Path, page)
		  Else
		    Dim bs As BinaryStream = BinaryStream.Open(page)
		    Me.MessageBody = bs.Read(bs.Length)
		    bs.Close
		    Me.MIMEType = New ContentType(page)
		  End If
		  Me.StatusCode = 200
		  Me.Modified = Page.ModificationDate
		  Me.Path = Path
		  Me.Expires = New Date
		  Me.Expires.TotalSeconds = Me.Expires.TotalSeconds + 60
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(CachedPage As HTTPResponse, Path As String)
		  'Use this constructor to create a document from another document
		  Me.MessageBody = CachedPage.MessageBody
		  Me.StatusCode = 200
		  Me.Modified = CachedPage.Modified
		  Me.Path = Path
		  mHeaders = CachedPage.Headers
		  Me.Expires = CachedPage.Expires
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ErrorCode As Integer, Param As String)
		  'Use this constructor to create an error Document with the specified HTTP ErrorCode
		  'Param is an error-dependant datum; e.g. doc = New Document(404, "/doesntexist/file.txt")
		  Me.StatusCode = ErrorCode
		  Me.MessageBody = ErrorPage(StatusCode, Param)
		  Me.StatusCode = ErrorCode
		  Me.Modified = New Date
		  
		  Me.Expires = New Date(1999, 12, 31, 23, 59, 59)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Path As String, RedirectURL As String)
		  'Use this constructor to create a 302 redirect Document
		  Me.StatusCode = 302
		  Me.Modified = New Date
		  Me.Path = Path
		  Headers.AppendHeader("Location", RedirectURL)
		  Me.Expires = New Date(1999, 12, 31, 23, 59, 59)
		  Me.MessageBody = ErrorPage(302, RedirectURL)
		  Me.MIMEType = New ContentType(MIMEstring("foo.html"))
		  'Me.SetHeader("Content-Length", Str(Me.MessageBody.LenB))
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
		  Me.Headers = New HTTPHeaders(data)
		  Me.Method = HTTP.HTTPMethod(NthField(line, " ", 1).Trim)
		  If Me.Method = RequestMethod.InvalidMethod Then mTrueMethodName = NthField(line, " ", 1).Trim
		  Me.ProtocolVersion = CDbl(Replace(NthField(line, " ", 1).Trim, "HTTP/", ""))
		  Me.StatusCode = Val(NthField(line, " ", 2))
		  Me.StatusMessage = HTTPCodeToMessage(Me.StatusCode)
		  Me.AuthRealm = AuthRealm
		  Me.AuthSecure = RequireDigestAuth
		  If Headers.GetHeader("Content-Encoding") = "gzip" Then
		    Me.GZipped = True
		    #If GZIPAvailable Then
		      Dim size As Integer = Val(Headers.GetHeader("Content-Length"))
		      Me.MessageBody = GZip.Uncompress(Me.MessageBody, size^2)
		    #endif
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function DirectoryIndex(serverpath As String, f As FolderItem) As String
		  Dim timestart, timestop As UInt64
		  Dim MessageBody As String
		  Dim i As Integer
		  Const pagetop = "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd""><html xmlns=""http://www.w3.org/1999/xhtml""><meta http-equiv=""Content-Type"" content=""text/html; charset=iso-8859-1"" /><head><title>Index of %FILENAME%</title></head><body link=""#0000FF"" vlink=""#004080"" alink=""#FF0000""><h1>Index of %FILENAME%</h1><h2>%INDEXCOUNT% item(s) found. </h2>"
		  Const TableHead = "<Table cellpadding=5 width=""90%""><TR><TD>&nbsp;</TD><TD>Name</TD><TD>Last modified</TD><TD>Size</TD><TD>Description</TD>%UPDIR%"
		  Const TableRow = "<TR bgcolor=%ROWCOLOR%><TD><img src=""%FILEICON%"" width=22 height=22 /></TD><TD><a href=""%FILEPATH%"">%FILENAME%</a></TD><TD>%FILEDATE%</TD><TD>%FILESIZE%</TD><TD>%FILETYPE%</TD></TR>"
		  Const pageend = "</Table><hr><p><small>Powered by: %DAEMON%<br >%TIMESTAMP% %PAGEGZIPSTATUS%</small></p></body></html>"
		  
		  timeStart = Microseconds
		  If f.Directory Then
		    MessageBody = ReplaceAll(pagetop, "%FILENAME%", serverpath) + ReplaceAll(TableHead , "%UPICON%", MIMEIcon_Back)
		    Dim parentpath As String = serverpath
		    If Right(parentpath, 1) = "/" Then parentpath = Left(parentpath, parentpath.Len - 1)
		    parentpath = NthField(parentpath, "/", CountFields(parentpath, "/"))
		    parentpath = Replace(serverpath, parentpath, "")
		    parentpath = ReplaceAll(parentpath, "//", "/")
		    If serverpath <> "/" Then
		      MessageBody = ReplaceAll(MessageBody, "%UPDIR%", "<img src=""" + MIMEIcon_Back + """ width=22 height=22 /><a href=""" + parentpath + """>Parent Directory</a>")
		    Else
		      MessageBody = ReplaceAll(MessageBody, "%UPDIR%", "")
		    End If
		    i = 1
		    While i <= f.Count
		      Dim line As String
		      Dim name, href, icon As String
		      name = f.TrueItem(i).Name
		      href = URLEncode(ReplaceAll(ServerPath + "/" + name, "//", "/"))
		      While Name.len > 40
		        Dim start As Integer
		        Dim snip As String
		        start = Name.Len / 3
		        snip = mid(Name, start, 5)
		        Name = Replace(Name, snip, "...")
		      Wend
		      
		      line = TableRow
		      line = ReplaceAll(line, "%FILENAME%", URLDecode(name))
		      line = ReplaceAll(line, "%FILEPATH%", href)
		      line = ReplaceAll(line, "%FILEDATE%", HTTPDate(f.TrueItem(i).ModificationDate))
		      if f.TrueItem(i).Directory Then
		        icon = MIMEIcon("folder")
		        line = ReplaceAll(line, "%FILESIZE%", " - ")
		        line = ReplaceAll(line, "%FILETYPE%", "Directory")
		      Else
		        icon = MIMEIcon(NthField(name, ".", CountFields(name, ".")))
		        line = ReplaceAll(line, "%FILESIZE%", FormatBytes(f.TrueItem(i).Length))
		        line = ReplaceAll(line, "%FILETYPE%", MIMEstring(f.TrueItem(i).Name))
		      End if
		      line = ReplaceAll(line, "%FILEICON%", icon)
		      If i Mod 2 = 0 Then
		        line = ReplaceAll(line, "%ROWCOLOR%", "#C0C0C0")
		      Else
		        line = ReplaceAll(line, "%ROWCOLOR%", "#A7A7A7")
		      End If
		      
		      MessageBody = MessageBody + line + EndOfLine
		      i = i + 1
		    Wend
		    
		    MessageBody = ReplaceAll(MessageBody, "%INDEXCOUNT%", Format(i - 1, "###,###,##0"))
		    MessageBody = MessageBody + ReplaceAll(pageend, "%DAEMON%", WebServer.DaemonVersion)
		  Else
		    MessageBody = "Not a Directory"
		    
		  End If
		  timestop = Microseconds
		  timestart = timestop - timestart
		  Dim timestamp As String = "This page was generated in " + Format(timestart / 1000, "###,##0.0#") + "ms. <br />"
		  MessageBody = Replace(MessageBody, "%TIMESTAMP%", timestamp)
		  
		  Return MessageBody
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function ErrorPage(ErrorNumber As Integer, Param As String = "") As String
		  Dim page As String = BlankErrorPage
		  page = ReplaceAll(page, "%HTTPERROR%", HTTPReplyString(ErrorNumber))
		  
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
		  
		  page = ReplaceAll(page, "%SIGNATURE%", "<em>Powered By " + WebServer.DaemonVersion + "</em><br />")
		  
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
		Function GetCookie(CookieName As String) As HTTPCookie
		  For i As Integer = 0 To UBound(Headers.Cookies)
		    If Headers.Cookies(i).Name = CookieName Then
		      Return Headers.Cookies(i)
		    End If
		  Next
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

	#tag Method, Flags = &h0
		Sub RemoveCookie(CookieName As String)
		  Me.Headers.RemoveCookie(CookieName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCookie(NewCookie As HTTPCookie)
		  Me.Headers.SetCookie(NewCookie)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCookie(Name As String, Assigns Value As String)
		  Dim c As New HTTPCookie(Name, Value)
		  Me.RemoveCookie(c.Name)
		  Me.Headers.Cookies.Append(c)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetHeader(Name As String, Value As String)
		  If Headers.HasHeader(Name) Then
		    Headers.Delete(Name)
		  End If
		  Me.Headers.AppendHeader(Name, Value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim data As String = Me.MessageBody
		  
		  
		  If TamperMessageBody(data) Then
		    Me.MessageBody = data
		  End If
		  
		  #If GZIPAvailable Then
		    If Me.GZipped Then
		      data = GZipPage(data)
		    End If
		  #endif
		  
		  Return HTTPReplyString(Me.StatusCode) + CRLF + Me.Headers.Source(True) + CRLF + CRLF + Me.MessageBody
		  
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event TamperMessageBody(ByRef Data As String) As Boolean
	#tag EndHook


	#tag Property, Flags = &h0
		AuthRealm As String
	#tag EndProperty

	#tag Property, Flags = &h0
		AuthSecure As Boolean
	#tag EndProperty

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
			  If mHeaders = Nil Then
			    mHeaders = New HTTPHeaders
			    Dim now As New Date
			    mHeaders.AppendHeader("Date", HTTPDate(now))
			    If Me.MessageBody.LenB > 0 Then
			      mHeaders.AppendHeader("Content-Length", Str(MessageBody.LenB))
			      mHeaders.AppendHeader("Content-Encoding", "Identity")
			      mHeaders.AppendHeader("Content-Type", "text/html")
			    End If
			    'headers.AppendHeader("Accept-Ranges", "bytes")
			    headers.AppendHeader("Server", WebServer.DaemonVersion)
			    headers.AppendHeader("Connection", "Close")
			  End If
			  
			  return mHeaders
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mHeaders = value
			End Set
		#tag EndSetter
		Headers As HTTPHeaders
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
		Private mHeaders As HTTPHeaders
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mMIMEType = Nil Then mMIMEType = New ContentType("text/html")
			  return mMIMEType
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

	#tag Property, Flags = &h0
		Modified As Date
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTrueMethodName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Path As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ProtocolVersion As Single
	#tag EndProperty

	#tag Property, Flags = &h0
		StatusCode As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		StatusMessage As String
	#tag EndProperty


	#tag Constant, Name = BlankErrorPage, Type = String, Dynamic = False, Default = \"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r<html xmlns\x3D\"http://www.w3.org/1999/xhtml\">\r<head>\r<meta http-equiv\x3D\"Content-Type\" content\x3D\"text/html; charset\x3Diso-8859-1\" />\r<title>%HTTPERROR%</title>\r<style type\x3D\"text/css\">\r<!--\rbody\x2Ctd\x2Cth {\r\tfont-family: Arial\x2C Helvetica\x2C sans-serif;\r\tfont-size: medium;\r}\ra:link {\r\tcolor: #0000FF;\r\ttext-decoration: none;\r}\ra:visited {\r\ttext-decoration: none;\r\tcolor: #990000;\r}\ra:hover {\r\ttext-decoration: underline;\r\tcolor: #009966;\r}\ra:active {\r\ttext-decoration: none;\r\tcolor: #FF0000;\r}\r-->\r</style></head>\r\r<body>\r<h1>%HTTPERROR%</h1>\r<p>%DOCUMENT%</p>\r<hr />\r<p>%SIGNATURE%</p>\r</body>\r</html>", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AuthRealm"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthSecure"
			Group="Behavior"
			Type="Boolean"
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
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Path"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ProtocolVersion"
			Group="Behavior"
			Type="Single"
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
