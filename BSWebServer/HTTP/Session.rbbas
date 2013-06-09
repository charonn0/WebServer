#tag Class
Protected Class Session
	#tag Method, Flags = &h0
		Sub AddCacheItem(Page As HTTP.Response)
		  If Page = Nil Then Return
		  If Page.Path = Nil Then Return
		  If Me.Cacheable Then
		    Me.PageCache.Value(Page.Path.ServerPath) = Page
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRedirect(Page As HTTP.Response)
		  Me.Redirects.Value(Page.Path.ServerPath) = Page
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CacheCleaner(Sender As Timer)
		  #pragma Unused Sender
		  For Each Path As String In PageCache.Keys
		    Dim doc As HTTP.Response = PageCache.Value(Path)
		    Dim d As New Date
		    If doc.Expires.TotalSeconds < d.TotalSeconds Then
		      PageCache.Remove(Path)
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Me.ExtendSession()
		  Me.CacheTimer = New Timer
		  Me.CacheTimer.Period = 15000
		  AddHandler Me.CacheTimer.Action, AddressOf Me.CacheCleaner
		  Me.CacheTimer.Mode = Timer.ModeMultiple
		  LastActive = New Date
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  Break
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExtendSession()
		  Me.LastActive = New Date
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCacheItem(Path As String) As HTTP.Response
		  // Part of the StoredItem interface.
		  Dim doc As HTTP.Response
		  If Me.Cacheable Then
		    If Me.PageCache.HasKey(Path) Then
		      doc = Me.PageCache.Value(Path)
		    End If
		  End If
		  
		  Return doc
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRedirect(Path As String) As HTTP.Response
		  // Part of the StoredItem interface.
		  Dim doc As HTTP.Response
		  If Me.Redirects.HasKey(Path) Then
		    doc = Me.Redirects.Value(Path)
		  End If
		  
		  Return doc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastActivity() As Date
		  If LastActive = Nil Then LastActive = New Date
		  Return Me.LastActive
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
		  If Redirects.HasKey(HTTPpath) Then
		    Redirects.Remove(HTTPpath)
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event GetCache(Path As String) As HTTP.Response
	#tag EndHook


	#tag Property, Flags = &h0
		Cacheable As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CacheTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepAlive As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected LastActive As Date
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
			    mSessionID = EncodeHex(MD5(UUID))
			    Me.NewSession = True
			  End If
			  Return mSessionID
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSessionID = value
			  NewSession = True
			End Set
		#tag EndSetter
		SessionID As String
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Cacheable"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepAlive"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NewSession"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionID"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionKey"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
