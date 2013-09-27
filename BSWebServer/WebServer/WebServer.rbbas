#tag Module
Protected Module WebServer
	#tag Property, Flags = &h21
		Private mVirtualRoot As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mVirtualRoot = "" Then
			    VirtualRoot = EncodeHex(MD5(Str(Microseconds)))
			  End If
			  return mVirtualRoot
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mVirtualRoot = value
			End Set
		#tag EndSetter
		VirtualRoot As String
	#tag EndComputedProperty


	#tag Constant, Name = DaemonVersion, Type = String, Dynamic = False, Default = \"BoredomServe/1.0", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"BoredomServe/1.0 (Mac OS X)"
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"BoredomServe/1.0 (Win32)"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"BoredomServe/1.0 (GNU/Linux)"
	#tag EndConstant

	#tag Constant, Name = GZIPAvailable, Type = Boolean, Dynamic = False, Default = \"False", Scope = Public
	#tag EndConstant


	#tag Enum, Name = ConnectionTypes, Flags = &h0
		SSLv3
		  TLSv1
		Insecure
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			InheritedFrom="Object"
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
		#tag ViewProperty
			Name="VirtualRoot"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
