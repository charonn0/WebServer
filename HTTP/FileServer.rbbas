#tag Class
Protected Class FileServer
Inherits HTTP.BaseServer
	#tag Event
		Function HandleRequest(ClientRequest As HTTPParse.Request) As HTTPParse.Response
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim doc As HTTPParse.Response 'The response object
		  Dim item As FolderItem = FindItem(ClientRequest.Path.ServerFile)
		  Select Case ClientRequest.Method
		  Case RequestMethod.GET, RequestMethod.HEAD
		    If item = Nil Then
		      '404 Not found
		      'Me.Log("Page not found", Log_Debug)
		      doc = New HTTPParse.ErrorResponse(404, ClientRequest.Path.ServerFile)
		    ElseIf item.Directory And Not Me.DirectoryBrowsing Then
		      '403 Forbidden!
		      Me.Log("Page is directory and DirectoryBrowsing=False", Log_Debug)
		      doc = New HTTPParse.ErrorResponse(403, ClientRequest.Path.ServerFile)
		      
		    ElseIf ClientRequest.Path = "/" And Not item.Directory Then
		      '302 redirect from "/" to "/" + item.name
		      Dim location As String = "http://" + Me.LocalAddress + ":" + Format(Me.Port, "######") + "/" + Item.Name
		      doc = New HTTPParse.VirtualResponse("/", Location)
		    Else
		      '200 OK
		      'Me.Log("Found page", Log_Debug)
		      Dim args As String
		      If UBound(ClientRequest.Path.Arguments) > -1 Then
		        args = "?" + Join(ClientRequest.Path.Arguments, "&")
		      End If
		      doc = New HTTPParse.FileResponse(item, ClientRequest.Path.ServerFile + args)
		    End If
		  End Select
		  If doc <> Nil Then
		    doc.Method = ClientRequest.Method
		    Me.Log(doc.StatusMessage, Log_Debug)
		  Else
		    Me.Log("The document is Nil", Log_Debug)
		  End If
		  Return doc
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function FindItem(Path As String) As FolderItem
		  Dim origpath As String = Path.Trim
		  Me.Log(CurrentMethodName + "(" + Path + ")", BaseServer.Log_Trace)
		  Path = Path.ReplaceAll("/", "\")
		  
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

	#tag Property, Flags = &h21
		Private mDirectoryBrowsing As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDocumentRoot As FolderItem
	#tag EndProperty


	#tag ViewBehavior
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
