#tag Class
Protected Class HTTPMessage
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
		      href = ReplaceAll(ServerPath + "/" + name, "//", "/")
		      href = URLEncode(href)
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
		        icon = ContentType.MIMEIcon("folder")
		        line = ReplaceAll(line, "%FILESIZE%", " - ")
		        line = ReplaceAll(line, "%FILETYPE%", "Directory")
		      Else
		        icon = ContentType.MIMEIcon(NthField(name, ".", CountFields(name, ".")))
		        line = ReplaceAll(line, "%FILESIZE%", FormatBytes(f.TrueItem(i).Length))
		        line = ReplaceAll(line, "%FILETYPE%", ContentType.GetType(f.TrueItem(i)).ToString)
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
		    MessageBody = MessageBody + ReplaceAll(pageend, "%DAEMON%", HTTP.DaemonVersion)
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
		  If GetCookie(CookieName) <> "" Then Return True
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
		Function Headers() As HTTPParse.Headers
		  If mHeaders = Nil Then
		    mHeaders = New HTTPParse.Headers
		  End If
		  return mHeaders
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Headers(Assigns HTTPHeaders As HTTPParse.Headers)
		  mHeaders = HTTPHeaders
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Method() As HTTP.RequestMethod
		  Return mRequestMethod
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Method(Assigns NewMethod As HTTP.RequestMethod)
		  mRequestMethod = NewMethod
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MethodName() As String
		  If Me.Method <> RequestMethod.InvalidMethod Then
		    Return HTTPMethodName(Me.Method)
		  Else
		    Return mTrueMethodName
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MethodName(Assigns Name As String)
		  Me.Method = HTTPMethod(Name)
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
		  Dim c As New HTTPParse.Cookie(Name, Value)
		  Me.RemoveCookie(c.Name)
		  Me.Headers.Cookie(-1) = c
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetHeader(Name As String, Value As String)
		  RemoveHeader(Name)
		  Me.Headers.AppendHeader(Name, Value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(HeadersOnly As Boolean = False) As String
		  Dim data As String
		  If Not HeadersOnly Then data = Me.MessageBody
		  If Headers.Count > 0 Then
		    If Me IsA HTTPParse.Request Then
		      data = Me.Headers.Source + CRLF + CRLF + data
		    Else
		      data = Me.Headers.Source(True) + CRLF + CRLF + data
		    End If
		  End If
		  Return data
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		AuthRealm As String
	#tag EndProperty

	#tag Property, Flags = &h0
		AuthSecure As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		AuthUsername As String
	#tag EndProperty

	#tag Property, Flags = &h0
		MessageBody As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHeaders As HTTPParse.Headers
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRequestMethod As HTTP.RequestMethod
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSessionID As String
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

	#tag Constant, Name = MIMEIcon_Back, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAABIAAAASABGyWs+AAAACXZwQWcAAAAWAAAAFgDcxelYAAADRUlEQVQ4y53TTWhcVRTA8f+5\r9703mUym+bQxiW1DNAakWK0xQRFRUFvpWsSNKC504c6dQkAraBeCtjUqlULblRtBwaXZiBY/6kLU\rtilppzO1mmBqM87Xm/fuPS4marTNR3O2597fPZxzD6wVXdMw+XFw24HZif6pn0ZUleE3zrKRkNVT\rO3hXC3z4funhbHfuSOHMfKcR9uW7u75JkybnXhpeEzarJV7VAp9/urSr846Bty80w1uT2PWFkf0k\racb3Y/y6FV8XfuGXhPMny7urQ/mjcw29s7ZYplxpEqvcHATykao+OHqoeGPwM6erRI57Fgfy07OO\r3dWFKkGSEAmU646GcksYBsdU9ZHhw8WNwc+dbRCkOlHaYg/NpkyWL8VEDY8VsFYIDSzWPTU1w2Fo\rp1Hds+NgcW34ya8WCVK9a2Gw7fDPidz3R8ERVRKM/DtiKxAKLMWeCmbUBME7qO4ZPLZwPfhNdr72\rNaR69/xQ5shZ7L1XL0BYu/bPOEAMiBEqKTSDaEw6swe96qOPH7/6X9hayQg8EU90nzjTLuPNELK9\rUOu21KMALwIKzkPdQy3y2E5LJp/BdWbxW3O3b89n31PlofEVePDiKw/0LQV2/7dHSyPnF5qNjHM0\rm56nx/Ph6fxN9oeGJRKIU2Wox7Ct2MHJP8vO1OcSk23DZxxXCgPb+sd6Puje5Z8CvgcI2nPhfOzk\rscq5KsnlGHUpiXNs6S1PVbfnntWozXhAU89AV8TOQRpfHI9OaH3pdZuNcWFCPNdD74gY4Ld/KvZO\rUwfFIGcx+QDjgFT4cnZpZnHE7s0IQ7rc4LgOHaOmGIy4/W4uLJlMgGbA5wzyv3kEB16evGZAALXn\rZ/qM+I5Wi1u3nIO4rhnf5Yb8Z3tLK/ev8B0U1ts8AFWTwasFbR2TFq9OjabazjqxKoxHN3r0xuC/\rF2O5YMQAfkViszBYwKDLjgXUsVF59R63alURwAsYQR1oq9XBpmGf6kU0uIIIWItaQ5IoRmgY4dJ6\r8Kovu0bzR6LwsjiJNJBfsZYEtoqRWlubuVjZLKxJMotjSsQEEpoFNYBqb2TIj/WH1VObhTEmodKc\rsfl2zECXc3O/Y5w3WRF76q2SruPyF/GBZ+iTkw4aAAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5LTEx\rLTI4VDE3OjE4OjI4LTA3OjAwMZGyLAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMi0yMFQyMzoy\rNjoxNy0wNzowMJGkTagAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDg6NDQ6MDYtMDc6\rMDA+Z9PyAAAANXRFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2Vz\rL0xHUEwvMi4xLzvBtBgAAAAldEVYdG1vZGlmeS1kYXRlADIwMDktMTEtMjhUMTQ6MzI6MTUtMDc6\rMDBz/Of9AAAAFnRFWHRTb3VyY2UAQ3J5c3RhbCBQcm9qZWN06+PkiwAAACd0RVh0U291cmNlX1VS\rTABodHRwOi8vZXZlcmFsZG8uY29tL2NyeXN0YWwvpZGTWwAAAABJRU5ErkJggg\x3D\x3D", Scope = Protected
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
			Name="SessionID"
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
