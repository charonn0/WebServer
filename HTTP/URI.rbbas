#tag Class
Protected Class URI
Inherits HTTPParse.URI
	#tag Method, Flags = &h0
		Function LocalPath() As String
		  If UBound(Me.ServerFile) > -1 Then
		    Return Join(Me.ServerFile, "/")
		  Else
		    Return "/"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LocalPath(Assigns NewPath As String)
		  Me.ServerFile = Split(NewPath, "/")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Parent() As HTTP.URI
		  Dim parent As New HTTP.URI(Me.ToString)
		  If UBound(parent.ServerFile) > -1 Then
		    Call parent.ServerFile.Pop
		  End If
		  Return parent
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim s As String = Me
		  If s.Trim = "" Then s = "/"
		  Return s
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="CaseSensitive"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			InheritedFrom="HTTPParse.URI"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FQDN"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.URI"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fragment"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.URI"
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
			InheritedFrom="HTTPParse.URI"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="HTTPParse.URI"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Protocol"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.URI"
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
			InheritedFrom="HTTPParse.URI"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
