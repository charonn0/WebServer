#tag Class
Protected Class DirectoryIndex
	#tag Method, Flags = &h0
		Sub Constructor(Target As FolderItem, ServerPath As String)
		  Me.Target = Target
		  Me.ServerPath = ServerPath
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim timestart, timestop As Double
		  timestart = Microseconds
		  
		  Dim sortby As Integer
		  If InStr(ServerPath, "?") > 0 Then
		    Dim sortterm As String = NthField(ServerPath, "?", 2)
		    Select Case sortterm
		    Case "sort=A"
		      sortby = Sort_Alpha
		    Case "sort=D"
		      sortby = Sort_Date
		    Case "sort=S"
		      sortby = Sort_Size
		    Case "sort=T"
		      sortby = Sort_Type
		    End Select
		  End If
		  Dim sorter() As Integer
		  
		  Dim items() As FolderItem
		  Dim names(), dirtypes() As String
		  Dim dates() As Double
		  Dim sizes() As UInt64
		  Dim pagedata As String = IndexPage
		  
		  For i As Integer = 1 To Me.Target.Count
		    Dim item As FolderItem = Me.Target.Item(i)
		    items.Append(item)
		    sorter.Append(i - 1)
		    If sortby > 0 Then
		      If item.Directory Then
		        dirtypes.Append("0000AAAA")
		      Else
		        dirtypes.Append(HTTPParse.ContentType.GetType(item).ToString)
		      End If
		      
		      names.Append(item.Name)
		      dates.Append(item.ModificationDate.TotalSeconds)
		      sizes.Append(item.Length)
		    End If
		  Next
		  
		  If sortby > 0 Then
		    Select Case SortBy
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
		  Dim lines() As String
		  
		  For i As Integer = 0 To UBound(sorter)
		    Dim item As FolderItem = items(sorter(i))
		    Dim line As String = TableRow
		    Dim name, href, icon As String
		    name = item.Name
		    href = ReplaceAll(NthField(serverpath, "?", 1) + "/" + name, "//", "/")
		    href = URLEncode(href)
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
		    Dim type As HTTPParse.ContentType = HTTPParse.ContentType.GetType(item)
		    line = ReplaceAll(line, "%FILEPATH%", href)
		    line = ReplaceAll(line, "%FILENAME%", name)
		    if item.Directory Then
		      icon = type.MIMEIcon("folder")
		      line = ReplaceAll(line, "%FILESIZE%", " - ")
		      line = ReplaceAll(line, "%FILETYPE%", "Directory")
		    Else
		      icon = type.MIMEIcon(NthField(item.name, ".", CountFields(item.name, ".")))
		      line = ReplaceAll(line, "%FILESIZE%", FormatBytes(item.Length))
		      line = ReplaceAll(line, "%FILETYPE%", HTTPParse.ContentType.GetType(item).ToString)
		    End if
		    line = ReplaceAll(line, "%FILEICON%", icon)
		    line = ReplaceAll(line, "%FILEDATE%", item.ModificationDate.ShortDate + " " + item.ModificationDate.ShortTime)
		    lines.Append(line)
		  Next
		  Dim parentpath As String = NthField(serverpath, "?", 1)
		  If Right(parentpath, 1) = "/" Then parentpath = Left(parentpath, parentpath.Len - 1)
		  parentpath = NthField(parentpath, "/", CountFields(parentpath, "/"))
		  parentpath = Replace(serverpath, parentpath, "")
		  parentpath = ReplaceAll(parentpath, "//", "/")
		  If NthField(serverpath, "?", 1) <> "/" Then
		    PageData = ReplaceAll(PageData, "%UPLINK%", "<img src=""" + MIMEIcon_Back + """ width=22 height=22 /><a href=""" + parentpath + """>Parent Directory</a>")
		  Else
		    PageData = ReplaceAll(PageData, "%UPLINK%", "")
		  End If
		  Dim head As String = TableHeader
		  head = ReplaceAll(head, "%SORTICON%", Sort_Icon)
		  pagedata = Replace(pagedata, "%TABLE%", head + Join(lines, EndOfLine))
		  pagedata = ReplaceAll(pagedata, "%PAGETITLE%", "Index of " + NthField(serverpath, "?", 1))
		  If Target.Count = 1 Then
		    pagedata = Replace(pagedata, "%ITEMCOUNT%", "1 item.")
		  Else
		    pagedata = Replace(pagedata, "%ITEMCOUNT%", Format(Target.Count, "###,###,###") + " items.")
		  End If
		  
		  pagedata = Replace(pagedata, "%DAEMONVERSION%", HTTP.DaemonVersion)
		  timestop = Microseconds
		  timestart = timestop - timestart
		  Dim timestamp As String = "This page was generated in " + Format(timestart / 1000, "###,##0.0#") + "ms."
		  pagedata = Replace(pagedata, "%TIME%", timestamp)
		  Return pagedata
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private ServerPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Target As FolderItem
	#tag EndProperty


	#tag Constant, Name = IndexPage, Type = String, Dynamic = False, Default = \"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r<html xmlns\x3D\"http://www.w3.org/1999/xhtml\">\r<head>\r<title>%PAGETITLE%</title>\r</head>\r\r<body link\x3D\"#0000FF\" vlink\x3D\"#004080\" alink\x3D\"#FF0000\">\r<h1>%PAGETITLE%</h1><h2>%ITEMCOUNT%</h2>\r<p>%UPLINK%</p>\r<table width\x3D\"90%\" border\x3D\"0\" cellspacing\x3D\"5\" cellpadding\x3D\"1\">\r%TABLE%\r</table>\r<hr />\r<p style\x3D\"font-size: x-small;\">Powered by: %DAEMONVERSION% <br />\rThis page was generated in %TIME% <br /> \r%COMPRESSION%\r</p>\r</body>\r</html>", Scope = Private
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Back, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAABIAAAASABGyWs+AAAACXZwQWcAAAAWAAAAFgDcxelYAAADRUlEQVQ4y53TTWhcVRTA8f+5\r9703mUym+bQxiW1DNAakWK0xQRFRUFvpWsSNKC504c6dQkAraBeCtjUqlULblRtBwaXZiBY/6kLU\rtilppzO1mmBqM87Xm/fuPS4marTNR3O2597fPZxzD6wVXdMw+XFw24HZif6pn0ZUleE3zrKRkNVT\rO3hXC3z4funhbHfuSOHMfKcR9uW7u75JkybnXhpeEzarJV7VAp9/urSr846Bty80w1uT2PWFkf0k\racb3Y/y6FV8XfuGXhPMny7urQ/mjcw29s7ZYplxpEqvcHATykao+OHqoeGPwM6erRI57Fgfy07OO\r3dWFKkGSEAmU646GcksYBsdU9ZHhw8WNwc+dbRCkOlHaYg/NpkyWL8VEDY8VsFYIDSzWPTU1w2Fo\rp1Hds+NgcW34ya8WCVK9a2Gw7fDPidz3R8ERVRKM/DtiKxAKLMWeCmbUBME7qO4ZPLZwPfhNdr72\rNaR69/xQ5shZ7L1XL0BYu/bPOEAMiBEqKTSDaEw6swe96qOPH7/6X9hayQg8EU90nzjTLuPNELK9\rUOu21KMALwIKzkPdQy3y2E5LJp/BdWbxW3O3b89n31PlofEVePDiKw/0LQV2/7dHSyPnF5qNjHM0\rm56nx/Ph6fxN9oeGJRKIU2Wox7Ct2MHJP8vO1OcSk23DZxxXCgPb+sd6Puje5Z8CvgcI2nPhfOzk\rscq5KsnlGHUpiXNs6S1PVbfnntWozXhAU89AV8TOQRpfHI9OaH3pdZuNcWFCPNdD74gY4Ld/KvZO\rUwfFIGcx+QDjgFT4cnZpZnHE7s0IQ7rc4LgOHaOmGIy4/W4uLJlMgGbA5wzyv3kEB16evGZAALXn\rZ/qM+I5Wi1u3nIO4rhnf5Yb8Z3tLK/ev8B0U1ts8AFWTwasFbR2TFq9OjabazjqxKoxHN3r0xuC/\rF2O5YMQAfkViszBYwKDLjgXUsVF59R63alURwAsYQR1oq9XBpmGf6kU0uIIIWItaQ5IoRmgY4dJ6\r8Kovu0bzR6LwsjiJNJBfsZYEtoqRWlubuVjZLKxJMotjSsQEEpoFNYBqb2TIj/WH1VObhTEmodKc\rsfl2zECXc3O/Y5w3WRF76q2SruPyF/GBZ+iTkw4aAAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5LTEx\rLTI4VDE3OjE4OjI4LTA3OjAwMZGyLAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMi0yMFQyMzoy\rNjoxNy0wNzowMJGkTagAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDg6NDQ6MDYtMDc6\rMDA+Z9PyAAAANXRFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2Vz\rL0xHUEwvMi4xLzvBtBgAAAAldEVYdG1vZGlmeS1kYXRlADIwMDktMTEtMjhUMTQ6MzI6MTUtMDc6\rMDBz/Of9AAAAFnRFWHRTb3VyY2UAQ3J5c3RhbCBQcm9qZWN06+PkiwAAACd0RVh0U291cmNlX1VS\rTABodHRwOi8vZXZlcmFsZG8uY29tL2NyeXN0YWwvpZGTWwAAAABJRU5ErkJggg\x3D\x3D", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Sort_Alpha, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Sort_Date, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Sort_Default, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Sort_Icon, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACx\rjwv8YQUAAAAJcEhZcwAATiAAAE4gARZ9md4AAACvSURBVDhPpZCLDcMgDERNMxijMAqjeBRGySjU\r5+B8qFGhfZIVIriXC1T/ZCjIzDWmooM1l9J2nqigyGYImz4NC/brnlOw0eshuKNN8pcGFOgUoG7k\roz6CcwK6BPb/91/4SQC0zapAQ1a9NYlRxpG4ghWmBTlmd6YFLIdLu9RdziHMaUHghYHkSC4oqcCe\rI/owIBYzQjZ49/DCaKWfM8koDBCEwEAY9zLu24Hw5+T6Bj0hUky38+r0AAAAAElFTkSuQmCC", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Sort_Size, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Sort_Type, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TableHeader, Type = String, Dynamic = False, Default = \"<tr>\r    <th bgcolor\x3D\"#FFFFFF\" scope\x3D\"row\"></th>\r    <td bgcolor\x3D\"#FFFFFF\"><a href\x3D\"\?sort\x3DA\"><img src\x3D\"%SORTICON%\" alt\x3D\"Sort alphabetically\" width\x3D16 height\x3D16 border\x3D\"0\" />Name</a></td>\r    <td bgcolor\x3D\"#FFFFFF\"><a href\x3D\"\?sort\x3DD\"><img src\x3D\"%SORTICON%\" alt\x3D\"Sort by date\" width\x3D16 height\x3D16 border\x3D\"0\" />Last modified</a> </td>\r    <td bgcolor\x3D\"#FFFFFF\"><a href\x3D\"\?sort\x3DS\"><img src\x3D\"%SORTICON%\" alt\x3D\"Sort by size\" width\x3D16 height\x3D16 border\x3D\"0\" />Size</a></td>\r    <td bgcolor\x3D\"#FFFFFF\"><a href\x3D\"\?sort\x3DT\"><img src\x3D\"%SORTICON%\" alt\x3D\"Sort by type\" width\x3D16 height\x3D16 border\x3D\"0\" />Description</a></td>\r  </tr>", Scope = Private
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
