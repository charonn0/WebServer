#tag Class
Protected Class HTTPHeaders
Inherits InternetHeaders
	#tag Method, Flags = &h1000
		Sub Constructor(Data As String)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  Dim lines() As String = data.Split(CRLF)
		  
		  For i As Integer = 0 To UBound(lines)
		    Dim line As String = lines(i)
		    If Instr(line, ": ") <= 1  Or line.Trim = "" Then Continue
		    Dim n, v As String
		    n = NthField(line, ": ", 1)
		    v = Right(line, line.Len - (n.Len + 2)).Trim
		    Select Case n
		    Case "Set-Cookie"
		      Cookies.Append(New HTTPCookie(v))
		    Case "Cookie"
		      Dim s() As String = Split(v, ";")
		      For x As Integer = 0 To UBound(s)
		        If s(x).Trim = "" Then Continue
		        Dim l, r As String
		        l = NthField(s(x).Trim, "=", 1)
		        r = NthField(s(x).Trim, "=", 2)
		        Dim c As New HTTPCookie(l, r)
		        Cookies.Append(c)
		      Next
		    Case "Accept"
		      Dim s() As String = Split(v, ",")
		      For x As Integer = 0 To UBound(s)
		        AcceptableTypes.Append(New ContentType(s(x)))
		      Next
		    Else
		      Me.AppendHeader(n, v)
		    End Select
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Copy(CopyTo As HTTPHeaders)
		  Dim lines() As String = Me.Source.Split(CRLF)
		  If CopyTo = Nil Then CopyTo = New HTTPHeaders
		  For i As Integer = 0 To UBound(lines)
		    Dim line As String = lines(i)
		    If Instr(line, ": ") <= 1  Or line.Trim = "" Then Continue
		    CopyTo.AppendHeader(NthField(line, ": ", 1), NthField(line, ": ", 2))
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCookie(Name As String) As HTTPCookie
		  For i As Integer = UBound(Me.Cookies) DownTo 0
		    If Me.Cookies(i).Name = Name Then
		      Return Me.Cookies(i)
		    End If
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetHeader(Headername As String) As String
		  For i As Integer = 0 To Me.Count - 1
		    If Me.Name(i) = headername Then
		      Return Me.Value(i)
		    End If
		  Next
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasHeader(HeaderName As String) As Boolean
		  For i As Integer = 0 To Me.Count - 1
		    If Me.Name(i) = HeaderName Then Return True
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCookie(c As HTTPCookie)
		  'Dim data As String
		  'If Me.HasHeader("Set-Cookie") Then
		  'data = Me.Value("Set-Cookie") + ";" + c.Name + "=" + c.Right
		  'Else
		  'data = c.Name + "=" + c.Right
		  'End If
		  'Me.SetHeader("Set-Cookie", data)
		  For i As Integer = UBound(Me.Cookies) DownTo 0
		    If Me.Cookies(i).Name = c.Name Then
		      Me.Cookies.Remove(i)
		    End If
		  Next
		  Cookies.Append(c)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetHeader(Name As String, Value As String)
		  If Me.HasHeader(Name) Then
		    Me.Delete(Name)
		  End If
		  Me.AppendHeader(Name, Value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Source(SetCookies As Boolean = False) As String
		  Dim data As String = Super.Source
		  
		  For Each c As HTTPCookie In Me.Cookies
		    If SetCookies Then
		      data = data + CRLF + "Set-Cookie: " + c.ToString
		    Else
		      data = data + CRLF + "Cookie: " + c.Name + "=" + c.Value
		    End If
		  Next
		  
		  Dim acc As String
		  For i As Integer = 0 To UBound(AcceptableTypes)
		    Dim type As ContentType = AcceptableTypes(i)
		    If i > 0 And i < AcceptableTypes.Ubound Then
		      acc = acc + type.ToString + ", "
		    ElseIf i = 0 And AcceptableTypes.Ubound > 0 Then
		      acc = acc + type.ToString + ", "
		    ElseIf i = AcceptableTypes.Ubound And i > 0 Then
		      acc = acc + type.ToString
		    End If
		  Next
		  If acc <> "" Then
		    data = data + CRLF + "Accept: " + acc
		  End If
		  
		  Return data
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		AcceptableTypes() As ContentType
	#tag EndProperty

	#tag Property, Flags = &h0
		Cookies() As HTTPCookie
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
