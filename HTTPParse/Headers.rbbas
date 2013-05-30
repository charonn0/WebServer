#tag Class
Protected Class Headers
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
		      Cookies.Append(New HTTPParse.Cookie(v))
		    Case "Cookie"
		      Dim s() As String = Split(v, ";")
		      For x As Integer = 0 To UBound(s)
		        If s(x).Trim = "" Then Continue
		        Dim l, r As String
		        l = NthField(s(x).Trim, "=", 1)
		        r = NthField(s(x).Trim, "=", 2)
		        Dim c As New HTTPParse.Cookie(l, r)
		        Cookies.Append(c)
		      Next
		    Case "Accept"
		      Dim s() As String = Split(v, ",")
		      For x As Integer = 0 To UBound(s)
		        AcceptableTypes.Append(New HTTPParse.ContentType(s(x)))
		      Next
		    Else
		      Me.AppendHeader(n, v)
		    End Select
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cookie(Index As Integer = - 1, Assigns NewCookie As HTTPParse.Cookie)
		  #pragma BreakOnExceptions Off
		  If NewCookie = Nil Then
		    Cookies.Remove(Index)
		  Else
		    Cookies(Index) = NewCookie
		  End If
		  
		Exception OutOfBoundsException
		  If NewCookie <> Nil Then Cookies.Append(NewCookie)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Cookie(Index As Integer) As HTTPParse.Cookie
		  Return Cookies(Index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CookieCount() As Integer
		  Return UBound(Cookies) + 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Source(SetCookies As Boolean = False) As String
		  Dim data As String = Super.Source
		  
		  For Each c As HTTPParse.Cookie In Me.Cookies
		    If SetCookies Then
		      data = data + CRLF + "Set-Cookie: " + c.ToString
		    Else
		      data = data + CRLF + "Cookie: " + c.Name + "=" + c.Value
		    End If
		  Next
		  
		  Dim acc As String
		  For i As Integer = 0 To UBound(AcceptableTypes)
		    Dim type As HTTPParse.ContentType = AcceptableTypes(i)
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
		AcceptableTypes() As HTTPParse.ContentType
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Cookies() As HTTPParse.Cookie
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
