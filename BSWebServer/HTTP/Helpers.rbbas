#tag Module
Protected Module Helpers
	#tag Method, Flags = &h1
		Protected Function CleanMangledFunction(item as string) As string
		  'This method was written by SirG3 <TheSirG3@gmail.com>; http://fireyesoftware.com/developer/stackcleaner/
		  #If rbVersion >= 2005.5
		    
		    Static blacklist() As String
		    If UBound(blacklist) <= -1 Then
		      blacklist = Array(_
		      "REALbasic._RuntimeRegisterAppObject%%o<Application>", _
		      "_NewAppInstance", _'
		      "_Main", _
		      "% main", _
		      "REALbasic._RuntimeRun" _
		      )
		    End If
		    
		    If blacklist.indexOf( item ) >= 0 Then _
		    Exit Function
		    
		    Dim parts() As String = item.Split( "%" )
		    If ubound( parts ) < 2 Then _
		    Exit Function
		    
		    Dim func As String = parts( 0 )
		    Dim returnType As String
		    If parts( 1 ) <> "" Then _
		    returnType = parseParams( parts( 1 ) ).pop
		    Dim args() As String = parseParams( parts( 2 ) )
		    
		    If func.InStr( "$" ) > 0 Then
		      args( 0 ) = "Extends " + args( 0 )
		      func = func.ReplaceAll( "$", "" )
		      
		    Elseif ubound( args ) >= 0 And func.NthField( ".", 1 ) = args( 0 ) Then
		      args.remove( 0 )
		      
		    End If
		    
		    If func.InStr( "=" ) > 0 Then
		      Dim index As Integer = ubound( args )
		      
		      args( index ) = "Assigns " + args( index )
		      func = func.ReplaceAll( "=", "" )
		    End If
		    
		    If func.InStr( "*" ) > 0 Then
		      Dim index As Integer = ubound( args )
		      
		      args( index ) = "ParamArray " + args( index )
		      func = func.ReplaceAll( "*", "" )
		    End If
		    
		    Dim sig As String
		    If func.InStr( "#" ) > 0 Then
		      if returnType = "" Then
		        sig = "Event Sub"
		      Else
		        sig = "Event Function"
		      end if
		      func = func.ReplaceAll( "#", "" )
		      
		    ElseIf func.InStr( "!" ) > 0 Then
		      if returnType = "" Then
		        sig = "Shared Sub"
		      Else
		        sig = "Shared Function"
		      end if
		      func = func.ReplaceAll( "!", "" )
		      
		    Elseif returnType = "" Then
		      sig = "Sub"
		      
		    Else
		      sig = "Function"
		      
		    End If
		    
		    If ubound( args ) >= 0 Then
		      sig = sig + " " + func + "(" + Join( args, ", " ) + ")"
		      
		    Else
		      sig = sig + " " + func + "()"
		      
		    End If
		    
		    
		    If returnType <> "" Then
		      sig = sig + " As " + returnType
		    End If
		    
		    Return sig
		    
		  #Else
		    Return ""
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CleanStack(error as RuntimeException) As string()
		  'This method was written by SirG3 <TheSirG3@gmail.com>; http://fireyesoftware.com/developer/stackcleaner/
		  Dim result() As String
		  
		  #If rbVersion >= 2005.5
		    For Each s As String In error.stack
		      Dim tmp As String = cleanMangledFunction( s )
		      
		      If tmp <> "" Then _
		      result.append( tmp )
		    Next
		    
		  #Else
		    // leave result empty
		    
		  #EndIf
		  
		  // we must return some sort of array (even if empty), otherwise REALbasic will return a "nil" array, causing a crash when trying to use the array.
		  // see http://realsoftware.com/feedback/viewreport.php?reportid=urvbevct
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DecodeFormData(PostData As String) As Dictionary
		  Dim items() As String = Split(PostData.Trim, "&")
		  Dim form As New Dictionary
		  Dim dcount As Integer = UBound(items)
		  For i As Integer = 0 To dcount
		    form.Value(HTTP.Helpers.URLDecode(NthField(items(i), "=", 1))) = HTTP.Helpers.URLDecode(NthField(items(i), "=", 2))
		  Next
		  
		  Return form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EncodeFormData(PostData As Dictionary) As String
		  Dim data() As String
		  For Each key As String in PostData.Keys
		    data.Append(HTTP.Helpers.URLEncode(Key) + "=" + HTTP.Helpers.URLEncode(PostData.Value(key)))
		  Next
		  Return Join(data, "&")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GUnzip(Data As String) As String
		  'This function requires the GZip plugin available at http://sourceforge.net/projects/realbasicgzip/
		  #If GZipAvailable And TargetHasGUI Then'
		    Dim output As String = GZip.Uncompress(data, data.LenB * 5)
		    If GZip.Error <> 0 Then
		      Raise New RuntimeException
		    End If
		    Return output
		  #Else
		    Return data
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GUnzipPage(ByRef ResponseDocument As HTTP.Response)
		  'This function requires the GZip plugin available at http://sourceforge.net/projects/realbasicgzip/
		  'Returns the passed MessageBody after being compressed. If GZIPAvailable = false, returns the original MessageBody unchanged.
		  #If GZipAvailable And TargetHasGUI Then'
		    ResponseDocument.MessageBody = GUnzip(ResponseDocument.MessageBody)
		    If GZip.Error <> 0 Then
		      Raise New RuntimeException
		    End If
		  #Else
		    #pragma Unused ResponseDocument
		    Return
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GZip(MessageBody As String) As String
		  'This function requires the GZip plugin available at http://sourceforge.net/projects/realbasicgzip/
		  'Returns the passed MessageBody after being compressed. If GZIPAvailable = false, returns the original MessageBody unchanged.
		  #If GZipAvailable And TargetHasGUI Then'
		    Dim size As Single = MessageBody.LenB
		    If size > 2^26 Then Return MessageBody 'if bigger than 64MB, don't try compressing it.
		    MessageBody = GZip.Compress(MessageBody)
		    If GZip.Error <> 0 Then
		      Raise New RuntimeException
		    End If
		    Dim mb As New MemoryBlock(MessageBody.LenB + 8)
		    mb.Byte(0) = &h1F 'magic
		    mb.Byte(1) = &h8B 'magic
		    mb.Byte(2) = &h08 'use deflate
		    mb.StringValue(8, MessageBody.LenB) = MessageBody
		    Return mb
		  #Else
		    'HTTP.GZIPAvailable must be set to True and the GZip plugin must be installed.
		    #pragma Warning "GZip is disabled."
		    Return MessageBody
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GZipPage(ByRef ResponseDocument As HTTP.Response)
		  If ResponseDocument.MessageBody.LenB > 0 And ResponseDocument.Compressible Then
		    #If GZIPAvailable And TargetHasGUI Then
		      Dim gz As MemoryBlock = ResponseDocument.MessageBody
		      If gz.Byte(0) = &h1F And gz.Byte(1) = &h8B Then Return
		      Try
		        gz = HTTP.Helpers.GZip(Replace(ResponseDocument.MessageBody, "%COMPRESSION%", "Compressed with GZip " + GZip.Version))
		        ResponseDocument.MessageBody = gz
		        ResponseDocument.SetHeader("Content-Encoding") ="gzip"
		        ResponseDocument.SetHeader("Content-Length") = Str(gz.LenB)
		      Catch Error
		        'Just send the uncompressed data
		      End Try
		    #else
		      ResponseDocument.SetHeader("Content-Encoding") = "Identity"
		      ResponseDocument.MessageBody = Replace(ResponseDocument.MessageBody, "%COMPRESSION%", "No compression.")
		    #endif
		  Else
		    ResponseDocument.SetHeader("Content-Encoding") = "Identity"
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function HeaderComment(HeaderName As String, HeaderValue As String) As String
		  Select Case HeaderName
		  Case "Date"
		    Dim d As Date = DateString(HeaderValue)
		    Dim e As New Date
		    d.GMTOffset = e.GMTOffset
		    Return d.ShortDate + " " + d.ShortTime + "(Local time)"
		    
		  Case "Content-Length"
		    Return FormatBytes(Val(HeaderValue))
		    
		  Case "Location"
		    Return "Redirect address"
		    
		  Case "Authorization", "WWW-Authenticate"
		    Return "HTTP Authentication"
		    
		  Case "Connection"
		    If HeaderValue = "close" Then
		      Return "Connection will close"
		    ElseIf HeaderValue = "keep-alive" Then
		      Return "Connection will be maintained"
		    End If
		    
		  Case "Content-Encoding", "Accept-Encoding", "Transfer-Encoding"
		    Return "Message body encoding"
		    
		  Case "Host"
		    Return "Domain the request is directed at"
		    
		  Case "Range"
		    Return "Partial download requested"
		    
		  Case "Accept-Ranges"
		    Return "Partial download supported"
		    
		  Case "Referer"
		    Return "Referring URL"
		    
		  Case "User-Agent"
		    Return "Client-side program name"
		    
		  Case "Server"
		    Return "Server-side program name"
		    
		  Case "Via"
		    Return "Intermediary Web Proxy"
		    
		  Case "Warning"
		    Return "General warning about message body"
		    
		  Case "DNT"
		    Return "Do Not Track (i.e. cookies)"
		    
		  Case "X-Forwarded-For"
		    Return "Requestor's IP as seen by a proxy"
		    
		  Case "Allow"
		    Return "Server supported HTTP methods"
		    
		  Case "Content-Location"
		    Return "Alternate URL for this resource"
		    
		  Case "ETag"
		    Return "Opaque document version marker"
		    
		  Case "Expires"
		    Dim d As Date = DateString(HeaderValue)
		    Dim e As New Date
		    d.GMTOffset = e.GMTOffset
		    Return d.ShortDate + " " + d.ShortTime + "(Local time)"
		    
		  Case "Last-Modified"
		    Dim d As Date = DateString(HeaderValue)
		    Dim e As New Date
		    d.GMTOffset = e.GMTOffset
		    Return d.ShortDate + " " + d.ShortTime + "(Local time)"
		    
		  Case "Link"
		    Return "URL to a related document (e.g. RSS feed)"
		    
		  Case "P3P"
		    Return "P3P policy, often invalid"
		    
		  Case "Refresh"
		    Return "Redirect URL with optional delay"
		    
		  End Select
		  
		Exception
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseParams(input as string) As string()
		  'This method was written by SirG3 <TheSirG3@gmail.com>; http://fireyesoftware.com/developer/stackcleaner/
		  
		  Const kParamMode = 0
		  Const kObjectMode = 1
		  Const kIntMode = 2
		  Const kUIntMode = 3
		  Const kFloatingMode = 4
		  Const kArrayMode = 5
		  
		  Dim chars() As String = Input.Split( "" )
		  Dim funcTypes(), buffer As String
		  Dim arrays(), arrayDims(), byrefs(), mode As Integer
		  
		  For Each char As String In chars
		    Select Case mode
		    Case kParamMode
		      Select Case char
		      Case "i"
		        mode = kIntMode
		        
		      Case "u"
		        mode = kUIntMode
		        
		      Case "o"
		        mode = kObjectMode
		        
		      Case "b"
		        funcTypes.append( "Boolean" )
		        
		      Case "s"
		        funcTypes.append( "String" )
		        
		      Case "f"
		        mode = kFloatingMode
		        
		      Case "c"
		        funcTypes.append( "Color" )
		        
		      Case "A"
		        mode = kArrayMode
		        
		      Case "&"
		        byrefs.append( ubound( funcTypes ) + 1 )
		        
		      End Select
		      
		      
		    Case kObjectMode
		      If char = "<" Then _
		      Continue
		      
		      If char = ">" Then
		        funcTypes.append( buffer )
		        buffer = ""
		        mode = kParamMode
		        
		        Continue
		      End If
		      
		      buffer = buffer + char
		      
		      
		    Case kIntMode, kUIntMode
		      Dim intType As String = "Int"
		      
		      If mode = kUIntMode Then _
		      intType = "UInt"
		      
		      funcTypes.append( intType + Str( Val( char ) * 8 ) )
		      mode = kParamMode
		      
		      
		    Case kFloatingMode
		      If char = "4" Then
		        funcTypes.append( "Single" )
		        
		      Elseif char = "8" Then
		        funcTypes.append( "Double" )
		        
		      End If
		      
		      mode = kParamMode
		      
		    Case kArrayMode
		      arrays.append( ubound( funcTypes ) + 1 )
		      arrayDims.append( Val( char ) )
		      mode = kParamMode
		      
		    End Select
		  Next
		  
		  For i As Integer = 0 To ubound( arrays )
		    Dim arr As Integer = arrays( i )
		    Dim s As String = funcTypes( arr ) + "("
		    
		    For i2 As Integer = 2 To arrayDims( i )
		      s = s + ","
		    Next
		    
		    funcTypes( arr ) = s + ")"
		  Next
		  
		  For Each b As Integer In byrefs
		    funcTypes( b ) = "ByRef " + funcTypes( b )
		  Next
		  
		  Return funcTypes
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function URLDecode(s as String) As String
		  'This method is from here: https://github.com/bskrtich/RBHTTPServer
		  // takes a Unix-encoded string and decodes it to the standard text encoding.
		  
		  // By Sascha RenÃ© Leib, published 11/08/2003 on the Athenaeum
		  
		  Dim r As String
		  Dim c As Integer ' current char
		  Dim i As Integer ' loop var
		  
		  // first, remove the unix-path-encoding:
		  
		  For i= 1 To LenB(s)
		    c = AscB(MidB(s, i, 1))
		    
		    If c = 37 Then ' %
		      r = r + ChrB(Val("&h" + MidB(s, i+1, 2)))
		      i = i + 2
		    Else
		      r = r + ChrB(c)
		    End If
		    
		  Next
		  
		  r = ReplaceAll(r,"+"," ")
		  
		  Return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function URLEncode(s as String) As String
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
End Module
#tag EndModule
