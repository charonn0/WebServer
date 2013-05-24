#tag Class
Protected Class HTTPSession
Implements SessionInterface,StoredItem
	#tag Method, Flags = &h0
		Sub AddCacheItem(Page As HTTPResponse) Implements StoredItem.AddItem
		  // Part of the StoredItem interface.
		  Me.PageCache.Value(Page.Path) = Page
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRedirect(Page As HTTPResponse)
		  // Part of the Redirector interface.
		  Me.Redirects.Value(Page.Path) = Page
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  mSessionID = UUID
		  Me.ResetTimeout()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCacheItem(Path As String) As HTTPResponse Implements StoredItem.GetItem
		  // Part of the StoredItem interface.
		  Dim doc As HTTPResponse
		  If Me.PageCache.HasKey(Path) Then
		    doc = Me.PageCache.Value(Path)
		  Else
		    doc = LocalHost.GetItem(Path)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetItem(Path As String, Alternate As Boolean = False) As HTTPResponse
		  // Part of the Redirector interface.
		  Dim doc As HTTPResponse
		  If Me.Redirects.HasKey(Path) Then
		    doc = Me.Redirects.Value(Path)
		  Else
		    doc = LocalHost.GetItem(Path)
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewSession() As Boolean
		  Return mNewSession
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NewSession(Assigns b As Boolean)
		  mNewSession = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveCacheItem(HTTPpath As String) Implements StoredItem.RemoveItem
		  // Part of the StoredItem interface.
		  If PageCache.HasKey(HTTPpath) Then
		    PageCache.Remove(HTTPpath)
		  End If
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveRedirect(HTTPpath As String)
		  // Part of the Redirector interface.
		  If Redirects.HasKey(HTTPpath) Then
		    Redirects.Remove(HTTPpath)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetTimeout()
		  Me.TimeOut = New Date
		  Me.TimeOut.TotalSeconds = Me.TimeOut.TotalSeconds + 60 *10 'ten minutes
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SessionID() As String Implements SessionInterface.ID
		  If mSessionID = "" Then mSessionID = UUID()
		  Return mSessionID
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected LocalHost As StoredItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNewSession As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPageCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRedirects As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSessionID As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mPageCache = Nil Then mPageCache = New Dictionary
			  return mPageCache
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mPageCache = value
			End Set
		#tag EndSetter
		Protected PageCache As Dictionary
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mRedirects = Nil Then mRedirects = New Dictionary
			  return mRedirects
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mRedirects = value
			End Set
		#tag EndSetter
		Protected Redirects As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Request() As HTTPRequest
	#tag EndProperty

	#tag Property, Flags = &h0
		Response() As HTTPResponse
	#tag EndProperty

	#tag Property, Flags = &h0
		Socket As TCPSocket
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim d As New Date
			  Return d.TotalSeconds > Me.TimeOut.TotalSeconds
			End Get
		#tag EndGetter
		TimedOut As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		TimeOut As Date
	#tag EndProperty


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
			Name="TimedOut"
			Group="Behavior"
			Type="Boolean"
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
