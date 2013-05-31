#tag Class
Protected Class DirectoryIndex
Inherits HTTPParse.FileResponse
	#tag Method, Flags = &h0
		Sub Constructor(Target As FolderItem, ServerPath As String)
		  Me.Target = Target
		  Me.RequestPath = ServerPath
		  Me.MIMEType = New ContentType("text/html")
		  Super.Constructor(Target, ServerPath)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoSorts(SubSort As Integer, Direction As Integer) As FolderItem()
		  Dim items() As FolderItem
		  If Target = Nil Then Return items
		  Dim sorter() As Integer
		  Dim names(), dirtypes() As String
		  Dim dates() As Double
		  Dim sizes() As UInt64
		  
		  Dim count As Integer = Me.Target.Count
		  For i As Integer = 1 To Count
		    Dim item As FolderItem = Me.Target.Item(i)
		    items.Append(item)
		    sorter.Append(i - 1)
		    If item.Directory Then
		      dirtypes.Append("0000AAAA")
		    Else
		      Dim type As New ContentType(item)
		      dirtypes.Append(type.ToString)
		    End If
		    
		    names.Append(item.Name)
		    dates.Append(item.ModificationDate.TotalSeconds)
		    sizes.Append(item.Length)
		  Next
		  
		  'For SubSort As Integer = 0 To SubSorts.Ubound
		  If SubSort > 0 Then
		    Select Case SubSort
		    Case Sort_Alpha
		      names.SortWith(sorter)
		    Case Sort_Type
		      dirtypes.SortWith(sorter)
		    Case Sort_Date
		      dates.SortWith(sorter)
		    Case Sort_Size
		      sizes.SortWith(sorter)
		    End Select
		  End If
		  'Next
		  Dim ret() As FolderItem
		  If Direction = 0 Then
		    For i As Integer = 0 To UBound(items)
		      Dim item As FolderItem = items(sorter(i))
		      ret.Append(item)
		    Next
		  Else
		    For i As Integer = UBound(items) DownTo 0
		      Dim item As FolderItem = items(sorter(i))
		      ret.Append(item)
		    Next
		  End If
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Populate()
		  Dim pagedata As String = IndexPage
		  Dim timestart, timestop As Double
		  timestart = Microseconds
		  Dim Items() As FolderItem
		  Dim dir As Integer
		  If Me.RequestPath.Arguments.IndexOf("dir=1") > -1 Then dir = 1
		  For i As Integer = 0 To UBound(RequestPath.Arguments)
		    Dim k, v As String
		    k = NthField(RequestPath.Arguments(i), "=", 1)
		    v = NthField(RequestPath.Arguments(i), "=", 2)
		    Select Case k
		    Case "Sort"
		      Select Case v
		      Case "A"
		        Items = DoSorts(Sort_Alpha, dir)
		      Case "D"
		        Items = DoSorts(Sort_Date, dir)
		      Case "S"
		        Items = DoSorts(Sort_Size, dir)
		      Case "T"
		        Items = DoSorts(Sort_Type, dir)
		      Else
		        Items = DoSorts(Sort_Alpha, dir)
		      End Select
		    End Select
		  Next
		  
		  If Items.Ubound = -1 Then Items = DoSorts(Sort_Alpha, dir)
		  Dim lines() As String
		  
		  For i As Integer = 0 To UBound(Items)
		    Dim item As FolderItem = items(i)
		    Dim line As String = TableRow
		    Dim name, href, icon As String
		    name = item.Name
		    href = ReplaceAll(RequestPath.LocalPath + "/" + name, "//", "/")
		    
		    While Name.len > 40
		      Dim start As Integer
		      Dim snip As String
		      start = Name.Len / 3
		      snip = mid(Name, start, 5)
		      Name = Replace(Name, snip, "...")
		    Wend
		    Dim c As String
		    If i Mod 2 = 0 Then
		      c = "#C0C0C0"
		    Else
		      c = "#A7A7A7"
		    End If
		    line = ReplaceAll(line, "%ROWCOLOR%", c)
		    Dim type As New HTTPParse.ContentType(item)
		    line = ReplaceAll(line, "%FILEPATH%", href)
		    line = ReplaceAll(line, "%FILENAME%", name)
		    if item.Directory Then
		      icon = GetMIMEIcon("folder")
		      line = ReplaceAll(line, "%FILESIZE%", " - ")
		      line = ReplaceAll(line, "%FILETYPE%", "Directory")
		    Else
		      icon = GetMIMEIcon(NthField(item.name, ".", CountFields(item.name, ".")))
		      line = ReplaceAll(line, "%FILESIZE%", FormatBytes(item.Length))
		      line = ReplaceAll(line, "%FILETYPE%", type.ToString)
		    End if
		    line = ReplaceAll(line, "%FILEICON%", icon)
		    line = ReplaceAll(line, "%FILEDATE%", item.ModificationDate.ShortDate + " " + item.ModificationDate.ShortTime)
		    lines.Append(line)
		  Next
		  If RequestPath.LocalPath <> "/" Then
		    Dim s As String = RequestPath.Parent.LocalPath
		    PageData = ReplaceAll(PageData, "%UPLINK%", "<img src=""/_bsdaemonimags/upicon.png"" width=22 height=22 /><a href=""" + s + """>Parent Directory</a>")
		  Else
		    PageData = ReplaceAll(PageData, "%UPLINK%", "")
		  End If
		  Dim head As String = TableHeader
		  If dir = 1 Then
		    head = ReplaceAll(head, "%SORTICON%", "/_bsdaemonimags/sorticon.png")
		    head = ReplaceAll(head, "%DIRECTION%", "&dir=0")
		  Else
		    head = ReplaceAll(head, "%SORTICON%", "/_bsdaemonimags/sortup.png")
		    head = ReplaceAll(head, "%DIRECTION%", "&dir=1")
		  End If
		  pagedata = Replace(pagedata, "%TABLE%", head + Join(lines, EndOfLine))
		  pagedata = ReplaceAll(pagedata, "%PAGETITLE%", "Index of " + URLDecode(RequestPath.LocalPath))
		  If Ubound(Items) + 1 = 1 Then
		    pagedata = Replace(pagedata, "%ITEMCOUNT%", "1 item.")
		  Else
		    pagedata = Replace(pagedata, "%ITEMCOUNT%", Format(Ubound(Items) + 1, "###,###,###") + " items.")
		  End If
		  
		  pagedata = Replace(pagedata, "%DAEMONVERSION%", HTTP.DaemonVersion)
		  timestop = Microseconds
		  timestart = timestop - timestart
		  Dim timestamp As String = "This page was generated in " + Format(timestart / 1000, "###,##0.0#") + "ms."
		  pagedata = Replace(pagedata, "%TIME%", timestamp)
		  
		  Me.MessageBody = pagedata
		  Me.SetHeader("Content-Length", Str(pagedata.LenB))
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mTarget As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RequestPath As HTTP.URI
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mTarget = Nil Then Break
			  return mTarget
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTarget = value
			  If mTarget = Nil Then Break
			End Set
		#tag EndSetter
		Target As FolderItem
	#tag EndComputedProperty


	#tag Constant, Name = IndexPage, Type = String, Dynamic = False, Default = \"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r<html xmlns\x3D\"http://www.w3.org/1999/xhtml\">\r<head>\r<title>%PAGETITLE%</title>\r</head>\r\r<body link\x3D\"#0000FF\" vlink\x3D\"#004080\" alink\x3D\"#FF0000\">\r<h1>%PAGETITLE%</h1><h2>%ITEMCOUNT%</h2>\r<p>%UPLINK%</p>\r<table width\x3D\"90%\" border\x3D\"0\" cellspacing\x3D\"5\" cellpadding\x3D\"1\">\r%TABLE%\r</table>\r<hr />\r<p style\x3D\"font-size: x-small;\">Powered by: %DAEMONVERSION% <br />\r%TIME% <br /> \r%COMPRESSION% <br />\r%SECURITY%\r</p>\r</body>\r</html>", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Sort_Alpha, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Sort_Date, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Sort_Default, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Sort_Size, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Sort_Type, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TableHeader, Type = String, Dynamic = False, Default = \"<tr>\r    <th bgcolor\x3D\"#FFFFFF\" scope\x3D\"row\"></th>\r    <td bgcolor\x3D\"#FFFFFF\"><a href\x3D\"\?sort\x3DA%DIRECTION%\"><img src\x3D\"%SORTICON%\" alt\x3D\"Sort alphabetically\" width\x3D16 height\x3D16 border\x3D\"0\" />Name</a></td>\r    <td bgcolor\x3D\"#FFFFFF\"><a href\x3D\"\?sort\x3DD%DIRECTION%\"><img src\x3D\"%SORTICON%\" alt\x3D\"Sort by date\" width\x3D16 height\x3D16 border\x3D\"0\" />Last modified</a> </td>\r    <td bgcolor\x3D\"#FFFFFF\"><a href\x3D\"\?sort\x3DS%DIRECTION%\"><img src\x3D\"%SORTICON%\" alt\x3D\"Sort by size\" width\x3D16 height\x3D16 border\x3D\"0\" />Size</a></td>\r    <td bgcolor\x3D\"#FFFFFF\"><a href\x3D\"\?sort\x3DT%DIRECTION%\"><img src\x3D\"%SORTICON%\" alt\x3D\"Sort by type\" width\x3D16 height\x3D16 border\x3D\"0\" />Description</a></td>\r  </tr>", Scope = Private
	#tag EndConstant

	#tag Constant, Name = TableRow, Type = String, Dynamic = False, Default = \"    <tr>\r    <th width\x3D\"4%\" bgcolor\x3D\"%ROWCOLOR%\" scope\x3D\"row\"><img src\x3D\"%FILEICON%\" width\x3D22 height\x3D22 /></th>\r    <td width\x3D\"47%\" bgcolor\x3D\"%ROWCOLOR%\"><a href\x3D\"%FILEPATH%\">%FILENAME%</a></td>\r    <td width\x3D\"18%\" bgcolor\x3D\"%ROWCOLOR%\">%FILEDATE%</td>\r    <td width\x3D\"7%\" bgcolor\x3D\"%ROWCOLOR%\">%FILESIZE%</td>\r    <td width\x3D\"24%\" bgcolor\x3D\"%ROWCOLOR%\">%FILETYPE%</td>\r    </tr>\r    ", Scope = Private
	#tag EndConstant


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
End Class
#tag EndClass
