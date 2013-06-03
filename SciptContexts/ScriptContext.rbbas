#tag Interface
Protected Interface ScriptContext
	#tag Method, Flags = &h0
		Function ContextComment() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ContextName() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ContextVersion() As Single
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsMethodAvailable(MethodName As String) As Boolean
		  
		End Function
	#tag EndMethod


	#tag ViewBehavior
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
End Interface
#tag EndInterface
