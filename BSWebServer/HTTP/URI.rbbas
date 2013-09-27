#tag Class
Protected Class URI
	#tag Method, Flags = &h0
		Sub Constructor(URL As String)
		  Parse(URL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Operator_Convert() As String
		  Return Me.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Parent() As HTTP.URI
		  Dim parent() As String = Split(ServerPath, "/")
		  If UBound(parent) > -1 Then
		    While parent.Pop.Trim = ""
		      App.YieldToNextThread
		    Wend
		  End If
		  Dim s As String = Join(parent, "/").Trim
		  If s = "" Then s = "/"
		  Return New URI(s)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Parse(URL As String)
		  //The Parse method accepts a string as input and parses that string as a URI into the various class properties.
		  
		  If NthField(URL, ":", 1) <> "mailto" Then
		    If InStr(URL, "://") > 0 Then
		      Protocol = NthField(URL, "://", 1)
		      URL = URL.Replace(Protocol + "://", "")
		    End If
		    
		    If Instr(URL, "@") > 0 Then //  USER:PASS@Domain
		      Username = NthField(URL, ":", 1)
		      URL = URL.Replace(Username + ":", "")
		      
		      Password = NthField(URL, "@", 1)
		      URL = URL.Replace(Password + "@", "")
		    End If
		    
		    If Instr(URL, ":") > 0 Then //  Domain:Port
		      Dim s As String = NthField(URL, ":", 2)
		      s = NthField(s, "?", 1)
		      Port = Val(s)
		      
		      URL = URL.Replace(":" + Format(Port, "######"), "")
		    End If
		    
		    If Instr(URL, "#") > 0 Then
		      Fragment = NthField(URL, "#", 2)  //    #fragment
		      URL = URL.Replace("#" + Fragment, "")
		    End If
		    
		    FQDN = NthField(URL, "/", 1)  //  [sub.]domain.tld
		    URL = URL.Replace(FQDN, "")
		    
		    If InStr(URL, "?") > 0 Then
		      ServerPath = NthField(URL, "?", 1)  //    /foo/bar.php
		      URL = URL.Replace(ServerPath + "?", "")
		      Arguments = Split(URL, "&")
		    ElseIf URL.Trim <> "" Then
		      ServerPath = URL.Trim
		    End If
		    ServerPath = ReplaceAll(ServerPath, "/..", "") 'prevent directory traversal
		  Else
		    Protocol = "mailto"
		    URL = Replace(URL, "mailto:", "")
		    Username = NthField(URL, "@", 1)
		    URL = Replace(URL, Username + "@", "")
		    
		    If InStr(URL, "?") > 0 Then
		      FQDN = NthField(URL, "?", 1)
		      Arguments = Split(NthField(URL, "?", 2), "&")
		    Else
		      FQDN = URL
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Dim URL As String
		  If Protocol = "mailto" Then
		    URL = "mailto:"
		  Else
		    If Protocol <> "" Then URL = Protocol + "://"
		  End If
		  
		  If Username <> "" Then
		    URL = URL + Username
		    If Password <> "" Then URL = URL + ":" + Password
		    URL = URL + "@"
		  End If
		  
		  URL = URL + FQDN
		  
		  If Port <> 0 Then //port specified
		    URL = URL + ":" + Format(Port, "#####")
		  End If
		  
		  If ServerPath.Trim <> "" Then
		    URL = URL + ServerPath.Trim
		  Else
		    If Protocol <> "mailto" Then URL = URL + "/"
		  End If
		  
		  If Arguments.Ubound > -1 Then
		    Dim args As String = "?"
		    Dim acount As Integer = UBound(Arguments)
		    For i As Integer = 0 To acount
		      If i > 0 Then args = args + "&"
		      args = args + HTTP.Helpers.URLEncode(Arguments(i))
		    Next
		    URL = URL + args
		  End If
		  
		  If Fragment <> "" Then
		    URL = URL + "#" + Fragment
		  End If
		  If URL.Trim = "" Then URL = "/"
		  Return URL
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		#tag Note
			The arguments represent the query string part of the URI.
			
			e.g.
			
			http://example.net/index.html?QUERYSTRING
			
			Each argument in the query string is delimited by an ampersang (&):
			
			http://example.net/index.html?QUERYSTRING1&QUERYSTRING2=2&QUERYSTRING3
			
			Arguments are stored and returned in the same order they are received as an
			array of strings. When converted to a string, the URI class uses the Join
			method on the array with an ampersand as the delimiter. Ampersands are stripped
			from strings being converted to URIs.
		#tag EndNote
		Arguments() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		CaseSensitive As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The Fully-Qualified Domain Name.
			
			e.g.
			
			sub.domain.tld
			domain.tld
			sub1.sub2.->sub[n].domain.tld
			sub.domain.co.tld
		#tag EndNote
		FQDN As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The URI fragment, or anchor.
			
			e.g.
			
			www.example.net/contents.html#FRAGMENT
		#tag EndNote
		Fragment As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The password is never present without a Username and will be ignored if the Username is not set.
			
			mailto URIs never have a password part.
		#tag EndNote
		Password As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Specifies the port number part of the URI. If this property is 0 then it's ignored for conversion/comparison purposes.
			
			e.g.
			
			Dim url1 As New URI("http://www.example.net")
			Dim url2 As New URI("http://www.example.net")
			url2.Port = 0
			
			url1 and url2 would still be equivalent since converting them to strings yields the same result "http://www.example.net"
			
			However,
			
			Dim url1 As New URI("http://www.example.net")
			Dim url2 As New URI("http://www.example.net")
			url2.Port = 80
			
			in this case, url1 and url2 are not equal since url1 converts to "http://www.example.net" whereas
			url2 converts to "http://www.example.net:80"
			
			This class does not know about default ports and will explicitly specify any port assigned, even the default
			port for the specified protocol. To indicate the default port, then, just set the port to 0 or don't set it at all.
		#tag EndNote
		Port As Integer = 80
	#tag EndProperty

	#tag Property, Flags = &h0
		Protocol As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The full remote file path, if any
			
			e.g.
			
			/dir/dir2/dir3/dir4/file.ext
			/search.php
			/files/download.asp
			/index.html
			/  (top directory or default page, same as empty string)
			"" (empty string)
		#tag EndNote
		ServerPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Username As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="CaseSensitive"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FQDN"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fragment"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
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
			Name="Password"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Group="Behavior"
			InitialValue="80"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Protocol"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ServerPath"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Username"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
