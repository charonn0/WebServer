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
			Name="AuthRealm"
			Group="Behavior"
			Type="String"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthSecure"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="HTTPParse.HTTPMessage"
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
			InheritedFrom="HTTP.Response"
		#tag EndViewProperty
		#tag ViewProperty
			Name="GZipped"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="HTTP.Response"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastError"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="HTTP.ScriptResponse"
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
			InheritedFrom="HTTPParse.HTTPMessage"
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
			InheritedFrom="HTTPParse.HTTPMessage"
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
			InheritedFrom="HTTP.Response"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StatusMessage"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTP.Response"
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
