#tag Class
Class ContentType
	#tag Method, Flags = &h0
		Function Accepts(OtherType As ContentType) As Boolean
		  If OtherType.SuperType <> Me.SuperType And OtherType.SuperType <> "*" And Me.SuperType <> "*" Then Return False
		  If OtherType.SubType <> Me.SubType And OtherType.SubType <> "*" And Me.SubType <> "*"Then Return False
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(OfType As FolderItem, Weight As Single = 1.0)
		  If Not OfType.Directory Then
		    Me.Constructor(GetType(OfType).ToString)
		  Else
		    Me.Constructor("text/html")
		  End If
		  Me.Weight = Weight
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Raw As String)
		  If InStr(Raw, ";") > 0 Then
		    Dim fields() As String = Split(raw, ";")
		    For i As Integer = 0 To Ubound(fields)
		      Dim entry As String = fields(i)
		      If InStr(entry, "/") > 0 Then
		        If NthField(entry, "/", 1).Trim <> "" Then
		          SuperType = NthField(entry, "/", 1).Trim
		        Else
		          SuperType = "*"
		        End If
		        
		        If NthField(entry, "/", 2).Trim <> "" Then
		          SubType = NthField(entry, "/", 2).Trim
		        Else
		          SubType = "*"
		        End If
		      ElseIf NthField(entry, "=", 1).Trim = "q" Then
		        Weight = CDbl(NthField(entry, "=", 2))
		        
		      End If
		    Next
		    
		  Else
		    If NthField(Raw, "/", 1).Trim <> "" Then
		      SuperType = NthField(Raw, "/", 1).Trim
		    Else
		      SuperType = "*"
		    End If
		    
		    If NthField(Raw, "/", 2).Trim <> "" Then
		      SubType = NthField(Raw, "/", 2).Trim
		    Else
		      SubType = "*"
		    End If
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParseTypes(Raw As String) As HTTPParse.ContentType()
		  Dim fields() As String
		  If InStr(Raw, ",") > 0 Then 'multiple types
		    fields = Split(raw, ",")
		  Else
		    fields.Append(raw)
		  End If
		  Dim types() As HTTPParse.ContentType
		  For i As Integer = 0 To Ubound(fields)
		    Dim t As New ContentType
		    Dim entry As String = fields(i)
		    Dim type, wght As String
		    If InStr(entry, ";") > 0 Then 'weight
		      type = NthField(entry, ";", 1)
		      wght = NthField(entry, ";", 2)
		    Else
		      type = entry.Trim
		      wght = ""
		    End If
		    
		    If NthField(type, "/", 1).Trim <> "" Then
		      t.SuperType = NthField(type, "/", 1).Trim
		    Else
		      t.SuperType = "*"
		    End If
		    
		    If NthField(type, "/", 2).Trim <> "" Then
		      t.SubType = NthField(type, "/", 2).Trim
		    Else
		      t.SubType = "*"
		    End If
		    If NthField(wght, "=", 1).Trim = "q" Then
		      wght = NthField(wght, "=", 2).Trim
		      t.Weight = CDbl(wght)
		    End If
		    types.Append(t)
		  Next
		  Return types
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim data As String = SuperType + "/" + SubType
		  If Me.Weight < 1 Then
		    data = data + "; q=" + Format(Me.Weight, ".##")
		  End If
		  'If Me.CharSet <> Nil Then
		  'Select Case
		  Return Data
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		CharSet As TextEncoding
	#tag EndProperty

	#tag Property, Flags = &h0
		SubType As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SuperType As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Weight As Single = 1.0
	#tag EndProperty


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
			Name="SubType"
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
			Name="SuperType"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="Weight"
			Group="Behavior"
			InitialValue="1.0"
			Type="Single"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
