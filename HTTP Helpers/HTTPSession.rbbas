#tag Class
Protected Class HTTPSession
	#tag Method, Flags = &h0
		Sub AddCacheItem(Page As HTTPResponse)
		  // Part of the StoredItem interface.
		  If Me.Cacheable Then Me.PageCache.Value(Page.Path) = Page
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRedirect(Page As HTTPResponse)
		  // Part of the Redirector interface.
		  Me.Redirects.Value(Page.Path) = Page
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CacheCleaner(Sender As Timer)
		  #pragma Unused Sender
		  For Each Path As String In PageCache.Keys
		    Dim doc As HTTPResponse = PageCache.Value(Path)
		    Dim d As New Date
		    If doc.Expires.TotalSeconds < d.TotalSeconds Then
		      PageCache.Remove(Path)
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Me.ResetTimeout()
		  Me.CacheTimer = New Timer
		  Me.CacheTimer.Period = 1000
		  AddHandler Me.CacheTimer.Action, AddressOf Me.CacheCleaner
		  Me.CacheTimer.Mode = Timer.ModeMultiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCacheItem(Path As String) As HTTPResponse
		  // Part of the StoredItem interface.
		  Dim doc As HTTPResponse
		  If Me.Cacheable Then 
		    If Me.PageCache.HasKey(Path) Then
		      doc = Me.PageCache.Value(Path)
		    End If
		  End If
		  
		  Return doc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRedirect(Path As String) As HTTPResponse
		  // Part of the StoredItem interface.
		  Dim doc As HTTPResponse
		  If Me.Redirects.HasKey(Path) Then
		    doc = Me.Redirects.Value(Path)
		  Else
		    doc = CheckRedirect(Path)
		  End If
		  
		  Return doc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveCacheItem(HTTPpath As String)
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
		  Me.TimeOut.TotalSeconds = Me.TimeOut.TotalSeconds + 10 'ten minutes
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CheckRedirect(Path As String) As HTTPResponse
	#tag EndHook


	#tag Property, Flags = &h0
		Cacheable As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CacheTimer As Timer
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

	#tag Property, Flags = &h0
		NewSession As Boolean
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

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mSessionID = "" Then 
			    If SessionKey <> "" Then
			      mSessionID = EncodeHex(MD5(RC4(HTTPDate(Me.TimeOut), Me.SessionKey)))
			    Else
			      mSessionID = EncodeHex(MD5(UUID))
			    End If
			  End If
			  Return mSessionID
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSessionID = value
			End Set
		#tag EndSetter
		SessionID As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		SessionKey As String
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

	#tag Property, Flags = &h21
		Private TimeOut As Date
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
