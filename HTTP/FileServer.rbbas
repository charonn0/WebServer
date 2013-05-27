#tag Class
Protected Class FileServer
Inherits HTTP.Server
	#tag Event
		Function HandleRequest(ClientRequest As HTTPParse.Request) As HTTPParse.Response
		  Me.Log(CurrentMethodName + "(" + ClientRequest.SessionID + ")", Log_Trace)
		  Dim doc As HTTPParse.Response 'The response object
		  Dim item As FolderItem = FindItem(ClientRequest.Path)
		  Select Case ClientRequest.Method
		  Case RequestMethod.GET, RequestMethod.HEAD
		    If item = Nil Then
		      '404 Not found
		      'Me.Log("Page not found", Log_Debug)
		      doc = New HTTPParse.Response(404, ClientRequest.Path)
		      
		    ElseIf item.Directory And Not Me.DirectoryBrowsing Then
		      '403 Forbidden!
		      Me.Log("Page is directory and DirectoryBrowsing=False", Log_Debug)
		      doc = New HTTPParse.Response(403, ClientRequest.Path)
		      
		    ElseIf ClientRequest.Path = "/" And Not item.Directory Then
		      '302 redirect from "/" to "/" + item.name
		      Dim location As String = "http://" + Me.LocalAddress + ":" + Format(Me.Port, "######") + "/" + Item.Name
		      doc = New HTTPParse.Response("/", Location)
		    Else
		      '200 OK
		      'Me.Log("Found page", Log_Debug)
		      doc = New HTTPParse.Response(item, ClientRequest.Path)
		    End If
		  End Select
		  If doc <> Nil Then doc.Method = ClientRequest.Method
		  Return doc
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function FindItem(Path As String) As FolderItem
		  Dim origpath As String = Path.Trim
		  Me.Log(CurrentMethodName + "(" + Path + ")", Server.Log_Trace)
		  Path = Path.ReplaceAll("/", "\")
		  
		  If Not Document.Directory And "\" + Document.Name = path Then
		    Return Document
		  End If
		  
		  Path = ReplaceAll(Document.AbsolutePath + Path, "\\", "\")
		  Dim item As FolderItem = GetTrueFolderItem(Path, FolderItem.PathTypeAbsolute)
		  
		  If item <> Nil And item.Exists Then
		    Me.Log(CurrentMethodName + " Found: '" + origpath + "' at '" + item.AbsolutePath + "'", Log_Debug)
		    Return item
		  End If
		  
		  Me.Log(CurrentMethodName + " File not found: '" + origpath + "'", Server.Log_Error)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		DirectoryBrowsing As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Document As FolderItem
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AuthenticationRealm"
			Group="Behavior"
			InitialValue="""""Restricted Area"""""
			Type="String"
			InheritedFrom="WebServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthenticationRequired"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="WebServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DirectoryBrowsing"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EnforceContentType"
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
			Name="KeepAlive"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="WebServer"
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
			Group="Behavior"
			InitialValue="600"
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
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="WebServer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
