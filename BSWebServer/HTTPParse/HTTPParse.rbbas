#tag Module
Protected Module HTTPParse
	#tag Method, Flags = &h0
		Function CRLF() As String
		  Return EndOfLine.Windows
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecodeFormData(PostData As String) As Dictionary
		  Dim items() As String = Split(PostData.Trim, "&")
		  Dim form As New Dictionary
		  For i As Integer = 0 To UBound(items)
		    form.Value(DecodeURLComponent(NthField(items(i), "=", 1))) = DecodeURLComponent(NthField(items(i), "=", 2))
		  Next
		  
		  Return form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncodeFormData(PostData As Dictionary) As String
		  Dim data() As String
		  For Each key As String in PostData.Keys
		    data.Append(URLEncode(Key) + "=" + URLEncode(PostData.Value(key)))
		  Next
		  Return Join(data, "&")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatBytes(bytes As UInt64, precision As Integer = 2) As String
		  'Converts raw byte counts into SI formatted strings. 1KB = 1024 bytes.
		  'Optionally pass an integer representing the number of decimal places to return. The default is two decimal places. You may specify
		  'between 0 and 16 decimal places. Specifying more than 16 will append extra zeros to make up the length. Passing 0
		  'shows no decimal places and no decimal point.
		  
		  Const kilo = 1024
		  Static mega As UInt64 = kilo * kilo
		  Static giga As UInt64 = kilo * mega
		  Static tera As UInt64 = kilo * giga
		  Static peta As UInt64 = kilo * tera
		  Static exab As UInt64 = kilo * peta
		  
		  Dim suffix, precisionZeros As String
		  Dim strBytes As Double
		  
		  
		  If bytes < kilo Then
		    strbytes = bytes
		    suffix = "bytes"
		  ElseIf bytes >= kilo And bytes < mega Then
		    strbytes = bytes / kilo
		    suffix = "KB"
		  ElseIf bytes >= mega And bytes < giga Then
		    strbytes = bytes / mega
		    suffix = "MB"
		  ElseIf bytes >= giga And bytes < tera Then
		    strbytes = bytes / giga
		    suffix = "GB"
		  ElseIf bytes >= tera And bytes < peta Then
		    strbytes = bytes / tera
		    suffix = "TB"
		  ElseIf bytes >= tera And bytes < exab Then
		    strbytes = bytes / peta
		    suffix = "PB"
		  ElseIf bytes >= exab Then
		    strbytes = bytes / exab
		    suffix = "EB"
		  End If
		  
		  
		  While precisionZeros.Len < precision
		    precisionZeros = precisionZeros + "0"
		  Wend
		  If precisionZeros.Trim <> "" Then precisionZeros = "." + precisionZeros
		  
		  Return Format(strBytes, "#,###0" + precisionZeros) + suffix
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HTTPDate(d As Date) As String
		  Dim dt As String
		  d.GMTOffset = 0
		  Select Case d.DayOfWeek
		  Case 1
		    dt = dt + "Sun, "
		  Case 2
		    dt = dt + "Mon, "
		  Case 3
		    dt = dt + "Tue, "
		  Case 4
		    dt = dt + "Wed, "
		  Case 5
		    dt = dt + "Thu, "
		  Case 6
		    dt = dt + "Fri, "
		  Case 7
		    dt = dt + "Sat, "
		  End Select
		  
		  dt = dt  + Format(d.Day, "00") + " "
		  
		  Select Case d.Month
		  Case 1
		    dt = dt + "Jan "
		  Case 2
		    dt = dt + "Feb "
		  Case 3
		    dt = dt + "Mar "
		  Case 4
		    dt = dt + "Apr "
		  Case 5
		    dt = dt + "May "
		  Case 6
		    dt = dt + "Jun "
		  Case 7
		    dt = dt + "Jul "
		  Case 8
		    dt = dt + "Aug "
		  Case 9
		    dt = dt + "Sep "
		  Case 10
		    dt = dt + "Oct "
		  Case 11
		    dt = dt + "Nov "
		  Case 12
		    dt = dt + "Dec "
		  End Select
		  
		  dt = dt  + Format(d.Year, "0000") + " " + Format(d.Hour, "00") + ":" + Format(d.Minute, "00") + ":" + Format(d.Second, "00") + " GMT"
		  Return dt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HTTPDate(Data As String) As Date
		  
		  'Sat, 29 Oct 1994 19:43:31 GMT
		  Data = ReplaceAll(Data, "-", " ")
		  Dim d As Date
		  Dim members() As String = Split(Data, " ")
		  If UBound(members) = 5 Then
		    Dim dom, mon, year, h, m, s, tz As Integer
		    
		    dom = Val(members(1))
		    
		    Select Case members(2)
		    Case "Jan"
		      mon = 1
		    Case "Feb"
		      mon = 2
		    Case "Mar"
		      mon = 3
		    Case "Apr"
		      mon = 4
		    Case "May"
		      mon = 5
		    Case "Jun"
		      mon = 6
		    Case "Jul"
		      mon = 7
		    Case "Aug"
		      mon = 8
		    Case "Sep"
		      mon = 9
		    Case "Oct"
		      mon = 10
		    Case "Nov"
		      mon = 11
		    Case "Dec"
		      mon = 12
		    End Select
		    
		    year = Val(members(3))
		    
		    Dim time As String = members(4)
		    h = Val(NthField(time, ":", 1))
		    m = Val(NthField(time, ":", 2))
		    s = Val(NthField(time, ":", 3))
		    tz = Val(members(5))
		    
		    
		    
		    d = New Date(year, mon, dom, h, m, s, tz)
		  End If
		  Return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function URLEncode(s as String) As String
		  'This method is from here: https://github.com/bskrtich/RBHTTPServer
		  // takes a locally encoded text string and converts it to a Unix-encoded string
		  
		  // By Sascha RenÃ© Leib, published 11/08/2003 on the Athenaeum
		  
		  Dim t As String ' encoded string
		  Dim r As String
		  Dim c As Integer ' current char
		  Dim i As Integer ' loop var
		  
		  Dim srcEnc, trgEnc As TextEncoding
		  Dim conv As TextConverter
		  
		  // in case the text converter is not available,
		  // use at least the standard encoding:
		  t = s
		  
		  // first, encode the string to UTF-8
		  srcEnc = GetTextEncoding(0, 0, 0) ' default encoding
		  trgEnc = GetTextEncoding(&h0100, 0, 2) ' Unicode 2.1: UTF-8
		  If srcEnc<>Nil And trgEnc<>Nil Then
		    conv = GetTextConverter(srcEnc, trgEnc)
		    If conv<>Nil Then
		      conv.clear
		      t = conv.convert(s)
		    End If
		  End If
		  
		  For i=1 To LenB(t)
		    c = AscB(MidB(t, i, 1))
		    
		    If c<=34 Or c=37 Or c=38 Then
		      r = r + "%" + RightB("0" + Hex(c), 2)
		    Elseif (c>=43 And c<=63) Or (c>=65 And c<=90) Or (c>=97 And c<=122) Then
		      r = r + Chr(c)
		    Else
		      r = r + "%" + RightB("0" + Hex(c), 2)
		    End If
		    
		  Next ' i
		  
		  Return r
		  
		End Function
	#tag EndMethod


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
	#tag EndViewBehavior
End Module
#tag EndModule
