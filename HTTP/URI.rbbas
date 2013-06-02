#tag Class
Protected Class URI
Inherits HTTPParse.URI
	#tag Method, Flags = &h0
		Function LocalPath() As String
		  Dim item As String
		  For i As Integer = 0 To UBound(Me.ServerFile)
		    If Me.ServerFile(i).Trim = ""  Then Continue
		    item = item + "/" + Me.ServerFile(i).Trim
		  Next
		  If item.Trim = "" Then item = "/"
		  Return item
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
		  For i As Integer = 0 To UBound(parent.ServerFile)
		    If parent.ServerFile(i).Trim = "" Then parent.ServerFile.Remove(i)
		  Next
		  If UBound(parent.ServerFile) > -1 Then
		    While parent.ServerFile.Pop.Trim = ""
		      App.YieldToNextThread
		    Wend
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
