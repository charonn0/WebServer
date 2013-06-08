#tag Module
Protected Module WebServer
	#tag Method, Flags = &h1
		Protected Sub AddMIMEType(FileExtension As String, MIMEName As String)
		  MIMETypes.Value(FileExtension) = MIMEName
		End Sub
	#tag EndMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function CFRelease Lib "Carbon" (cf As Ptr) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function CFUUIDCreate Lib "Carbon" (alloc As Ptr) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function CFUUIDCreateString Lib "Carbon" (alloc As ptr, CFUUIDRef As Ptr) As CFStringRef
	#tag EndExternalMethod

	#tag Method, Flags = &h21
		Private Function CleanMangledFunction(item as string) As string
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

	#tag Method, Flags = &h0
		Function CleanStack(Extends error as RuntimeException) As string()
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

	#tag Method, Flags = &h0
		Function GetMIMEIcon(ext As String) As String
		  ext = Lowercase(ext)
		  
		  Select Case ext
		  Case "exe", "com", "scr", "pif", "dll", "deb", "rpm"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/bin.png"
		    
		  Case "js", "cs", "c", "h", "vbs", "vbe", "bat", "cmd", "sh", "ini", "reg"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/script.png"
		    
		  Case "rbp", "rbbas", "rbvcp", "rbfrm", "rbres"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/xojo.png"
		    
		  Case "folder"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/dir.png"
		    
		  Case "txt", "md"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/txt.png"
		    
		  Case "htm", "html"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/html.png"
		    
		  Case "css"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/css.png"
		    
		  Case "xml", "xsl"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/xml.png"
		    
		  Case "jpg", "jpeg", "png", "bmp", "gif", "tif"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/image.png"
		    
		  Case "mov", "mp4", "m4v", "avi", "mpg", "mpeg", "wmv", "mkv"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/mov.png"
		    
		  Case "ttf", "otf", "pfb", "pfm"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/font.png"
		    
		  Case "zip", "tar", "rar", "7zip", "bzip", "gzip", "7z", "tgz", "gz", "z"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/zip.png"
		    
		  Case "wav"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/wav.png"
		    
		  Case "mp3", "m4a", "m4b", "m4p", "ogg", "flac"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/mus.png"
		    
		  Case "pdf", "ps"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/pdf.png"
		    
		  Case "xls", "xlsx"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/xls.png"
		    
		  Case "doc", "docx"
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/doc.png"
		    
		  Else ' This returns the default icon
		    Return "/" + HTTP.BaseServer.VirtualRoot + "/img/unknown.png"
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GZipPage(MessageBody As String) As String
		  'This function requires the GZip plugin available at http://sourceforge.net/projects/realbasicgzip/
		  'Returns the passed MessageBody after being compressed. If GZIPAvailable = false, returns the original MessageBody unchanged.
		  #If GZipAvailable Then'
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

	#tag Method, Flags = &h0
		Function MIMEIcon(ext As String) As String
		  ext = Lowercase(ext)
		  
		  Select Case ext
		  Case "exe", "com", "scr", "pif", "dll", "deb", "rpm"
		    Return "/_bsdaemonimags/bin.png"
		    
		  Case "js", "cs", "c", "h", "vbs", "vbe", "bat", "cmd", "sh", "ini", "reg"
		    Return "/_bsdaemonimags/script.png"
		    
		  Case "rbp", "rbbas", "rbvcp", "rbfrm", "rbres"
		    Return "/_bsdaemonimags/xojo.png"
		    
		  Case "folder"
		    Return "/_bsdaemonimags/dir.png"
		    
		  Case "txt", "md"
		    Return "/_bsdaemonimags/txt.png"
		    
		  Case "htm", "html"
		    Return "/_bsdaemonimags/html.png"
		    
		  Case "css"
		    Return "/_bsdaemonimags/css.png"
		    
		  Case "xml", "xsl"
		    Return "/_bsdaemonimags/xml.png"
		    
		  Case "jpg", "jpeg", "png", "bmp", "gif", "tif"
		    Return "/_bsdaemonimags/image.png"
		    
		  Case "mov", "mp4", "m4v", "avi", "mpg", "mpeg", "wmv", "mkv"
		    Return "/_bsdaemonimags/mov.png"
		    
		  Case "ttf", "otf", "pfb", "pfm"
		    Return "/_bsdaemonimags/font.png"
		    
		  Case "zip", "tar", "rar", "7zip", "bzip", "gzip", "7z", "tgz", "gz", "z"
		    Return "/_bsdaemonimags/zip.png"
		    
		  Case "wav"
		    Return "/_bsdaemonimags/wav.png"
		    
		  Case "mp3", "m4a", "m4b", "m4p", "ogg", "flac"
		    Return "/_bsdaemonimags/mus.png"
		    
		  Case "pdf", "ps"
		    Return "/_bsdaemonimags/pdf.png"
		    
		  Case "xls", "xlsx"
		    Return "/_bsdaemonimags/xls.png"
		    
		  Case "doc", "docx"
		    Return "/_bsdaemonimags/doc.png"
		    
		  Else ' This returns the default icon
		    Return "/_bsdaemonimags/unknown.png"
		    
		  End Select
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

	#tag Method, Flags = &h0
		Function RC4(strData As String, strKey As String) As String
		  //Credit: http://forums.realsoftware.com/viewtopic.php?f=1&t=19930
		  //Encodes or decodes the strData string with the RC4 symmetric ciper, using the strKey as the key.
		  //On success, returns the En/Decoded string. On error, returns an empty string.
		  
		  Dim MM As MemoryBlock = strData
		  Dim MM2 As New MemoryBlock(LenB(strData))
		  Dim memAsciiArray(255), memKeyArray(255), memJump, memTemp, memY, intKeyLength, intIndex, intT, intX As integer
		  
		  intKeyLength = len(strKey)
		  
		  For intIndex = 0 to 255
		    memKeyArray(intIndex) = asc(mid(strKey, ((intIndex) mod (intKeyLength)) + 1, 1))
		  next
		  
		  For intIndex = 0 to 255
		    memAsciiArray(intIndex) = intIndex
		  next
		  
		  For intIndex = 0 to 255
		    memJump = (memJump + memAsciiArray(intIndex) + memKeyArray(intIndex)) mod 256
		    memTemp = memAsciiArray(intIndex)
		    memAsciiArray(intIndex) = memAsciiArray(memJump)
		    memAsciiArray(memJump) = memTemp
		  next
		  
		  intIndex = 0
		  memJump = 0
		  
		  For intX = 1 to MM2.Size
		    intIndex = (intIndex + 1) mod 256
		    memJump = (memJump + memAsciiArray(intIndex)) mod 256
		    intT = (memAsciiArray(intIndex) + memAsciiArray(memJump)) mod 256
		    memTemp = memAsciiArray(intIndex)
		    memAsciiArray(intIndex) = memAsciiArray(memJump)
		    memAsciiArray(memJump) = memTemp
		    memY = memAsciiArray(intT)
		    mm2.Byte(intX - 1) = bitwise.bitxor(val("&h" + hex(MM.byte(IntX - 1))), bitwise.bitxor(memTemp,memY))
		  next
		  
		  return MM2
		  
		Exception
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RemoveMIMEType(FileExtension As String)
		  If MIMETypes.HasKey(FileExtension) Then
		    MIMETypes.Remove(FileExtension)
		  End If
		End Sub
	#tag EndMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function RpcStringFree Lib "Rpcrt4" Alias "RpcStringFreeA" (Addr As Ptr) As Integer
	#tag EndExternalMethod

	#tag Method, Flags = &h0
		Function SocketErrorMessage(ErrorCode As Integer) As String
		  Dim err As String = "socket error " + Str(ErrorCode)
		  Select Case ErrorCode
		  Case 102
		    err = err + ": Disconnected."
		  Case 100
		    err = err + ": Could not create a socket!"
		  Case 103
		    err = err + ": Connection timed out."
		  Case 105
		    err = err + ": That port number is already in use."
		  Case 106
		    err = err + ": Socket is not ready for that command."
		  Case 107
		    err = err + ": Could not bind to port."
		  Case 108
		    err = err + ": Out of memory."
		  Else
		    err = err + ": System error code."
		  End Select
		  
		  Return err
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UUID() As String
		  //This function ©2004-2011 Adam Shirey
		  //http://www.dingostick.com/node.php?id=11
		  
		  Dim strUUID As String
		  
		  #If TargetMacOS
		    //see http://developer.apple.com/documentation/CoreFOundation/Reference/CFUUIDRef/Reference/reference.html
		    Dim pUUID As ptr = CFUUIDCreate(Nil)
		    StructureInfo = CFUUIDCreateString(Nil, pUUID)
		    CFRelease(pUUID)
		    
		  #ElseIf TargetWin32
		    //see: http://msdn.microsoft.com/en-us/library/aa379205(VS.85).aspx
		    //and: http://msdn.microsoft.com/en-us/library/aa379352(VS.85).aspx
		    Static mb As New MemoryBlock(16)
		    Call UuidCreate(mb) //can compare to RPC_S_UUID_LOCAL_ONLY and RPC_S_UUID_NO_ADDRESS for more info
		    Static ptrUUID As New MemoryBlock(16)
		    Dim ppAddr As ptr
		    Call UuidToString(mb, ppAddr)
		    Dim mb2 As MemoryBlock = ppAddr
		    strUUID = mb2.CString(0)
		    Call RpcStringFree(ptrUUID)
		    
		  #ElseIf TargetLinux
		    // see http://linux.die.net/man/3/uuid_generate
		    
		    // these are soft declared because there's perhaps a smaller chance of libuuid being present on a linux system,
		    // though I have no evidence to support such a claim. it seems pretty standard.
		    If System.IsFunctionAvailable("uuid_generate", "libuuid") Then
		      Static mb As New MemoryBlock( 16 )
		      Static uu As New MemoryBlock( 36 )
		      
		      uuid_generate(mb) // generate the uuid in binary form
		      uuid_unparse_upper(mb, uu) // convert to a 36-byte string
		      
		      strUUID = uu.StringValue(0, 36)
		    Else
		      Dim error As String = App.ExecutableFile.Name + ": expected libuuid!"
		      #If TargetHasGUI Then
		        System.DebugLog(error)
		      #Else
		        StdErr.Write(error)
		      #endif
		    End If
		  #EndIf
		  
		  Return strUUID
		End Function
	#tag EndMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function UuidCreate Lib "Rpcrt4" (Uuid As Ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function UuidToString Lib "Rpcrt4" Alias "UuidToStringA" (Uuid As Ptr, ByRef p As ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Sub uuid_generate Lib "libuuid" (out As ptr)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Sub uuid_unparse_upper Lib "libuuid" (mb As Ptr, uu As Ptr)
	#tag EndExternalMethod


	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mMIMETypes = Nil Then
			    mMIMETypes = New Dictionary( _
			    "ez":"application/andrew-inset", _
			    "aw":"application/applixware", _
			    "atom":"application/atom+xml", _
			    "atomcat":"application/atomcat+xml", _
			    "atomsvc":"application/atomsvc+xml", _
			    "ccxml":"application/ccxml+xml", _
			    "cdmia":"application/cdmi-capability", _
			    "cdmic":"application/cdmi-container", _
			    "cdmid":"application/cdmi-domain", _
			    "cdmio":"application/cdmi-object", _
			    "cdmiq":"application/cdmi-queue", _
			    "cu":"application/cu-seeme", _
			    "davmount":"application/davmount+xml", _
			    "dssc":"application/dssc+der", _
			    "xdssc":"application/dssc+xml", _
			    "ecma":"application/ecmascript", _
			    "emma":"application/emma+xml", _
			    "epub":"application/epub+zip", _
			    "exi":"application/exi", _
			    "pfr":"application/font-tdpfr", _
			    "stk":"application/hyperstudio", _
			    "ipfix":"application/ipfix", _
			    "jar":"application/java-archive", _
			    "ser":"application/java-serialized-object", _
			    "class":"application/java-vm", _
			    "js":"application/javascript", _
			    "json":"application/json", _
			    "lostxml":"application/lost+xml", _
			    "hqx":"application/mac-binhex40", _
			    "cpt":"application/mac-compactpro", _
			    "mads":"application/mads+xml", _
			    "mrc":"application/marc", _
			    "mrcx":"application/marcxml+xml", _
			    "ma":"application/mathematica", _
			    "nb":"application/mathematica", _
			    "mb":"application/mathematica", _
			    "mathml":"application/mathml+xml", _
			    "mbox":"application/mbox", _
			    "mscml":"application/mediaservercontrol+xml", _
			    "meta4":"application/metalink4+xml", _
			    "mets":"application/mets+xml", _
			    "mods":"application/mods+xml", _
			    "m21":"application/mp21", _
			    "mp21":"application/mp21", _
			    "mp4s":"application/mp4", _
			    "doc":"application/msword", _
			    "dot":"application/msword", _
			    "mxf":"application/mxf", _
			    "asc":"application/pgp-signature", _
			    "sig":"application/pgp-signature", _
			    "prf":"application/pics-rules", _
			    "p10":"application/pkcs10", _
			    "p7m":"application/pkcs7-mime", _
			    "p7c":"application/pkcs7-mime", _
			    "p7s":"application/pkcs7-signature", _
			    "p8":"application/pkcs8", _
			    "ac":"application/pkix-attr-cert", _
			    "cer":"application/pkix-cert", _
			    "crl":"application/pkix-crl", _
			    "pkipath":"application/pkix-pkipath", _
			    "pki":"application/pkixcmp", _
			    "pls":"application/pls+xml", _
			    "ai":"application/postscript", _
			    "eps":"application/postscript", _
			    "ps":"application/postscript", _
			    "cww":"application/prs.cww", _
			    "pskcxml":"application/pskc+xml", _
			    "rdf":"application/rdf+xml", _
			    "rif":"application/reginfo+xml", _
			    "rnc":"application/relax-ng-compact-syntax", _
			    "rl":"application/resource-lists+xml", _
			    "rld":"application/resource-lists-diff+xml", _
			    "rs":"application/rls-services+xml", _
			    "rsd":"application/rsd+xml", _
			    "rss":"application/rss+xml", _
			    "rtf":"application/rtf", _
			    "sbml":"application/sbml+xml", _
			    "scq":"application/scvp-cv-request", _
			    "scs":"application/scvp-cv-response", _
			    "spq":"application/scvp-vp-request", _
			    "spp":"application/scvp-vp-response", _
			    "sdp":"application/sdp", _
			    "setpay":"application/set-payment-initiation", _
			    "setreg":"application/set-registration-initiation", _
			    "shf":"application/shf+xml", _
			    "smi":"application/smil+xml", _
			    "smil":"application/smil+xml", _
			    "rq":"application/sparql-query", _
			    "srx":"application/sparql-results+xml", _
			    "gram":"application/srgs", _
			    "grxml":"application/srgs+xml", _
			    "sru":"application/sru+xml", _
			    "ssml":"application/ssml+xml", _
			    "tei":"application/tei+xml", _
			    "teicorpus":"application/tei+xml", _
			    "tfi":"application/thraud+xml", _
			    "tsd":"application/timestamped-data", _
			    "plb":"application/vnd.3gpp.pic-bw-large", _
			    "psb":"application/vnd.3gpp.pic-bw-small", _
			    "pvb":"application/vnd.3gpp.pic-bw-var", _
			    "tcap":"application/vnd.3gpp2.tcap", _
			    "pwn":"application/vnd.3m.post-it-notes", _
			    "aso":"application/vnd.accpac.simply.aso", _
			    "imp":"application/vnd.accpac.simply.imp", _
			    "acu":"application/vnd.acucobol", _
			    "atc":"application/vnd.acucorp", _
			    "acutc":"application/vnd.acucorp", _
			    "air":"application/vnd.adobe.air-application-installer-package+zip", _
			    "fxp":"application/vnd.adobe.fxp", _
			    "fxpl":"application/vnd.adobe.fxp", _
			    "xdp":"application/vnd.adobe.xdp+xml", _
			    "xfdf":"application/vnd.adobe.xfdf", _
			    "ahead":"application/vnd.ahead.space", _
			    "azf":"application/vnd.airzip.filesecure.azf", _
			    "azs":"application/vnd.airzip.filesecure.azs", _
			    "azw":"application/vnd.amazon.ebook", _
			    "acc":"application/vnd.americandynamics.acc", _
			    "ami":"application/vnd.amiga.ami", _
			    "apk":"application/vnd.android.package-archive", _
			    "cii":"application/vnd.anser-web-certificate-issue-initiation", _
			    "fti":"application/vnd.anser-web-funds-transfer-initiation", _
			    "atx":"application/vnd.antix.game-component", _
			    "mpkg":"application/vnd.apple.installer+xml", _
			    "m3u8":"application/vnd.apple.mpegurl", _
			    "swi":"application/vnd.aristanetworks.swi", _
			    "aep":"application/vnd.audiograph", _
			    "mpm":"application/vnd.blueice.multipass", _
			    "bmi":"application/vnd.bmi", _
			    "rep":"application/vnd.businessobjects", _
			    "cdxml":"application/vnd.chemdraw+xml", _
			    "mmd":"application/vnd.chipnuts.karaoke-mmd", _
			    "cdy":"application/vnd.cinderella", _
			    "cla":"application/vnd.claymore", _
			    "rp9":"application/vnd.cloanto.rp9", _
			    "c4g":"application/vnd.clonk.c4group", _
			    "c4d":"application/vnd.clonk.c4group", _
			    "c4f":"application/vnd.clonk.c4group", _
			    "c4p":"application/vnd.clonk.c4group", _
			    "c4u":"application/vnd.clonk.c4group", _
			    "c11amc":"application/vnd.cluetrust.cartomobile-config", _
			    "c11amz":"application/vnd.cluetrust.cartomobile-config-pkg", _
			    "csp":"application/vnd.commonspace", _
			    "cdbcmsg":"application/vnd.contact.cmsg", _
			    "cmc":"application/vnd.cosmocaller", _
			    "clkx":"application/vnd.crick.clicker", _
			    "clkk":"application/vnd.crick.clicker.keyboard", _
			    "clkp":"application/vnd.crick.clicker.palette", _
			    "clkt":"application/vnd.crick.clicker.template", _
			    "clkw":"application/vnd.crick.clicker.wordbank", _
			    "wbs":"application/vnd.criticaltools.wbs+xml", _
			    "pml":"application/vnd.ctc-posml", _
			    "ppd":"application/vnd.cups-ppd", _
			    "car":"application/vnd.curl.car", _
			    "pcurl":"application/vnd.curl.pcurl", _
			    "rdz":"application/vnd.data-vision.rdz", _
			    "uvf":"application/vnd.dece.data", _
			    "uvvf":"application/vnd.dece.data", _
			    "uvd":"application/vnd.dece.data", _
			    "uvvd":"application/vnd.dece.data", _
			    "uvt":"application/vnd.dece.ttml+xml", _
			    "uvvt":"application/vnd.dece.ttml+xml", _
			    "uvx":"application/vnd.dece.unspecified", _
			    "uvvx":"application/vnd.dece.unspecified", _
			    "fe_launch":"application/vnd.denovo.fcselayout-link", _
			    "dna":"application/vnd.dna", _
			    "mlp":"application/vnd.dolby.mlp", _
			    "dpg":"application/vnd.dpgraph", _
			    "dfac":"application/vnd.dreamfactory", _
			    "ait":"application/vnd.dvb.ait", _
			    "svc":"application/vnd.dvb.service", _
			    "geo":"application/vnd.dynageo", _
			    "mag":"application/vnd.ecowin.chart", _
			    "nml":"application/vnd.enliven", _
			    "esf":"application/vnd.epson.esf", _
			    "msf":"application/vnd.epson.msf", _
			    "qam":"application/vnd.epson.quickanime", _
			    "slt":"application/vnd.epson.salt", _
			    "ssf":"application/vnd.epson.ssf", _
			    "es3":"application/vnd.eszigno3+xml", _
			    "et3":"application/vnd.eszigno3+xml", _
			    "ez2":"application/vnd.ezpix-album", _
			    "ez3":"application/vnd.ezpix-package", _
			    "fdf":"application/vnd.fdf", _
			    "mseed":"application/vnd.fdsn.mseed", _
			    "seed":"application/vnd.fdsn.seed", _
			    "dataless":"application/vnd.fdsn.seed", _
			    "gph":"application/vnd.flographit", _
			    "ftc":"application/vnd.fluxtime.clip", _
			    "fm":"application/vnd.framemaker", _
			    "frame":"application/vnd.framemaker", _
			    "maker":"application/vnd.framemaker", _
			    "book":"application/vnd.framemaker", _
			    "fnc":"application/vnd.frogans.fnc", _
			    "ltf":"application/vnd.frogans.ltf", _
			    "fsc":"application/vnd.fsc.weblaunch", _
			    "oas":"application/vnd.fujitsu.oasys", _
			    "oa2":"application/vnd.fujitsu.oasys2", _
			    "oa3":"application/vnd.fujitsu.oasys3", _
			    "fg5":"application/vnd.fujitsu.oasysgp", _
			    "bh2":"application/vnd.fujitsu.oasysprs", _
			    "ddd":"application/vnd.fujixerox.ddd", _
			    "xdw":"application/vnd.fujixerox.docuworks", _
			    "xbd":"application/vnd.fujixerox.docuworks.binder", _
			    "fzs":"application/vnd.fuzzysheet", _
			    "txd":"application/vnd.genomatix.tuxedo", _
			    "ggb":"application/vnd.geogebra.file", _
			    "ggt":"application/vnd.geogebra.tool", _
			    "gex":"application/vnd.geometry-explorer", _
			    "gre":"application/vnd.geometry-explorer", _
			    "gxt":"application/vnd.geonext", _
			    "g2w":"application/vnd.geoplan", _
			    "g3w":"application/vnd.geospace", _
			    "gmx":"application/vnd.gmx", _
			    "kml":"application/vnd.google-earth.kml+xml", _
			    "kmz":"application/vnd.google-earth.kmz", _
			    "gqf":"application/vnd.grafeq", _
			    "gqs":"application/vnd.grafeq", _
			    "gac":"application/vnd.groove-account", _
			    "ghf":"application/vnd.groove-help", _
			    "gim":"application/vnd.groove-identity-message", _
			    "grv":"application/vnd.groove-injector", _
			    "gtm":"application/vnd.groove-tool-message", _
			    "tpl":"application/vnd.groove-tool-template", _
			    "vcg":"application/vnd.groove-vcard", _
			    "hal":"application/vnd.hal+xml", _
			    "zmm":"application/vnd.handheld-entertainment+xml", _
			    "hbci":"application/vnd.hbci", _
			    "les":"application/vnd.hhe.lesson-player", _
			    "hpgl":"application/vnd.hp-hpgl", _
			    "hpid":"application/vnd.hp-hpid", _
			    "hps":"application/vnd.hp-hps", _
			    "jlt":"application/vnd.hp-jlyt", _
			    "pcl":"application/vnd.hp-pcl", _
			    "pclxl":"application/vnd.hp-pclxl", _
			    "sfd-hdstx":"application/vnd.hydrostatix.sof-data", _
			    "x3d":"application/vnd.hzn-3d-crossword", _
			    "mpy":"application/vnd.ibm.minipay", _
			    "afp":"application/vnd.ibm.modcap", _
			    "listafp":"application/vnd.ibm.modcap", _
			    "list3820":"application/vnd.ibm.modcap", _
			    "irm":"application/vnd.ibm.rights-management", _
			    "sc":"application/vnd.ibm.secure-container", _
			    "icc":"application/vnd.iccprofile", _
			    "icm":"application/vnd.iccprofile", _
			    "igl":"application/vnd.igloader", _
			    "ivp":"application/vnd.immervision-ivp", _
			    "ivu":"application/vnd.immervision-ivu", _
			    "igm":"application/vnd.insors.igm", _
			    "xpw":"application/vnd.intercon.formnet", _
			    "xpx":"application/vnd.intercon.formnet", _
			    "i2g":"application/vnd.intergeo", _
			    "qbo":"application/vnd.intu.qbo", _
			    "qfx":"application/vnd.intu.qfx", _
			    "rcprofile":"application/vnd.ipunplugged.rcprofile", _
			    "irp":"application/vnd.irepository.package+xml", _
			    "xpr":"application/vnd.is-xpr", _
			    "fcs":"application/vnd.isac.fcs", _
			    "jam":"application/vnd.jam", _
			    "rms":"application/vnd.jcp.javame.midlet-rms", _
			    "jisp":"application/vnd.jisp", _
			    "joda":"application/vnd.joost.joda-archive", _
			    "ktz":"application/vnd.kahootz", _
			    "ktr":"application/vnd.kahootz", _
			    "karbon":"application/vnd.kde.karbon", _
			    "chrt":"application/vnd.kde.kchart", _
			    "kfo":"application/vnd.kde.kformula", _
			    "flw":"application/vnd.kde.kivio", _
			    "kon":"application/vnd.kde.kontour", _
			    "kpr":"application/vnd.kde.kpresenter", _
			    "ksp":"application/vnd.kde.kspread", _
			    "kwd":"application/vnd.kde.kword", _
			    "htke":"application/vnd.kenameaapp", _
			    "kia":"application/vnd.kidspiration", _
			    "kne":"application/vnd.kinar", _
			    "skp":"application/vnd.koan", _
			    "sse":"application/vnd.kodak-descriptor", _
			    "lasxml":"application/vnd.las.las+xml", _
			    "lbd":"application/vnd.llamagraphics.life-balance.desktop", _
			    "lbe":"application/vnd.llamagraphics.life-balance.exchange+xml", _
			    "123":"application/vnd.lotus-1-2-3", _
			    "apr":"application/vnd.lotus-approach", _
			    "pre":"application/vnd.lotus-freelance", _
			    "nsf":"application/vnd.lotus-notes", _
			    "org":"application/vnd.lotus-organizer", _
			    "scm":"application/vnd.lotus-screencam", _
			    "lwp":"application/vnd.lotus-wordpro", _
			    "portpkg":"application/vnd.macports.portpkg", _
			    "mcd":"application/vnd.mcd", _
			    "mc1":"application/vnd.medcalcdata", _
			    "cdkey":"application/vnd.mediastation.cdkey", _
			    "mwf":"application/vnd.mfer", _
			    "mfm":"application/vnd.mfmp", _
			    "flo":"application/vnd.micrografx.flo", _
			    "igx":"application/vnd.micrografx.igx", _
			    "mif":"application/vnd.mif", _
			    "daf":"application/vnd.mobius.daf", _
			    "dis":"application/vnd.mobius.dis", _
			    "mbk":"application/vnd.mobius.mbk", _
			    "mqy":"application/vnd.mobius.mqy", _
			    "msl":"application/vnd.mobius.msl", _
			    "plc":"application/vnd.mobius.plc", _
			    "txf":"application/vnd.mobius.txf", _
			    "mpn":"application/vnd.mophun.application", _
			    "mpc":"application/vnd.mophun.certificate", _
			    "xul":"application/vnd.mozilla.xul+xml", _
			    "cil":"application/vnd.ms-artgalry", _
			    "cab":"application/vnd.ms-cab-compressed", _
			    "xls":"application/vnd.ms-excel", _
			    "xlm":"application/vnd.ms-excel", _
			    "xla":"application/vnd.ms-excel", _
			    "xlc":"application/vnd.ms-excel", _
			    "xlt":"application/vnd.ms-excel", _
			    "xlw":"application/vnd.ms-excel", _
			    "xlam":"application/vnd.ms-excel.addin.macroenabled.12", _
			    "xlsb":"application/vnd.ms-excel.sheet.binary.macroenabled.12", _
			    "xlsm":"application/vnd.ms-excel.sheet.macroenabled.12", _
			    "xltm":"application/vnd.ms-excel.template.macroenabled.12", _
			    "eot":"application/vnd.ms-fontobject", _
			    "chm":"application/vnd.ms-htmlhelp", _
			    "ims":"application/vnd.ms-ims", _
			    "lrm":"application/vnd.ms-lrm", _
			    "thmx":"application/vnd.ms-officetheme", _
			    "cat":"application/vnd.ms-pki.seccat", _
			    "stl":"application/vnd.ms-pki.stl", _
			    "ppt":"application/vnd.ms-powerpoint", _
			    "pps":"application/vnd.ms-powerpoint", _
			    "ppam":"application/vnd.ms-powerpoint.addin.macroenabled.12", _
			    "pptm":"application/vnd.ms-powerpoint.presentation.macroenabled.12", _
			    "sldm":"application/vnd.ms-powerpoint.slide.macroenabled.12", _
			    "ppsm":"application/vnd.ms-powerpoint.slideshow.macroenabled.12", _
			    "potm":"application/vnd.ms-powerpoint.template.macroenabled.12", _
			    "mpp":"application/vnd.ms-project", _
			    "mpt":"application/vnd.ms-project", _
			    "docm":"application/vnd.ms-word.document.macroenabled.12", _
			    "dotm":"application/vnd.ms-word.template.macroenabled.12", _
			    "wps":"application/vnd.ms-works", _
			    "wks":"application/vnd.ms-works", _
			    "wcm":"application/vnd.ms-works", _
			    "wdb":"application/vnd.ms-works", _
			    "wpl":"application/vnd.ms-wpl", _
			    "xps":"application/vnd.ms-xpsdocument", _
			    "mseq":"application/vnd.mseq", _
			    "mus":"application/vnd.musician", _
			    "msty":"application/vnd.muvee.style", _
			    "nlu":"application/vnd.neurolanguage.nlu", _
			    "nnd":"application/vnd.noblenet-directory", _
			    "nns":"application/vnd.noblenet-sealer", _
			    "nnw":"application/vnd.noblenet-web", _
			    "ngdat":"application/vnd.nokia.n-gage.data", _
			    "n-gage":"application/vnd.nokia.n-gage.symbian.install", _
			    "rpst":"application/vnd.nokia.radio-preset", _
			    "rpss":"application/vnd.nokia.radio-presets", _
			    "edm":"application/vnd.novadigm.edm", _
			    "edx":"application/vnd.novadigm.edx", _
			    "ext":"application/vnd.novadigm.ext", _
			    "odc":"application/vnd.oasis.opendocument.chart", _
			    "otc":"application/vnd.oasis.opendocument.chart-template", _
			    "odb":"application/vnd.oasis.opendocument.database", _
			    "odf":"application/vnd.oasis.opendocument.formula", _
			    "odft":"application/vnd.oasis.opendocument.formula-template", _
			    "odg":"application/vnd.oasis.opendocument.graphics", _
			    "otg":"application/vnd.oasis.opendocument.graphics-template", _
			    "odi":"application/vnd.oasis.opendocument.image", _
			    "oti":"application/vnd.oasis.opendocument.image-template", _
			    "odp":"application/vnd.oasis.opendocument.presentation", _
			    "otp":"application/vnd.oasis.opendocument.presentation-template", _
			    "ods":"application/vnd.oasis.opendocument.spreadsheet", _
			    "ots":"application/vnd.oasis.opendocument.spreadsheet-template", _
			    "odt":"application/vnd.oasis.opendocument.text", _
			    "odm":"application/vnd.oasis.opendocument.text-master", _
			    "ott":"application/vnd.oasis.opendocument.text-template", _
			    "oth":"application/vnd.oasis.opendocument.text-web", _
			    "xo":"application/vnd.olpc-sugar", _
			    "dd2":"application/vnd.oma.dd2+xml", _
			    "oxt":"application/vnd.openofficeorg.extension", _
			    "pptx":"application/vnd.openxmlformats-officedocument.presentationml.presentation", _
			    "sldx":"application/vnd.openxmlformats-officedocument.presentationml.slide", _
			    "ppsx":"application/vnd.openxmlformats-officedocument.presentationml.slideshow", _
			    "potx":"application/vnd.openxmlformats-officedocument.presentationml.template", _
			    "xlsx":"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", _
			    "xltx":"application/vnd.openxmlformats-officedocument.spreadsheetml.template", _
			    "docx":"application/vnd.openxmlformats-officedocument.wordprocessingml.document", _
			    "dotx":"application/vnd.openxmlformats-officedocument.wordprocessingml.template", _
			    "mgp":"application/vnd.osgeo.mapguide.package", _
			    "dp":"application/vnd.osgi.dp", _
			    "pdb":"application/vnd.palm", _
			    "paw":"application/vnd.pawaafile", _
			    "str":"application/vnd.pg.format", _
			    "ei6":"application/vnd.pg.osasli", _
			    "efif":"application/vnd.picsel", _
			    "wg":"application/vnd.pmi.widget", _
			    "plf":"application/vnd.pocketlearn", _
			    "pbd":"application/vnd.powerbuilder6", _
			    "box":"application/vnd.previewsystems.box", _
			    "mgz":"application/vnd.proteus.magazine", _
			    "qps":"application/vnd.publishare-delta-tree", _
			    "ptid":"application/vnd.pvi.ptid1", _
			    "qxd":"application/vnd.quark.quarkxpress", _
			    "bed":"application/vnd.realvnc.bed", _
			    "mxl":"application/vnd.recordare.musicxml", _
			    "musicxml":"application/vnd.recordare.musicxml+xml", _
			    "cryptonote":"application/vnd.rig.cryptonote", _
			    "cod":"application/vnd.rim.cod", _
			    "rm":"application/vnd.rn-realmedia", _
			    "link66":"application/vnd.route66.link66+xml", _
			    "st":"application/vnd.sailingtracker.track", _
			    "see":"application/vnd.seemail", _
			    "sema":"application/vnd.sema", _
			    "semd":"application/vnd.semd", _
			    "semf":"application/vnd.semf", _
			    "ifm":"application/vnd.shana.informed.formdata", _
			    "itp":"application/vnd.shana.informed.formtemplate", _
			    "iif":"application/vnd.shana.informed.interchange", _
			    "ipk":"application/vnd.shana.informed.package", _
			    "twd":"application/vnd.simtech-mindmapper", _
			    "mmf":"application/vnd.smaf", _
			    "teacher":"application/vnd.smart.teacher", _
			    "sdkm":"application/vnd.solent.sdkm+xml", _
			    "dxp":"application/vnd.spotfire.dxp", _
			    "sfs":"application/vnd.spotfire.sfs", _
			    "sdc":"application/vnd.stardivision.calc", _
			    "sda":"application/vnd.stardivision.draw", _
			    "sdd":"application/vnd.stardivision.impress", _
			    "smf":"application/vnd.stardivision.math", _
			    "sdw":"application/vnd.stardivision.writer", _
			    "sgl":"application/vnd.stardivision.writer-global", _
			    "sm":"application/vnd.stepmania.stepchart", _
			    "sxc":"application/vnd.sun.xml.calc", _
			    "stc":"application/vnd.sun.xml.calc.template", _
			    "sxd":"application/vnd.sun.xml.draw", _
			    "std":"application/vnd.sun.xml.draw.template", _
			    "sxi":"application/vnd.sun.xml.impress", _
			    "sti":"application/vnd.sun.xml.impress.template", _
			    "sxm":"application/vnd.sun.xml.math", _
			    "sxw":"application/vnd.sun.xml.writer", _
			    "sxg":"application/vnd.sun.xml.writer.global", _
			    "stw":"application/vnd.sun.xml.writer.template", _
			    "sus":"application/vnd.sus-calendar", _
			    "svd":"application/vnd.svd", _
			    "sis":"application/vnd.symbian.install", _
			    "xsm":"application/vnd.syncml+xml", _
			    "bdm":"application/vnd.syncml.dm+wbxml", _
			    "xdm":"application/vnd.syncml.dm+xml", _
			    "tao":"application/vnd.tao.intent-module-archive", _
			    "tmo":"application/vnd.tmobile-livetv", _
			    "tpt":"application/vnd.trid.tpt", _
			    "mxs":"application/vnd.triscape.mxs", _
			    "tra":"application/vnd.trueapp", _
			    "ufd":"application/vnd.ufdl", _
			    "utz":"application/vnd.uiq.theme", _
			    "umj":"application/vnd.umajin", _
			    "unityweb":"application/vnd.unity", _
			    "uoml":"application/vnd.uoml+xml", _
			    "vcx":"application/vnd.vcx", _
			    "vsd":"application/vnd.visio", _
			    "vis":"application/vnd.visionary", _
			    "vsf":"application/vnd.vsf", _
			    "wbxml":"application/vnd.wap.wbxml", _
			    "wmlc":"application/vnd.wap.wmlc", _
			    "wmlsc":"application/vnd.wap.wmlscriptc", _
			    "wtb":"application/vnd.webturbo", _
			    "nbp":"application/vnd.wolfram.player", _
			    "wpd":"application/vnd.wordperfect", _
			    "wqd":"application/vnd.wqd", _
			    "stf":"application/vnd.wt.stf", _
			    "xar":"application/vnd.xara", _
			    "xfdl":"application/vnd.xfdl", _
			    "hvd":"application/vnd.yamaha.hv-dic", _
			    "hvs":"application/vnd.yamaha.hv-script", _
			    "hvp":"application/vnd.yamaha.hv-voice", _
			    "osf":"application/vnd.yamaha.openscoreformat", _
			    "osfpvg":"application/vnd.yamaha.openscoreformat.osfpvg+xml", _
			    "saf":"application/vnd.yamaha.smaf-audio", _
			    "spf":"application/vnd.yamaha.smaf-phrase", _
			    "cmp":"application/vnd.yellowriver-custom-menu", _
			    "zir":"application/vnd.zul", _
			    "zaz":"application/vnd.zzazz.deck+xml", _
			    "vxml":"application/voicexml+xml", _
			    "wgt":"application/widget", _
			    "hlp":"application/winhlp", _
			    "wsdl":"application/wsdl+xml", _
			    "wspolicy":"application/wspolicy+xml", _
			    "7z":"application/x-7z-compressed", _
			    "abw":"application/x-abiword", _
			    "ace":"application/x-ace-compressed", _
			    "aab":"application/x-authorware-bin", _
			    "aam":"application/x-authorware-map", _
			    "aas":"application/x-authorware-seg", _
			    "bcpio":"application/x-bcpio", _
			    "torrent":"application/x-bittorrent", _
			    "bz":"application/x-bzip", _
			    "bz2":"application/x-bzip2", _
			    "vcd":"application/x-cdlink", _
			    "chat":"application/x-chat", _
			    "pgn":"application/x-chess-pgn", _
			    "cpio":"application/x-cpio", _
			    "csh":"application/x-csh", _
			    "deb":"application/x-debian-package", _
			    "dir":"application/x-director", _
			    "wad":"application/x-doom", _
			    "ncx":"application/x-dtbncx+xml", _
			    "dtb":"application/x-dtbook+xml", _
			    "res":"application/x-dtbresource+xml", _
			    "dvi":"application/x-dvi", _
			    "bdf":"application/x-font-bdf", _
			    "gsf":"application/x-font-ghostscript", _
			    "psf":"application/x-font-linux-psf", _
			    "otf":"application/x-font-otf", _
			    "pcf":"application/x-font-pcf", _
			    "snf":"application/x-font-snf", _
			    "ttf":"application/x-font-ttf", _
			    "pfa":"application/x-font-type1", _
			    "woff":"application/x-font-woff", _
			    "spl":"application/x-futuresplash", _
			    "gnumeric":"application/x-gnumeric", _
			    "gtar":"application/x-gtar", _
			    "hdf":"application/x-hdf", _
			    "jnlp":"application/x-java-jnlp-file", _
			    "latex":"application/x-latex", _
			    "prc":"application/x-mobipocket-ebook", _
			    "mobi":"application/x-mobipocket-ebook", _
			    "m3u8":"application/x-mpegurl", _
			    "application":"application/x-ms-application", _
			    "wmd":"application/x-ms-wmd", _
			    "wmz":"application/x-ms-wmz", _
			    "xbap":"application/x-ms-xbap", _
			    "mdb":"application/x-msaccess", _
			    "obd":"application/x-msbinder", _
			    "crd":"application/x-mscardfile", _
			    "clp":"application/x-msclip", _
			    "exe":"application/x-msdownload", _
			    "dll":"application/x-msdownload", _
			    "com":"application/x-msdownload", _
			    "bat":"application/x-msdownload", _
			    "msi":"application/x-msdownload", _
			    "mvb":"application/x-msmediaview", _
			    "wmf":"application/x-msmetafile", _
			    "mny":"application/x-msmoney", _
			    "pub":"application/x-mspublisher", _
			    "scd":"application/x-msschedule", _
			    "trm":"application/x-msterminal", _
			    "wri":"application/x-mswrite", _
			    "nc":"application/x-netcdf", _
			    "p12":"application/x-pkcs12", _
			    "p7b":"application/x-pkcs7-certificates", _
			    "p7r":"application/x-pkcs7-certreqresp", _
			    "rar":"application/x-rar-compressed", _
			    "sh":"application/x-sh", _
			    "shar":"application/x-shar", _
			    "swf":"application/x-shockwave-flash", _
			    "xap":"application/x-silverlight-app", _
			    "sit":"application/x-stuffit", _
			    "sitx":"application/x-stuffitx", _
			    "sv4cpio":"application/x-sv4cpio", _
			    "sv4crc":"application/x-sv4crc", _
			    "tar":"application/x-tar", _
			    "tcl":"application/x-tcl", _
			    "tex":"application/x-tex", _
			    "tfm":"application/x-tex-tfm", _
			    "texi":"application/x-texinfo", _
			    "texinfo":"application/x-texinfo", _
			    "ustar":"application/x-ustar", _
			    "src":"application/x-wais-source", _
			    "crt":"application/x-x509-ca-cert", _
			    "der":"application/x-x509-ca-cert", _
			    "fig":"application/x-xfig", _
			    "xpi":"application/x-xpinstall", _
			    "xdf":"application/xcap-diff+xml", _
			    "xenc":"application/xenc+xml", _
			    "xht":"application/xhtml+xml", _
			    "xhtml":"application/xhtml+xml", _
			    "xsl":"application/xml", _
			    "xml":"application/xml", _
			    "dtd":"application/xml-dtd", _
			    "xop":"application/xop+xml", _
			    "xslt":"application/xslt+xml", _
			    "xspf":"application/xspf+xml", _
			    "mxml":"application/xv+xml", _
			    "yang":"application/yang", _
			    "yin":"application/yin+xml", _
			    "zip":"application/zip", _
			    "adp":"audio/adpcm", _
			    "snd":"audio/basic", _
			    "au":"audio/basic", _
			    "midi":"audio/midi", _
			    "mid":"audio/midi", _
			    "mp4a":"audio/mp4", _
			    "m4p":"audio/mp4a-latm", _
			    "m4a":"audio/mp4a-latm", _
			    "mpga":"audio/mpeg", _
			    "mp2":"audio/mpeg", _
			    "mp2a":"audio/mpeg", _
			    "mp3":"audio/mpeg", _
			    "m2a":"audio/mpeg", _
			    "m3a":"audio/mpeg", _
			    "oga":"audio/ogg", _
			    "ogg":"audio/ogg", _
			    "spx":"audio/ogg", _
			    "weba":"audio/webm", _
			    "aac":"audio/x-aac", _
			    "aif":"audio/x-aiff", _
			    "aiff":"audio/x-aiff", _
			    "aifc":"audio/x-aiff", _
			    "m3u":"audio/x-mpegurl", _
			    "wax":"audio/x-ms-wax", _
			    "wma":"audio/x-ms-wma", _
			    "ram":"audio/x-pn-realaudio", _
			    "ra":"audio/x-pn-realaudio", _
			    "rmp":"audio/x-pn-realaudio-plugin", _
			    "wav":"audio/x-wav", _
			    "cdx":"chemical/x-cdx", _
			    "cif":"chemical/x-cif", _
			    "cmdf":"chemical/x-cmdf", _
			    "cml":"chemical/x-cml", _
			    "csml":"chemical/x-csml", _
			    "xyz":"chemical/x-xyz", _
			    "bmp":"image/bmp", _
			    "cgm":"image/cgm", _
			    "g3":"image/g3fax", _
			    "gif":"image/gif", _
			    "ief":"image/ief", _
			    "jp2":"image/jp2", _
			    "jpeg":"image/jpeg", _
			    "jpg":"image/jpeg", _
			    "jpe":"image/jpeg", _
			    "ktx":"image/ktx", _
			    "pict":"image/pict", _
			    "pic":"image/pict", _
			    "pct":"image/pict", _
			    "png":"image/png", _
			    "btif":"image/prs.btif", _
			    "svg":"image/svg+xml", _
			    "tiff":"image/tiff", _
			    "tiff":"image/tiff", _
			    "psd":"image/vnd.adobe.photoshop", _
			    "uvi":"image/vnd.dece.graphic", _
			    "sub":"image/vnd.dvb.subtitle", _
			    "djvu":"image/vnd.djvu", _
			    "dwg":"image/vnd.dwg", _
			    "dxf":"image/vnd.dxf", _
			    "fbs":"image/vnd.fastbidsheet", _
			    "fpx":"image/vnd.fpx", _
			    "fst":"image/vnd.fst", _
			    "mmr":"image/vnd.fujixerox.edmics-mmr", _
			    "rlc":"image/vnd.fujixerox.edmics-rlc", _
			    "mdi":"image/vnd.ms-modi", _
			    "npx":"image/vnd.net-fpx", _
			    "wbmp":"image/vnd.wap.wbmp", _
			    "xif":"image/vnd.xiff", _
			    "webp":"image/webp", _
			    "ras":"image/x-cmu-raster", _
			    "cmx":"image/x-cmx", _
			    "fh":"image/x-freehand", _
			    "ico":"image/x-icon", _
			    "pntg":"image/x-macpaint", _
			    "pnt":"image/x-macpaint", _
			    "mac":"image/x-macpaint", _
			    "pcx":"image/x-pcx", _
			    "pnm":"image/x-portable-anymap", _
			    "pbm":"image/x-portable-bitmap", _
			    "pgm":"image/x-portable-graymap", _
			    "ppm":"image/x-portable-pixmap", _
			    "qti":"image/x-quicktime", _
			    "qtif":"image/x-quicktime", _
			    "rgb":"image/x-rgb", _
			    "xbm":"image/x-xbitmap", _
			    "xpm":"image/x-xpixmap", _
			    "xwd":"image/x-xwindowdump", _
			    "mime":"message/rfc822", _
			    "eml":"message/rfc822", _
			    "igs":"model/iges", _
			    "msh":"model/mesh", _
			    "dae":"model/vnd.collada+xml", _
			    "dwf":"model/vnd.dwf", _
			    "gdl":"model/vnd.gdl", _
			    "gtw":"model/vnd.gtw", _
			    "mts":"model/vnd.mts", _
			    "vtu":"model/vnd.vtu", _
			    "vrml":"model/vrml", _
			    "manifest":"text/cache-manifest", _
			    "ics":"text/calendar", _
			    "css":"text/css", _
			    "csv":"text/csv", _
			    "html":"text/html", _
			    "htm":"text/html", _
			    "bs":"text/html", _
			    "n3":"text/n3", _
			    "txt":"text/plain", _
			    "text":"text/plain", _
			    "conf":"text/plain", _
			    "def":"text/plain", _
			    "list":"text/plain", _
			    "log":"text/plain", _
			    "in":"text/plain", _
			    "md":"text/plain", _
			    "dsc":"text/prs.lines.tag", _
			    "rtx":"text/richtext", _
			    "sgml":"text/sgml", _
			    "tsv":"text/tab-separated-values", _
			    "t":"text/troff", _
			    "tr":"text/troff", _
			    "roff":"text/troff", _
			    "ttl":"text/turtle", _
			    "uri":"text/uri-list", _
			    "uris":"text/uri-list", _
			    "urls":"text/uri-list", _
			    "curl":"text/vnd.curl", _
			    "dcurl":"text/vnd.curl.dcurl", _
			    "scurl":"text/vnd.curl.scurl", _
			    "mcurl":"text/vnd.curl.mcurl", _
			    "fly":"text/vnd.fly", _
			    "flx":"text/vnd.fmi.flexstor", _
			    "gv":"text/vnd.graphviz", _
			    "3dml":"text/vnd.in3d.3dml", _
			    "spot":"text/vnd.in3d.spot", _
			    "jad":"text/vnd.sun.j2me.app-descriptor", _
			    "wml":"text/vnd.wap.wml", _
			    "wmls":"text/vnd.wap.wmlscript", _
			    "asm":"text/x-asm", _
			    "c":"text/x-c", _
			    "cc":"text/x-c", _
			    "cxx":"text/x-c", _
			    "cpp":"text/x-c", _
			    "h":"text/x-c", _
			    "pas":"text/x-pascal", _
			    "java":"text/x-java-source", _
			    "etx":"text/x-setext", _
			    "uu":"text/x-uuencode", _
			    "vcs":"text/x-vcalendar", _
			    "vcf":"text/x-vcard", _
			    "3gp":"video/3gpp", _
			    "3g2":"video/3gpp2", _
			    "h261":"video/h261", _
			    "h263":"video/h263", _
			    "h264":"video/h264", _
			    "jpgv":"video/jpeg", _
			    "jpm":"video/jpm", _
			    "mj2":"video/mj2", _
			    "ts":"video/mp2t", _
			    "mp4":"video/mp4", _
			    "mp4v":"video/mp4", _
			    "mpg4":"video/mp4", _
			    "m4v":"video/mp4", _
			    "mpeg":"video/mpeg", _
			    "mpg":"video/mpeg", _
			    "mpe":"video/mpeg", _
			    "m1v":"video/mpeg", _
			    "m2v":"video/mpeg", _
			    "ogv":"video/ogg", _
			    "mov":"video/quicktime", _
			    "qt":"video/quicktime", _
			    "uvh":"video/vnd.dece.hd", _
			    "uvm":"video/vnd.dece.mobile", _
			    "uvp":"video/vnd.dece.pd", _
			    "uvs":"video/vnd.dece.sd", _
			    "uvv":"video/vnd.dece.video", _
			    "fvt":"video/vnd.fvt", _
			    "mxu":"video/vnd.mpegurl", _
			    "pyv":"video/vnd.ms-playready.media.pyv", _
			    "uvu":"video/vnd.uvvu.mp4", _
			    "viv":"video/vnd.vivo", _
			    "dif":"video/x-dv", _
			    "dv":"video/x-dv", _
			    "webm":"video/webm", _
			    "f4v":"video/x-f4v", _
			    "fli":"video/x-fli", _
			    "flv":"video/x-flv", _
			    "m4v":"video/x-m4v", _
			    "rbp":"application/x-REALbasic-Project", _
			    "rbbas":"application/x-REALbasic-Project", _
			    "rbvcp":"application/x-REALbasic-Project", _
			    "rbo":"application/x-REALbasic-Project", _
			    "asx":"video/x-ms-asf", _
			    "asf":"video/x-ms-asf", _
			    "wm":"video/x-ms-wm", _
			    "wmv":"video/x-ms-wmv", _
			    "wmx":"video/x-ms-wmx", _
			    "wvx":"video/x-ms-wvx", _
			    "avi":"video/x-msvideo", _
			    "movie":"video/x-sgi-movie", _
			    "ice":"x-conference/x-cooltalk")
			  End If
			  return mMIMETypes
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mMIMETypes = value
			End Set
		#tag EndSetter
		Protected MIMETypes As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mMIMETypes As Dictionary
	#tag EndProperty


	#tag Constant, Name = DaemonVersion, Type = String, Dynamic = False, Default = \"BoredomServe/1.0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GZIPAvailable, Type = Boolean, Dynamic = False, Default = \"True", Scope = Public
	#tag EndConstant


	#tag Structure, Name = FILETIME, Flags = &h0
		HighDateTime As Integer
		LowDateTime As Integer
	#tag EndStructure

	#tag Structure, Name = WIN32_FIND_DATA, Flags = &h0
		Attribs As Integer
		  CreationTime As FILETIME
		  LastAccess As FILETIME
		  LastWrite As FILETIME
		  sizeHigh As Integer
		  sizeLow As Integer
		  Reserved1 As Integer
		  Reserved2 As Integer
		  FileName As WString*260
		AlternateName As String*14
	#tag EndStructure


	#tag Enum, Name = ConnectionTypes, Flags = &h0
		SSLv3
		  TLSv1
		Insecure
	#tag EndEnum


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