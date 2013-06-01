#tag Class
Protected Class VirtualResponse
Inherits HTTPParse.FileResponse
	#tag Method, Flags = &h1000
		Sub Constructor(page As FolderItem, Path As String)
		  // Calling the overridden superclass constructor.
		  // Constructor(page As FolderItem, Path As String) -- From FileResponse
		  Super.Constructor(page, Path)
		  'Use this constructor to create a document from another document
		  Me.StatusCode = 200
		  Dim d As New Date
		  d.TotalSeconds = d.TotalSeconds + 601
		  Me.Expires = d
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(CachedPage As HTTPParse.Response, Path As String)
		  'Use this constructor to create a document from another document
		  Me.MessageBody = CachedPage.MessageBody
		  Me.StatusCode = 200
		  Me.Path = Path
		  Me.MIMEType = CachedPage.MIMEType
		  Me.Headers = CachedPage.Headers
		  Me.Expires = CachedPage.Expires
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Path As String, RedirectURL As String)
		  'Use this constructor to create a 302 redirect Document
		  Me.StatusCode = 302
		  Me.Path = Path
		  Headers.AppendHeader("Location", RedirectURL)
		  Me.Expires = New Date(1999, 12, 31, 23, 59, 59)
		  Me.MessageBody = ErrorPage(302, RedirectURL)
		  Me.MIMEType = New HTTPParse.ContentType("text/html")
		  Super.Constructor(Me.MessageBody.LenB, Me.MIMEType)
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="AuthRealm"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.Response"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthSecure"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="HTTPParse.Response"
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
			InheritedFrom="HTTPParse.Response"
		#tag EndViewProperty
		#tag ViewProperty
			Name="GZipped"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="HTTPParse.Response"
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
			InheritedFrom="HTTPParse.Response"
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
			InheritedFrom="HTTPParse.Response"
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
			InheritedFrom="HTTPParse.Response"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StatusMessage"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.Response"
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
