#tag Class
Protected Class MultipartForm
	#tag Method, Flags = &h0
		 Shared Function FromData(Data As String, Boundary As String) As MultipartForm
		  Dim form As New MultipartForm
		  Dim elements() As String = Split(Data, Boundary + CRLF)
		  form.Boundary = Boundary
		  
		  For i As Integer = 1 To UBound(elements)
		    elements(i) = Replace(elements(i), Boundary + "--", "")
		    Dim line As String = NthField(elements(i), CRLF, 1)
		    Dim name As String = NthField(line, ";", 2)
		    name = NthField(name, "=", 2)
		    name = ReplaceAll(name, """", "")
		    If CountFields(line, ";") < 3 Then 'form data
		      form.FormElements.Value(name) = NthField(elements(i), CRLF + CRLF, 2)
		    Else 'file
		      Dim filename As String = NthField(line, ";", 3)
		      filename = NthField(filename, "=", 2)
		      filename = ReplaceAll(filename, """", "")
		      Dim tmp As FolderItem = SpecialFolder.Temporary.Child(filename)
		      Try
		        Dim bs As BinaryStream = BinaryStream.Create(tmp, True)
		        bs.Write(NthField(elements(i), CRLF + CRLF, 2))
		        bs.Close
		        form.FormElements.Value(filename) = tmp
		      Catch Err As IOException
		        Continue For i
		      End Try
		    End If
		  Next
		  
		  Return form
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim data As String
		  For Each key As String In FormElements.Keys
		    If VarType(FormElements.Value(Key)) = Variant.TypeString Then
		      data = data + Me.Boundary + CRLF
		      data = data + "Content-Disposition: form-data; name=""" + key + """" + CRLF + CRLF
		      data = data + FormElements.Value(key) + CRLF
		    ElseIf FormElements.Value(Key) IsA FolderItem Then
		      Dim file As FolderItem = FormElements.Value(key)
		      data = data + Me.Boundary + CRLF
		      data = data + "Content-Disposition: form-data; name=""file""; filename=""" + File.Name + """" + CRLF
		      data = data + "Content-Type: " + MIMEstring(File.Name) + CRLF + CRLF
		      Dim bs As BinaryStream = BinaryStream.Open(File)
		      data = data + bs.Read(bs.Length) + CRLF
		      bs.Close
		    End If
		  Next
		  
		  data = data + Me.Boundary + "--" + CRLF
		  
		  Return data
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Boundary As String = "--bOrEdOmSoFtBoUnDaRy"
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mFormElements = Nil Then mFormElements = New Dictionary
			  return mFormElements
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFormElements = value
			End Set
		#tag EndSetter
		FormElements As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mFormElements As Dictionary
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Boundary"
			Group="Behavior"
			InitialValue="--bOrEdOmSoFtBoUnDaRy"
			Type="String"
			EditorType="MultiLineEditor"
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
