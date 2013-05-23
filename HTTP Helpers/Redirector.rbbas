#tag Interface
Protected Interface Redirector
	#tag Method, Flags = &h0
		Sub AddRedirect(Page As HTTPResponse)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRedirect(Path As String) As HTTPResponse
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveRedirect(HTTPpath As String)
		  
		End Sub
	#tag EndMethod


End Interface
#tag EndInterface
