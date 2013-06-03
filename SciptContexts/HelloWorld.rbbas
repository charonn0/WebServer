#tag Class
Protected Class HelloWorld
Inherits HTTP.ScriptResponse
	#tag Event
		Function GetSource() As String
		  Return "Dim s As String" + EndOfLine + "s = ""<html><head><title>Test</title></head><body>Hello, world!</body></html>""" + EndOfLine + "MessageBody = s"
		End Function
	#tag EndEvent

	#tag Event
		Sub ScriptError(Line As Integer, Code As Integer, RuntimeError As Boolean, Stack() As String)
		  Break
		End Sub
	#tag EndEvent

	#tag Event
		Function ScriptInput(Prompt As String) As String
		  Break
		End Function
	#tag EndEvent

	#tag Event
		Sub ScriptPrint(Data As String)
		  Break
		End Sub
	#tag EndEvent


	#tag ViewBehavior
		#tag ViewProperty
			Name="HeaderLineCount"
			Group="Behavior"
			Type="Integer"
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
