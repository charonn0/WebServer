#tag Class
Protected Class URLShortener
Inherits HTTP.BaseServer
	#tag Event
		Function HandleRequest(ClientRequest As HTTP.Request) As HTTP.Response
		  Dim doc As HTTP.Response
		  
		  Select Case ClientRequest.Method
		  Case RequestMethod.GET, RequestMethod.HEAD
		    If ClientRequest.Path.ServerPath = "/Create" Then
		      doc = GetNewResponse
		      doc.StatusCode = 200
		      doc.Path = New URI(ClientRequest.Path)
		      doc.MessageBody = ReplaceAll(NEWURLPAGE, "%SIGNATURE%", "<em>Powered By " + WebServer.DaemonVersion + "</em><br />")
		      doc.MIMEType = New ContentType("text/html")
		      If ClientRequest.Method = RequestMethod.HEAD Then
		        doc.MessageBody = ""
		      End If
		    Else
		      doc = ClickShortURL(ClientRequest.Path)
		    End If
		    
		  Case RequestMethod.POST
		    Dim formdata As Dictionary = HTTP.Helpers.DecodeFormData(ClientRequest.MessageBody)
		    doc = CreateShortURL(formdata.Value("ShortName"), formdata.Value("URL"))
		    doc.Method = RequestMethod.POST
		  End Select
		  
		  Return doc
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Function ClickShortURL(ShortPath As String) As Response
		  Dim doc As Response
		  If Left(Shortpath, 1) = "/" Then Shortpath = Replace(Shortpath, "/", "")
		  If Me.Redirects.HasKey(Shortpath) Then
		    doc = Me.Redirects.Value(Shortpath)
		    
		  Else
		    doc = GetErrorResponse(404, ShortPath)
		  End If
		  
		  Return doc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  Dim creator As HTTP.Response
		  creator = GetRedirectResponse("/", "/Create")
		  Me.AddRedirect(creator)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateShortURL(ShortPath As String, Location As String) As Response
		  Me.Redirects.Value(ShortPath) = GetRedirectResponse(ShortPath, Location)
		  Return Me.Redirects.Value(ShortPath)
		End Function
	#tag EndMethod


	#tag Constant, Name = NEWURLPAGE, Type = String, Dynamic = False, Default = \"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r<html xmlns\x3D\"http://www.w3.org/1999/xhtml\">\r<head>\r<meta http-equiv\x3D\"Content-Type\" content\x3D\"text/html; charset\x3Diso-8859-1\" />\r<title>URL Shortener</title>\r<style type\x3D\"text/css\">\r<!--\rbody\x2Ctd\x2Cth {\r\tfont-family: Arial\x2C Helvetica\x2C sans-serif;\r\tfont-size: medium;\r}\ra:link {\r\tcolor: #0000FF;\r\ttext-decoration: none;\r}\ra:visited {\r\ttext-decoration: none;\r\tcolor: #990000;\r}\ra:hover {\r\ttext-decoration: underline;\r\tcolor: #009966;\r}\ra:active {\r\ttext-decoration: none;\r\tcolor: #FF0000;\r}\r-->\r</style></head>\r\r<body>\r\t\t<form action\x3D\"/Create\" enctype\x3D\"application/x-www-form-urlencoded\" id\x3D\"URLs\" method\x3D\"post\" name\x3D\"URLs\" target\x3D\"_self\">\r\t\t\t<br />\r\t\t\t<input maxlength\x3D\"25\" name\x3D\"ShortName\" size\x3D\"25\" type\x3D\"text\" />&nbsp; <input maxlength\x3D\"255\" name\x3D\"URL\" size\x3D\"50\" type\x3D\"text\" value\x3D\"http://\" /> <input name\x3D\"Submit\" type\x3D\"submit\" value\x3D\"Shorten\" />&nbsp;</form>\r\t\t\t<br />\r<hr />\r<p>%SIGNATURE%</p>\r</body>\r</html>", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AuthenticationRealm"
			Visible=true
			Group="Behavior"
			InitialValue="Restricted Area"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTP.BaseServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthenticationRequired"
			Visible=true
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="HTTP.BaseServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CertificatePassword"
			Visible=true
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTP.BaseServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EnforceContentType"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="HTTP.BaseServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumSocketsConnected"
			Visible=true
			Group="Behavior"
			InitialValue="10"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumSocketsAvailable"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="ServerSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionTimeout"
			Visible=true
			Group="Behavior"
			InitialValue="600"
			Type="Integer"
			InheritedFrom="HTTP.BaseServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Threading"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="HTTP.BaseServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseCompression"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="HTTP.BaseServer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseSessions"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="HTTP.BaseServer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
