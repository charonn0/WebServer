#tag Class
Protected Class FileContext
Inherits DefaultContext
	#tag Method, Flags = &h0
		Function PreParse(Source As String) As String
		  Source = Super.PreParse(Source)
		  Dim i As Integer = InStr(Source, "#Include IO.FileItem")
		  Dim h As String
		  If i > 0 Then
		    h = h + _Class_FileItem + EndOfLine
		  End If
		  HeaderLineCount = HeaderLineCount + CountFields(h, EndOfLine.Macintosh)
		  Return h + Source
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub _RuntimeCloseFile(Name As String)
		  BinaryStream(RTObjects.Value(Name)).Close
		  RTObjects.Remove(Name)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function _RuntimeCreateFile(Name As String, OverWrite As Boolean) As Integer
		  Dim bs As BinaryStream = BinaryStream.Create(FolderItem(RTObjects.Value(Name)), OverWrite)
		  Dim id As Integer
		  #If TargetWin32 Then
		    id = bs.Handle(BinaryStream.HandleTypeWin32Handle)
		  #Else
		    id = bs.Handle(BinaryStream.HandleTypeFilePointer)
		  #endif
		  
		  RTObjects.Value(id) = bs
		  Return id
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function _RuntimeGetFileItem(Path As String, PathType As Integer) As String
		  Dim f As FolderItem = GetFolderItem(Path, PathType)
		  Me.RTObjects.Value("NEWFILE") = f
		  Return "NEWFILE"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function _RuntimeOpenFile(Name As String, ReadWrite As Boolean) As Integer
		  Dim bs As BinaryStream = BinaryStream.Open(FolderItem(RTObjects.Value(Name)), ReadWrite)
		  Dim id As Integer
		  #If TargetWin32 Then
		    id = bs.Handle(BinaryStream.HandleTypeWin32Handle)
		  #Else
		    id = bs.Handle(BinaryStream.HandleTypeFilePointer)
		  #endif
		  
		  RTObjects.Value(id) = bs
		  Return id
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function _RuntimeReadFile(Name As Integer, Count As Integer) As String
		  Return BinaryStream(RTObjects.Value(Name)).Read(count)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub _RuntimeWriteFile(Name As Integer, Text As String)
		  BinaryStream(RTObjects.Value(Name)).Write(text)
		End Sub
	#tag EndMethod


	#tag Constant, Name = _Class_FileItem, Type = String, Dynamic = False, Default = \"Class FileItem\rInherits _RuntimeObject\r  Sub Constructor(Path As String\x2C PathType As Integer \x3D FileItem.Absolute)\r    Super.Constructor(_RuntimeGetFileItem(Path\x2C PathType))\r  End Sub\r  Const Absolute \x3D 0\r  Const Shell \x3D 1\r  Const URL \x3D 2\rEnd Class", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="HeaderLineCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DefaultContext"
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
