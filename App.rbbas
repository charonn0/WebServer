#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Open()
		  'Dim p As New HTTP.MultipartForm
		  'p.Element("apikey") = "d621a897995577534f4eaf29210f56494f52e434fd5ad3a8ccbac238f19a7db4"
		  'p.Element("file1") = GetOpenFolderItem("")
		  'p.Element("file2") = GetOpenFolderItem("")
		  'p.Element("file3") = GetOpenFolderItem("")
		  'Dim s As String = p.ToString
		  'Dim l As HTTP.MultipartForm = p.FromData(s, p.Boundary)
		  '
		  'For i As Integer = 0 To l.Count - 1
		  'MsgBox(l.Name(i))
		  'If l.Element(l.Name(i)) IsA FolderItem Then
		  'MsgBox(FolderItem(l.Element(l.Name(i))).Name)
		  'Else
		  'MsgBox(l.Element(l.Name(i)))
		  'End If
		  'Next
		  '
		  '
		  ''Dim t As FolderItem = SpecialFolder.Desktop.Child("bsMIME.txt")
		  ''Dim bs As BinaryStream = BinaryStream.Create(t, True)
		  '
		  ''bs.Write(s)
		  ''bs.Close
		  ''t.Launch
		  'Break
		  '
		  ''Dim t As FolderItem = GetOpenFolderItem("")
		  ''Dim bs As BinaryStream = BinaryStream.Open(t)
		  ''Dim s As String = bs.Read(bs.Length)
		  ''bs.Close
		  ''Dim p As HTTP.MultipartForm = HTTP.MultipartForm.FromData(s, "------------------------3fa2598e7af6fd21")
		  ''Break
		End Sub
	#tag EndEvent


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
