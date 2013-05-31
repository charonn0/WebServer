#tag Class
Protected Class URI
Inherits HTTPParse.URI
	#tag Method, Flags = &h0
		Function LocalPath() As String
		  Return Join(Me.ServerFile, "/")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LocalPath(Assigns NewPath As String)
		  Me.ServerFile = Split(NewPath, "/")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  //This method overloads the assigment operator ("=") so that any instance of the URI class can be converted directly into a string
		  
		  Dim URL As String
		  If Protocol = "mailto" Then
		    URL = "mailto:"
		  Else
		    If Protocol <> "" Then URL = Protocol + "://"
		  End If
		  
		  If Username <> "" Then
		    URL = URL + Username
		    If Password <> "" Then URL = URL + ":" + Password
		    URL = URL + "@"
		  End If
		  
		  URL = URL + FQDN
		  
		  If Port <> 0 Then //port specified
		    URL = URL + ":" + Format(Port, "#####")
		  End If
		  
		  If LocalPath <> "" Then
		    URL = URL + LocalPath
		  Else
		    If Protocol <> "mailto" Then URL = URL + "/"
		  End If
		  
		  If UBound(Arguments) > -1 Then
		    URL = URL + "?" + Join(Arguments, "&")
		  End If
		  
		  If Fragment <> "" Then
		    URL = URL + "#" + Fragment
		  End If
		  
		  Return URL
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="CaseSensitive"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FQDN"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fragment"
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
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Password"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Protocol"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ServerFile"
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
		#tag ViewProperty
			Name="Username"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
