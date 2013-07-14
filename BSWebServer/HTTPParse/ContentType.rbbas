#tag Class
Class ContentType
	#tag Method, Flags = &h0
		Function Acceptance(OtherType As ContentType) As Single
		  'Returns a Single that is <=1. This is the comparative "weight" of the match between the
		  'two types. A weight of 1 has the highest Acceptance
		  If Not OtherType.Accepts(Me) Then Return 0.0
		  Return (OtherType.Weight + Me.Weight) / 2
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Accepts(OtherType As ContentType) As Boolean
		  If OtherType.SuperType <> Me.SuperType And OtherType.SuperType <> "*" And Me.SuperType <> "*" Then Return False
		  If OtherType.SubType <> Me.SubType And OtherType.SubType <> "*" And Me.SubType <> "*" Then Return False
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  'Empty Constructor for the shared method
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(OfType As FolderItem, Weight As Single = 1.0)
		  'Takes a FolderItem; populates the class based on the FolderItem's file extension
		  'if no extension then uses "text/html"
		  
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
		  'Accepts a single raw ContentType string (e.g. "text/html; CharSet=UTF8")
		  'For strings that might contain multiple entries, use ContentType.ParseTypes
		  
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
		      Else
		        Select Case NthField(entry, "=", 1).Trim
		        Case "q"
		          Weight = CDbl(NthField(entry, "=", 2))
		        Case "charset"
		          Dim nm As String = NthField(entry, "=", 2)
		          For e As Integer = 0 To Encodings.Count' - 1
		            If Encodings.Item(e).internetName = nm Then
		              Me.CharSet = Encodings.Item(e)
		              Exit For e
		            End If
		          Next
		          
		        End Select
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
		  'parses a multi-field content-type string into and array of ContentType objects
		  'e.g. "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
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
		  'serializes the object
		  Dim data As String = SuperType + "/" + SubType
		  If Me.Weight < 1 Then
		    data = data + "; q=" + Format(Me.Weight, ".##")
		  End If
		  If Me.CharSet <> Nil Then
		    data = data + "; CharSet=" + Me.CharSet.internetName
		  End If
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
