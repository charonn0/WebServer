#tag Class
Protected Class VirtualResponse
Inherits HTTPParse.Response
	#tag Method, Flags = &h0
		Sub Constructor(CachedPage As HTTPParse.Response, Path As String)
		  'Use this constructor to create a document from another document
		  Me.MessageBody = CachedPage.MessageBody
		  Me.StatusCode = 200
		  Me.Modified = CachedPage.Modified
		  Me.Path = Path
		  Me.MIMEType = CachedPage.MIMEType
		  Headers = CachedPage.Headers
		  Me.Expires = CachedPage.Expires
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
		  Me.MIMEType = New HTTPParse.ContentType("text/html; charset=utf-8")
		  'Me.SetHeader("Content-Length", Str(Me.MessageBody.LenB))
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
			Name="Path"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.Response"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ProtocolVersion"
			Group="Behavior"
			Type="Single"
			InheritedFrom="HTTPParse.Response"
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
