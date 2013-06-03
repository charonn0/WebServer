#tag Class
Protected Class FileServer
Inherits HTTP.BaseServer
	#tag Event
		Function HandleRequest(ClientRequest As HTTP.Request) As HTTP.Response
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim doc As HTTP.Response 'The response object
		  Dim item As FolderItem = FindItem(ClientRequest.Path.LocalPath)
		  Select Case ClientRequest.Method
		  Case RequestMethod.GET, RequestMethod.HEAD
		    If item = Nil Then
		      '404 Not found
		      'Me.Log("Page not found", Log_Debug)
		      doc = doc.ErrorResponse(404, ClientRequest.Path.LocalPath)
		    ElseIf item.Directory And Not Me.DirectoryBrowsing Then
		      '403 Forbidden!
		      Me.Log("Page is directory and DirectoryBrowsing=False", Log_Debug)
		      doc = doc.ErrorResponse(403, ClientRequest.Path.LocalPath)
		      
		    ElseIf ClientRequest.Path = "/" And Not item.Directory Then
		      '302 redirect from "/" to "/" + item.name
		      Dim location As String = "http://" + Me.LocalAddress + ":" + Format(Me.Port, "######") + "/" + Item.Name
		      doc = doc.Redirector("/", Location)
		    Else
		      '200 OK
		      'Me.Log("Found page", Log_Debug)
		      Dim args As String
		      If UBound(ClientRequest.Path.Arguments) > -1 Then
		        args = "?" + Join(ClientRequest.Path.Arguments, "&")
		      End If
		      If item.Directory Then
		        doc = New DirectoryIndex(item, ClientRequest.Path.LocalPath + args)
		        HTTPParse.DirectoryIndex(doc).Populate
		      Else
		        doc = doc.FromFile(item, ClientRequest.Path.LocalPath + args)
		      End If
		    End If
		  End Select
		  If doc <> Nil Then
		    doc.Method = ClientRequest.Method
		    'Me.Log(HTTPReplyString(doc.StatusCode), Log_Debug)
		  Else
		    Me.Log("The document is Nil", Log_Debug)
		  End If
		  Return doc
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1000
		Sub Constructor()
		  Dim icons As New Dictionary( _
		  "/" + VirtualRoot + "/img/bin.png":MIMEbin, _
		  "/" + VirtualRoot + "/img/script.png":MIMEScript, _
		  "/" + VirtualRoot + "/img/xojo.png":MIMERBP, _
		  "/" + VirtualRoot + "/img/dir.png":MIMEdir, _
		  "/" + VirtualRoot + "/img/txt.png":MIMETxt, _
		  "/" + VirtualRoot + "/img/html.png":MIMEHTML, _
		  "/" + VirtualRoot + "/img/css.png":MIMECSS, _
		  "/" + VirtualRoot + "/img/xml.png":MIMEXML, _
		  "/" + VirtualRoot + "/img/image.png":MIMEImage, _
		  "/" + VirtualRoot + "/img/mov.png":MIMEMov, _
		  "/" + VirtualRoot + "/img/font.png":MIMEFont, _
		  "/" + VirtualRoot + "/img/zip.png":MIMEZip, _
		  "/" + VirtualRoot + "/img/wav.png":MIMEWAV, _
		  "/" + VirtualRoot + "/img/mus.png":MIMEMus, _
		  "/" + VirtualRoot + "/img/pdf.png":MIMEPDF, _
		  "/" + VirtualRoot + "/img/xls.png":MIMEXLS, _
		  "/" + VirtualRoot + "/img/doc.png":MIMEDOC, _
		  "/" + VirtualRoot + "/img/unknown.png":MIMEUnknown, _
		  "/" + VirtualRoot + "/img/upicon.png":upIcon, _
		  "/" + VirtualRoot + "/img/sorticon.png":sortIcon, _
		  "/" + VirtualRoot + "/img/sortup.png":sortupIcon)
		  
		  For Each img As String In icons.Keys
		    Dim icon As HTTP.Response
		    Dim p As Picture
		    #If RBVersion >= 2011.4 Then
		      App.UseGDIPlus = True
		      p = New Picture(MIMEbin.Width, MIMEbin.Height)
		    #Else
		      p = New Picture(MIMEbin.Width, MIMEbin.Height, 32)
		      p.Transparent = 1
		    #endif
		    p.Graphics.DrawPicture(icons.Value(img), 0, 0)
		    Dim tmp As FolderItem = GetTemporaryFolderItem
		    p.Save(tmp, Picture.SaveAsPNG)
		    icon = icon.FromFile(tmp, img)
		    #If GZIPAvailable Then
		      icon.SetHeader("Content-Encoding", "gzip")
		      Dim gz As String
		      Try
		        Dim size As Integer = icon.MessageBody.LenB
		        gz = GZipPage(icon.MessageBody)
		        icon.MessageBody = gz
		        size = gz.LenB * 100 / size
		      Catch Error
		        'Just send the uncompressed data
		      End Try
		    #endif
		    icon.SetHeader("Content-Length", Str(icon.MessageBody.LenB))
		    icon.MIMEType = New ContentType("image/png")
		    icon.StatusCode = 200
		    icon.Expires = New Date(2033, 12, 31, 23, 59, 59)
		    icon.FromCache = True
		    icon.Path = img
		    GlobalRedirects.Value(img) = icon
		    'AddRedirect(icon)
		  Next
		  
		  Dim redirect As HTTP.Response
		  redirect = redirect.Redirector("/bs", "http://www.boredomsoft.org")
		  redirect.FromCache = True
		  Me.AddRedirect(redirect)
		  
		  Dim doc As HTTP.Response
		  doc = doc.ErrorResponse(200, "")
		  doc.Path = "/robots.txt"
		  doc.MIMEType = New ContentType("text/html")
		  doc.MessageBody = "User-Agent: *" + CRLF + "Disallow: /" + CRLF + CRLF
		  doc.FromCache = True
		  AddRedirect(doc)
		  
		  Dim tmp As FolderItem = GetTemporaryFolderItem()
		  Dim bs As BinaryStream = BinaryStream.Create(tmp, True)
		  bs.Write(favicon)
		  bs.Close
		  doc = doc.FromFile(tmp, "/favicon.ico")
		  doc.MIMEType = New ContentType("image/x-icon")
		  doc.FromCache = True
		  AddRedirect(doc)
		  
		  doc = New HelloWorld
		  doc.Path = "/script.bas"
		  doc.MIMEType = New ContentType("text/html")
		  AddRedirect(doc)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindItem(Path As String) As FolderItem
		  Dim origpath As String = Path.Trim
		  If origpath = "" Then origpath = "/"
		  Me.Log(CurrentMethodName + "(" + Path + ")", BaseServer.Log_Trace)
		  Path = URLDecode(Path.ReplaceAll("/", "\"))
		  
		  If Not DocumentRoot.Directory And "\" + DocumentRoot.Name = path Then
		    Return DocumentRoot
		  End If
		  
		  Path = ReplaceAll(DocumentRoot.AbsolutePath + Path, "\\", "\")
		  Dim item As FolderItem = GetTrueFolderItem(Path, FolderItem.PathTypeAbsolute)
		  
		  If item <> Nil And item.Exists Then
		    Me.Log(CurrentMethodName + " Found: '" + origpath + "' at '" + item.AbsolutePath + "'", Log_Debug)
		    Return item
		  End If
		  
		  Me.Log(CurrentMethodName + " File not found: '" + origpath + "'", BaseServer.Log_Error)
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mDirectoryBrowsing
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mDirectoryBrowsing = value
			  Me.Log(CurrentMethodName + "=" + Str(value), Log_Trace)
			End Set
		#tag EndSetter
		DirectoryBrowsing As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mDocumentRoot
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mDocumentRoot = value
			  Me.Log(CurrentMethodName + "=" + value.AbsolutePath, Log_Trace)
			End Set
		#tag EndSetter
		DocumentRoot As FolderItem
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected Icons As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDirectoryBrowsing As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDocumentRoot As FolderItem
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllowPipeLinedRequests"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="HTTP.BaseServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthenticationRealm"
			Visible=true
			Group="Behavior"
			InitialValue="Restricted Area"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="WebServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthenticationRequired"
			Visible=true
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="WebServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CertificatePassword"
			Group="Behavior"
			Type="String"
			InheritedFrom="HTTP.BaseServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DirectoryBrowsing"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EnforceContentType"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="WebServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumSocketsConnected"
			Visible=true
			Group="Behavior"
			InitialValue="10"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumSocketsAvailable"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionTimeout"
			Visible=true
			Group="Behavior"
			Type="Integer"
			InheritedFrom="WebServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseSessions"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="WebServer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
