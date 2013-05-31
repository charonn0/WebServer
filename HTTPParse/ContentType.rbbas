#tag Class
Protected Class ContentType
	#tag Method, Flags = &h0
		Function Accepts(OtherType As HTTPParse.ContentType) As Boolean
		  If OtherType.SuperType <> Me.SuperType And OtherType.SuperType <> "*" And Me.SuperType <> "*" Then Return False
		  If OtherType.SubType <> Me.SubType And OtherType.SubType <> "*" And Me.SubType <> "*"Then Return False
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub AddMIMEType(FileExtension As String, MIMEName As String)
		  MIMETypes.Value(FileExtension) = MIMEName
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

	#tag Method, Flags = &h1
		Protected Shared Function GetType(File As FolderItem) As ContentType
		  If File.Directory Then
		    Return MIMETypes.Value("text/html")
		  Else
		    Return GetType(File.Name)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function GetType(FileName As String) As ContentType
		  Dim ext As String = NthField(FileName, ".", CountFields(FileName, "."))
		  If MIMETypes.HasKey(ext) Then
		    Return New ContentType(MIMETypes.Value(ext).StringValue)
		  End If
		  Return New ContentType("application/octet-stream")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function MIMEIcon(ext As String) As String
		  'This method is from here: https://github.com/bskrtich/RBHTTPServer
		  ext = Lowercase(ext)
		  
		  Select Case ext
		  Case "exe", "com", "scr", "pif", "dll", "deb", "rpm"
		    Return MIMEIcon_Binary
		    
		  Case "js", "cs", "c", "h", "vbs", "vbe", "bat", "cmd", "sh", "ini", "reg"
		    Return MIMEIcon_Script
		    
		  Case "rbp", "rbbas", "rbvcp", "rbfrm", "rbres"
		    Return MIMEIcon_RBP
		    
		  Case "folder"
		    Return MIMEIcon_Folder
		    
		  Case "txt", "md"
		    Return MIMEIcon_Text
		    
		  Case "htm", "html"
		    Return MIMEIcon_HTML
		    
		  Case "css"
		    Return MIMEIcon_CSS
		    
		  Case "xml", "xsl"
		    Return MIMEIcon_XML
		    
		  Case "jpg", "jpeg", "png", "bmp", "gif", "tif"
		    Return MIMEIcon_Image
		    
		  Case "mov", "mp4", "m4v", "avi", "mpg", "mpeg", "wmv", "mkv"
		    Return MIMEIcon_Movie
		    
		  Case "ttf", "otf", "pfb", "pfm"
		    Return MIMEIcon_Font
		    
		  Case "zip", "tar", "rar", "7zip", "bzip", "gzip", "7z", "tgz", "gz", "z"
		    Return MIMEIcon_Compressed
		    
		  Case "wav"
		    Return MIMEIcon_WAV
		    
		  Case "mp3", "m4a", "m4b", "m4p", "ogg", "flac"
		    Return MIMEIcon_Music
		    
		  Case "pdf", "ps"
		    Return MIMEIcon_PDF
		    
		  Case "xls", "xlsx"
		    Return MIMEIcon_XLS
		    
		  Case "doc", "docx"
		    Return MIMEIcon_DOC
		    
		  Else ' This returns the default icon
		    Return MIMEIcon_Unknown
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub RemoveMIMEType(FileExtension As String)
		  If MIMETypes.HasKey(FileExtension) Then
		    MIMETypes.Remove(FileExtension)
		  End If
		End Sub
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
			    "pdf":"application/pdf", _
			    "pdb":"application/vnd.palm", _
			    "paw":"application/vnd.pawaafile", _
			    "gz":"application/gzip", _
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
			    "reg":"application/x-msdownload", _
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
			    "xht":"application/xhtml+xml; charset=utf-8", _
			    "xhtml":"application/xhtml+xml; charset=utf-8", _
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
			    "html":"text/html; charset=utf-8", _
			    "htm":"text/html; charset=utf-8", _
			    "bs":"text/html; charset=utf-8", _
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
		Protected Shared MIMETypes As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Shared mMIMETypes As Dictionary
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


	#tag Constant, Name = MIMEIcon_Binary, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAQAAABuvaSwAAAAAmJLR0QAAKqNIzIAAAAJcEhZcwAA\rDdYAAA3WAZBveZwAAAAJdnBBZwAAABYAAAAWANzF6VgAAAI+SURBVCjP1dNPSJNhHAfw7/Nse/fu\rnc7NNraMmc4KhoiHAhvhxRLxOKpDsy7SJbpE0CE8BR0KDLoVVHaotLCDIARdLPIQWVrUCkq3TLep\r2965P++7d++2d0+H9odCCLr1XH7w8OHhC7/vA/x/h/x5EajOyb/hu1g1Xi3O99lOsVJ2+spbn8Gl\rntsJH8Q7TBzouVycFYy7H4KKo/kCBj9dH/3ah4Wq0dXwGF56fVPuYaO3kG45TEg21nraPtQyMPPR\rv6YhCACgvyjDKpUTLEpg7uEvrhsihD8rdFPoyiw1p5/CUQCAHgBOgtAnl/qbQnPpgaig8BZUsMFZ\r4Na2Z/zHF6zPxxyFOrYh4HSc0Xd75G+8CV5UQACsIEo9F3RNLnHoEbdUj9GOLq/VTZA3E9qOBFuP\rR8QcOqES2SIRHW/v9SFQwzzY+3ggNJOGCSmIkWa/eURMSuARRfDB8qDy1NTIXAKhhoqU5UCRhcw9\rc9tYJyg0KCh0qf3S5qvcZA3HUdqbmnC5ytBQhuZ039dBNTEAOZSP5HrlRfVH/eUYPgfd8xgubu3y\rEFICNTEoMCCjbcSYPbWSDHKNGCJGipvj5nuJNsftDs4KFQCPNEJa5ib3JSOExX2/r/s8tA7ntPEQ\r1ayypZmRdCojML4cSp7gPtyoGlrDKgpiblZNa68j18Ll79i6VXmsqdILJZGvF0nfaBwk5/ixZSbZ\rPK0aIVl9+I7tzeJ0cHvninIwQ4Cwv22PkzMkk0trkKFAhgL2Dz/lJyyu5Cr8XCplAAAAJXRFWHRk\rYXRlOmNyZWF0ZQAyMDEwLTA1LTI0VDA3OjQyOjIwLTA2OjAwPLYQbgAAACV0RVh0ZGF0ZTptb2Rp\rZnkAMjAxMC0wNS0yNFQwNzo0MjoyMC0wNjowME3rqNIAAAA1dEVYdExpY2Vuc2UAaHR0cDovL2Ny\rZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQTC8yLjEvO8G0GAAAABl0RVh0U29mdHdhcmUA\rd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAPdEVYdFNvdXJjZQBudW92ZVhUMuogNtwAAAAidEVYdFNv\rdXJjZV9VUkwAaHR0cDovL251b3ZleHQucHdzcC5uZXSRicctAAAAAElFTkSuQmCC", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Compressed, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADuklEQVQ4y7WV22tcRRzHPzN7\r9uzJbm6b3bS2SRNJNLEtghhqjYIQUi1Kn+uTDxJQyENQCOKLL6IoPvik+KL/gg/SCIWCIJgUkeiS\rNObSpOZSkibZzWV3z+6cOeeMD7knm4qIPxhmBobPfObLDCOMMfwfZe0NhBDNwIX/yFs0xiwdAQPN\rrlsa1lojBCAEQggEu+PD/YHNgWEkgm3b3cAJsCgrRalUQkqBlHIHfLwd22i/bBs42PcwGCl2gJXA\rSikcx0EKUREsxJGzHAULKYhEdoBSCG798D3ba3/hSMXZdA0/3Z2iqbmZ2uQZ0mcv8NrrN9jTfDx4\r105KyZ3bQ7zQFiFobcUtlXGLLqVCjpZ0Kx1tCaxonju3f+T6Llz+E1hKST6fR62NU25oYWJqlnt/\rzjExM0+sKsHC4iOazzVSF43irWUolXpJJBInjMXePRZCdBeKxWHP8/j2q89IWVlKZYUODGXlU1Y+\rruuCCVFaY8kI9bUJnPTTvPfhp0gpsSzrJWPMyEnj3SM5ToxXrl45YqA8jVIapTx8rfC9MoHvMbES\r3Y/w1CjeevsDEok4wni4RUP3symeSMXQfoDWPtoPCEMfrQMeLJeZWtIsb/q82/8RfhCeHsXk5Nyw\rWy4xMzVJfiPL/NI6jiO48pSktkoS+Jrf5wK0lWQzu0F76xkam9tpaX0SKQUXn2mvHEVuc5utrU02\rNrI0JaNc7niO8el57k6v83BxFuWFnD9/jo62RjovtKDcbdxiAeUFeJ53ehQxx6GWemw7zurKPI9W\rlkgm04yvLvP5F18yc3+a7775mmK9YHY1ACNp67qMEALHcY6A5eFJREqqYg71yRQmDCE0ZFeX2dxY\rxfd9AArbOSIIpBQEGFzXJQj8vUdoKhpjDDIiuTcxQTwsUyqVMSZkfS3H4sICvqcJkeTyioKrsJ04\r+sEsdbUJpCALrFYE5wsFampq6O3tJZPJENUat1gEew7P99CBhxVvhHgTn3z8/q6LYXR0VPf19b1h\rjJmrbIyhWCxQV1dPT08PQgg8TzE/f5+hoVu4rktHZyfPd3XtQ8fGxvyBgYFrmUzm11MzllJijKFQ\ryIMxO5k7VVx79Tq53BZ2NM6LV1/G9xXGGMbHx/Tg4OCN4eHhnzlWR4wdx0EphTEh2/ktkskGIjJC\rsr6BSxcvEbVjOFUxfO2Syfyh+vvf6R0Z+e0XKtRhY5NOpUjE41iWhRCCQj6PEALLkti2TXV1NbFY\rjCAMszdvvtl9GvT4y/s3f95DY8zC4xb8DYvotg/VHc9GAAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5\rLTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMS0xMVQw\rOToyNToxNC0wNzowMM7uAgEAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDk6MjU6MTQt\rMDc6MDC/s7q9AAAAZ3RFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vu\rc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQ\rTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1Mjo0Ni0wNjowMHZl\rwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RFWHRTb3VyY2UAT3h5\rZ2VuIEljb25z7Biu6AAAACd0RVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94eWdlbi1pY29ucy5v\rcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_CSS, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAABYlAAAWJQFJUiTwAAAACXZwQWcAAAAWAAAAFgDcxelYAAAEgUlEQVQ4y5WV224bVRSGvz0n\rj2PHSYknTpxAW0QPBGgjQFBUSou44wkqJMSjIXHPK3CJKkEPtCWEJmnrOLYTx05aH+awD7O5cBrS\rQoX4pa3Z2jPzzT9rLa0leFkC8ICC77uuEI6YHFsEAgsgBMJOrlhrMyk1kAH6VdDxfrpcnl9eXvow\riqKVQiEoW6wgt1hrsVisBYtl8gWLza2Nk+T5/n7vwe5e926apocc3fVeUGdnZ6PV1cvffP751W/f\rvXjxbBiGfm40xpijpcnzyV5JSZqmmNyQxHH2aGPzzzt373+/9fjpj0mSHJwE+8vLSx9/ce3adzdv\r3ry8vLyEMRolJVoplFZoLZGZZDgc0N/v87zXIxmPmK4vlOqLtU+VUvlgMFjfbrZ+BoxzBC5E1erK\rhQvnzy7V6+RHrpSSSCXRKiNLU7r7XVqNHWS3z1Rrj4Nf79HaekIUzTln3nrz3KnZ2fOAD/AC7AWB\rXykUgkAbRZalSJkhpUTJjDiOabfa9JptyuOEWq9P/vAho04b4bp4nk8YhgXf96cB96UYW2uFMRop\rs8nvK4nWiiRJ6Oy0GO7tU00lwXaT7Tt3WOv38K98zFvn36FYDPE8D+E4x8XwNxiL0fo4BFpNnO9s\rNxk0dqgORuSbm6w/eMATa6hcv8rK9WtEtXnA4gcBJ7gnwPkLcIaSknE8ptF4yt7aIxb7z4i3tth6\r8oR+NEf9qxtcvPIJs7MzCCHI8xzhOJzUMRhr0UajlGQ4GtBpbtBvrXHY2CRe6zAcJ4hLK6x8eYPT\rF89RLBY5+e6rOgbn1qL1JMbPD3vo8VPerh6g5wf80Q05feM6K599ytx8hOs6/JdOJg9jDEmSsN9t\rE/caOEEPt1Ri9eurnHvvI6ZOuvw/4Nxo4vGIbneX4b5ER2eYrp+hfnqF0tTUvwKEEJO+8XpwjlYK\rYzQzpxYIS6eI5heZm5sjN4Zer48QgjAM8TyXOEkw2uC6LmEYvh6MtWit2N3tsvm4iTGG0Viys9Om\r1WrjeR7FYshifZHRcESzuUOxWKRSmebChXPHne+FjrPgCEGWSR7+vk6jsU2tFlGbj9jY3OL23XsM\rh8NJDuKE27fvsvbHOmmaYq3FcZzXOxaOY3MLw/GIN944xUcfrlIqlRjHCXluCAoBO602SZJx9uwZ\ryuUySmk2tx4zM1shNwZHCPuqY620HgkhVFStcvjsGbdu/cLva+uUyyWWlpYQwqHd7tDpdFhYqFFb\rqJFmGU8b27Tbu8TjWGqlx4A56TjrHxysd3b3mpc+eH8lCAIGwyG+71OZqeC6LuVSidXLl1herlMo\rBHiuw3xUpVaLmJmp2Pv3Hz7uHxxuAAqOOhFgpVQDrbXrOGJxZqZSLIZhjkArKTU2157n6nJpSruu\ro9M00dZaHfi+xubJo43NtXu/Pfihsd38SSk1hpdHkzM9XV6sLy5ciaLqe2GhMG2xAmsRwpk8aSdl\riRBHM9DmaZI+3+vu/9Zu7/4SJ0mXo9H0amULIPB9LwyCwP9n2b8sayHLMqmNSY9CcJy8vwDwmov/\rGurQOQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wNS0yMFQxOTo1OTozNi0wNjowMBl6oLwAAAAl\rdEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDUtMjBUMTk6NTk6MzYtMDY6MDBoJxgAAAAANHRFWHRMaWNl\rbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL0dQTC8yLjAvbGoGqAAAABl0\rRVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAXdEVYdFNvdXJjZQB4ZmNlNC1pY29u\rLXRoZW1lsdI4UgAAAB90RVh0U291cmNlX1VSTABodHRwOi8vd3d3LnhmY2Uub3JnL/qctaoAAAAA\rSUVORK5CYII\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_DOC, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADg0lEQVQ4y7XVz4scRRTA8e97\rVd07Mzu/ssFMdiO6JBhBRCKKeMjBP8CLrCcRL94kahQFycVT/gAFQw6eBSEIEi/JJUZMSA5KQm7B\rZKOEZHdnd5jNOJPu6a56HjbZbDZjQCQNRfNe05+qfq+aEjPjSVx+ayAi+4AD/9O8Alz125IHDr7/\r1QlTh3MeVY+oR51H1CGbOYc6j27P+YRbJ784fOHcmT+2w/hKEwOOffYm12/32Tu3g8PHfsU5h6qH\re3dV/wD1HlUlcYrTCaUA2DfXYByUG8tDvvnpKh++9RJTteYWyCE+wYmiTvACqoITwXuZXGOApbwF\rKJf/HHJ44RXmO9Ok1SaqDucEr4KqoCJ4BVVwKjgVvOq/w3t3VSii47e/xly6eRsnQq2abqzoPiTy\r0CQbMagA6ibDC2/sJxQFiOJk40VRwYki9yCBjVhABBAQwDvl7LE8ToT3zwRihNXVFarVGnvm5uiv\rr4MZSZJQFAXNZpPBYEC73SbLMvI8p1ar0WjUMSttIlyv18nHY0QE7xyiymg4xDlHnud471ldXSXG\ruAmWZcloNKLRaGw6uh3O85wYAuocWZbRXVkhSVNijCRJws6dO6nX67TbbWKMlGVJq9VCRBB5zK6I\rMWJmPL1nDwYk3tPr9UjTFFXF3ZswSRJ2795NlmUMh0PSNH34f9gOT09PE0Kg3+/TX19nulZDRKhW\rq4xGI9bW1ijLkhACZVliZpvjsXC/3wcgSVOajQazs7PEGOn1eszPz2NmqCqqSgiBEMLmV5Zl+e/w\rU7t2URYFg8GAVqvFnTt3CCFQqVQQET64oNwcAhhmgpkDHK/PjPnoub/zpaWlPmCPwN2VFUSENE3J\rsoypqSmAzcZUrEuz2iaKJ5YFM8ObvNyO7PcFx4//+MPi4uIpM3sU7nQ6FEXB8vIyd+/epdPpEGNk\rNBrRbrfxl79lVgtmnj1IsbbEl+++w/Vr1zh56pfTR44c+cTMuhNL0e12UVXSNMV7z2g0IssyKpUK\rALfOfM+LLzR5JvzOa6++zY3F65w7e+r8p4cOvWdmy/cd2dpNEVkoiuJEWZb0er0HjfCeNE1ptVpc\r+flr4nhArbaDYfo85y9eOn3o488fQgG2b5eFEIIVRWFlWVoIwUIIFmO0GKOZmcUYbTweW7/fz48e\rPfod0Nlq3B/bV/xfjqYxcNHMViY9lCd1mP4DFKCqtdQRKFcAAAAldEVYdGNyZWF0ZS1kYXRlADIw\rMDktMTEtMTVUMTc6MDM6MDQtMDc6MDDXquLPAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDEwLTAxLTEx\rVDA5OjI1OjEyLTA3OjAwrT43OwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxMC0wMS0xMVQwOToyNTox\rMi0wNzowMNxjj4cAAABndEVYdExpY2Vuc2UAaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGlj\rZW5zZXMvYnktc2EvMy4wLyBvciBodHRwOi8vY3JlYXRpdmVjb21tb25zLm9yZy9saWNlbnNlcy9M\rR1BMLzIuMS9bjzxjAAAAJXRFWHRtb2RpZnktZGF0ZQAyMDA5LTAzLTE5VDEwOjUyOjQ2LTA2OjAw\rdmXDFgAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAATdEVYdFNvdXJjZQBP\reHlnZW4gSWNvbnPsGK7oAAAAJ3RFWHRTb3VyY2VfVVJMAGh0dHA6Ly93d3cub3h5Z2VuLWljb25z\rLm9yZy/vN6rLAAAAAElFTkSuQmCC", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Folder, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3XAAAN1wFCKJt4AAAACXZwQWcAAAAWAAAAFgDcxelYAAABp0lEQVQ4y7WVQWqUQRCF36uu\rqu4OkUCiGwWRbOMBsswR3LsVvIGbLAx6APEE5g7i2gMEFBduRBBXgy4ik5lM5p/55y8XmoW4UXqm\rVg0FH69e9etmRGATJRuhbhKs14fHp+d/eUIgssXTlw/3nv8vmBGBE0BGp+erw/3VH82uJz59E1x2\r/w5c3Nutr44w59HJWz3AQe7vpun928um8T+ODFVmd95/+fydh8fvxot+tR0Ra/Gb5OCapqqa8pMH\r+/PtoltkGzQCmFz1ixdvvmat7svXH7p5tmGLaLvTAaJbLufVXTVnX2Yz1uxAIxggQEjOvtTq2rnR\ri3Mt4NWAVF1nWrPO3VhqFrSmmyAWvUjNOtdiemUie8WIYWjbHoWwjiymV1pLmrmCxYFhaFQshCul\rljTTku3SjFJdsGoEixBmZMl2qdXT1BIlO5vBSQhLwuqcarE0SYl0I1ZDW/hEiJQSi8VELetFRMho\rCvR9qxUASbGcLvTmjpzteDz6lbrGTAMICMcLOSOAW75141jEd5upAILDuJv8eMbrP4+krkFyREQP\r/H7oN1E/AeRPjq94b8L1AAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5LTExLTE1VDE3OjAzOjA0LTA3\rOjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMS0xMVQwOToyNTowMy0wNzowMMfjPBEA\rAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDk6MjU6MDMtMDc6MDC2voStAAAAZ3RFWHRM\raWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL2J5LXNhLzMuMC8gb3Ig\raHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQTC8yLjEvW488YwAAACV0RVh0\rbW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1Mjo0Ni0wNjowMHZlwxYAAAAZdEVYdFNvZnR3YXJl\rAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RFWHRTb3VyY2UAT3h5Z2VuIEljb25z7Biu6AAAACd0\rRVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94eWdlbi1pY29ucy5vcmcv7zeqywAAAABJRU5ErkJg\rgg\x3D\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Font, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3WAAAN1gGQb3mcAAAACXZwQWcAAAAWAAAAFgDcxelYAAAD6klEQVQ4y52VP2wTVxzHP+/e\rXXyOSeJACMIUCH/UP2qnSpUKVZHKSJEQC11RFYmFAXWJBANjJbqxsTJ36BCpLB06QFkqJEhDqsql\rSXBiB5s4trF9d+/9XoezHUySDj3pp5Pu3n3f9/f9fb/vFMCtW7ewVsJz5778IpfL5QHHHlcURd7y\r8vJGsVh8PDk5Gc/Nze26TgHcv3+fKIo+uXjx4nw+nz/knNsTWERUrVZrVSqVez8/eHDnSKHQmJ2d\r3bHOAwgCH611qD1v3BoTaq2zxpgskHUiWWttVimVNcZktdZhJpOZOnb8+NzXFy7cWVpamrx79+7u\rwCIO5xxWBGvtf5ZYi4gA+CdOnpy9fPny90+fPh27ffv2TmBcCizWkhiDAsIwxPd9gpERMpkMWmvC\rMEzvmQxJHBP4vj59+vS3V65cmZufnx+5du3aANhPcR3OCSiF7/t9RrsPRSlQimazSbVaI0niYHx8\r4sb169dXr169eu/ZswUePXqYMnbOgQNjDN1OBxHZs+LEEvg+B6em8DyP9fUy5XI5Nz09/d3NmzdP\rnD//1TZjcQ4RQcGejD2lWCy1eFysc+nTafbnRigUDjM2NoaIxVp7cHn5nwNhGL4YlgKHMYYojvE8\r7532oZM4flmo8LzU5POTY+RHNdrzyE+Mp9I0Gijl4Xl6e3jOCU5S1m4XZ4gIS6UtGu0IaxI26m1k\rF6c4l9ZbwG4gRy8EQ9XuJjx58ZozpybQzrBWaw027Je1tmcCN+wKnMNaSxRFQ1J4SrG4WsdD+PDw\rKIEnlKpNYmPT2PackjJ+B1jEIS59obXGWjsA7lrh92KVM+9PkQ089o0o1mpNOt2YMNC4HrC1tien\re0djlw6v2+0OtHNOeL5aRzlhZiqLQtif01Ret2i2o6GkigjSz8OQKyTVub+7UhAnjoeLZU4c2kep\r1kzbdsJWq8PrZod8LkBk+5udGst2pI0xKKXQnmLpZZ2/y3U2W22eFDdQwOabmMhYXtU7zBzMYXvA\rA1fI2xq7tI1+W1pr4kR4/OcGlz57j4+P5REBz4MXlRY//LRAud5OJegdsH3GskMKJ4OHzln+Wmtg\rjOWjI+NoBVqnQTmwL2A041Pe7AM7QGHFDjof8nF/eHEc8aRY48fflqk2u1TqbcQarDVsvYn49Y8y\rsbEsrGzyaGkDY94KyU6NZeisCAPF2Q8OoJViRIPtnx1OmJ7I8M3ZozgHE6N+z1HsrnG5UiFJks21\r9fXF0Wy2kFW4UxOp/TuNKu3G9n/saK4fC3AuprTWQIFqdzrlV6+qWyNBMFhLoVAA8GZmZo75vp/j\rf1zGJO2VldUVcPblyxL/AsFr/L+k3iqiAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDEwLTA1LTI0VDA3\rOjQyOjIwLTA2OjAwPLYQbgAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxMC0wNS0yNFQwNzo0MjoyMC0w\rNjowME3rqNIAAAA1dEVYdExpY2Vuc2UAaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGljZW5z\rZXMvTEdQTC8yLjEvO8G0GAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAP\rdEVYdFNvdXJjZQBudW92ZVhUMuogNtwAAAAidEVYdFNvdXJjZV9VUkwAaHR0cDovL251b3ZleHQu\rcHdzcC5uZXSRicctAAAAAElFTkSuQmCC", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_HTML, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADUUlEQVQ4y7WVT2gcVRzHP+9l\rZnd2k91t/mzS/GnSkjYKKbRYBYNUEPHiRWyvtd48SW4RvIiXnMRLDnrzqAiiocRDS4sieKjtIWVF\r2sAmGNpms93YbffvvJl5Pw/mzya7rRbpgy8zD2Y+85kf7/2eEhGex3BaJ0qpSeD0/2TmgBVEZDfA\r+TAMpdFsSrPpi+9vxxgxBxMEYoJAgpZEUSQzMzMfAto5+Lmm71OpVNBao5Tave7mn1/bu9+eA8Ri\rsc6l2C4HWut9QN0KVuqJYKXUU8Cwz1ZQfHvLkrtX5dc//iSTHmSwJ+LNF3u4ONP/DOAdS63Zqmk+\ruuqwtrrCw9ImU6P9vDQ1TE88ye/rd5nbLPPp22nSCRcA3QLWtJPRWmNF8ckvSd44msSGDaZHMhzr\r83htMs4LQzA6PEbj4Raf/2T2StQy2sBq2/qbnMeRVBdfXbuBZwOyqThj2RQT/ZBNWQ4lDL0DE2w8\ririS22qDtxtvg29vxVi7v8Hyyl2SsS6SnstAOsGJrMPRPoczEx7HD6dwrc+Py8U24441thbSTkB6\r5BADqQQmtPhBRNKDhKsII7hfhscNyHia63cqbcbOk4wlNMRch3NnT3DtRp6hdJybd0pkEg5dWqO0\rR/GvGqqrm/GRwf9m7DoaFdXRbpbTE5O8+8o4xWKR1UKFmytF8oUa3ckESgSvb5JTYz1Ya9Fa/7vx\rcLLGuh+HSppq0yWmEnxx9RbphIuIUK4bLrx1luX1IhfP9WOMwXH2cB2XG8D7rw9SKhTZrG9SDyN+\rW31MtrcfIzFC5TGaHeL2epELL2c43meo1+tUq1W/UCiUAem485RSxF3Nx+8M8tnlB6yHDV6dGufM\rsSyVpkEEaoHDqVGXKW+FQsElDENZWlr6fm1t7bKIiGrtx0qp80EQfBcEwW6/iCx8+XOBew8iKsYj\r0x3nSK9i+nBEVm1w8uQ0+XyexcXFS3Nzcx+IyCZAW9sMgkAajYb4vi/GGAmCQMIwlCiKxForYRhK\rrVaTUqkkuVxO8vm8LCwsXAGGWlkdN8jTxs6L1lpERH5YXLw0Ozv73q7pwQd3jKMo2me5Y2qtFRER\ra60YY6RcLvvz8/NfHzTdycEaP8vRZIDrIlLsuGSf12H6N1rr65d342PiAAAAJXRFWHRjcmVhdGUt\rZGF0ZQAyMDA5LTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAx\rMC0wMS0yNVQwODozMDo0MS0wNzowMKms+cAAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFU\rMDk6MjU6MTMtMDc6MDB6FIQzAAAAZ3RFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMu\rb3JnL2xpY2Vuc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGlj\rZW5zZXMvTEdQTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1Mjo0\rNi0wNjowMHZlwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RFWHRT\rb3VyY2UAT3h5Z2VuIEljb25z7Biu6AAAACd0RVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94eWdl\rbi1pY29ucy5vcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Image, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3WAAAN1gGQb3mcAAAACXZwQWcAAAAWAAAAFgDcxelYAAADUklEQVQ4y7WVy24cRRSGv3NO\rVc+1Pe74EltZgCwvkIhQJNhAEiFeBl4hWbNllTcIEnkKdrBmwRKRRBBIHBtPhMcz7emZrsOiezyO\rkqxQSir9pVNVp/4+l7/hPQ25f/8+Ry+P7ODgoJvFTBxvdi7BX1+/Yw+c5M7J8Un14MGDSh5+/3Dz\rzp079/JhfhtBAdyb029Fb92/A6uq+vvp06ffhcPDw1s7OztfdzqdQrhyyFtOV7Bh+La9hnnCSXWi\rLMvnIcbYV5E4nS84nS5fY3iVzVV7alHaUHj7SC/AqBcw1Y0AYAo/Pyn59pcAZiigAgKoOCI0MQIy\rg+v9Zv3qAuoEIs2jd4sJ39xqToYVoSoJ59pHNKDSOLYWFQgK13pwYygcbDaOj6ZwdA5V7SwSLOUC\rb0MVVhmNCttdJwTYGzTJPps3jFScPBP2htA1ZzxrvnIY4MONxsO0cnJfhcsJbT7IFD7IhY0ebHQa\rtvMaJhXgAsBsDh4hz2Cn39z56wyqJYhDZr6KPMHbrGayZDPMiRapllyGY3/g5BHqNp/DTOhFx9oc\rHBawTDCthHy+LsmGMYJfnFI++YlUHEBa4NZjxjVcewhCNKUYRub9QL9j9KLi7igQTdiI0K9py7Jl\rDLCYT3jx24+E2CEf7WGxx4IuM7aoGDKfl1jMGYz2yPt9doucciFUNRT9yO4oo8jWZRpWDTmfTTh+\r9hjRxNnoBd3+JlV5TnVxTl3X1GmBWsYi32Y52qccXse622i2xTTb4vlxQW9f4cagKbdV0U/P50xP\ra0QT5b/HeHqJp8veQFRQWzAdT3kVnhE6GVm3T9YdEjo5KRT8MfuEdPMuvmbsTCvjpNxCpC14FEdB\rjISxJKMmkoi4BhDDLYIGXI1lMjZXQV4xdncqGfFP9hloBDXQsJ7WoFhA1DALqAXUDAsBa+2D7S6r\rKms6LyX2d7f48vaniFpzQRVVxazB0NrM1jOoYmYEU0SVj7fTpR4Hd2eZnK9u7vLFR1utvr6pYPha\rf9+FTe0L7u5hPB4fl2V5NhwMhr1or2nvWmdbB2/VacddLm2LxaKeTCZ/hkc/PPp1PB7fK4ricxEx\r3C9JwptivoY3bALObFY+e/z494dy5TelNF36f0da0Xov4z9IwtlM74rHQAAAACV0RVh0ZGF0ZTpj\rcmVhdGUAMjAxMC0wNS0yNFQwNzo0MjoyMC0wNjowMDy2EG4AAAAldEVYdGRhdGU6bW9kaWZ5ADIw\rMTAtMDUtMjRUMDc6NDI6MjAtMDY6MDBN66jSAAAANXRFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2\rZWNvbW1vbnMub3JnL2xpY2Vuc2VzL0xHUEwvMi4xLzvBtBgAAAAZdEVYdFNvZnR3YXJlAHd3dy5p\rbmtzY2FwZS5vcmeb7jwaAAAAD3RFWHRTb3VyY2UAbnVvdmVYVDLqIDbcAAAAInRFWHRTb3VyY2Vf\rVVJMAGh0dHA6Ly9udW92ZXh0LnB3c3AubmV0kYnHLQAAAABJRU5ErkJggg\x3D\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Movie, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADLUlEQVQ4y7WV3WtcRRjGfzM5\ru0nWlA3eaK9sbRsjqRitH8mVUShBeiVNUWjFf0AC3uaqGnJTsJbcJiJpXUMQa40JWC+E0qDkwo8S\rIqRlEzEtZpMF0242Z8/MnHm9MGfdJNvQIh14OGcO5/zmeZ95OaNEhEcxgtqJUuoQ0Pk/mXPATUSk\rKuCkc07CSkUqlUiiaEvGiNkpa8VYK7ZGcRxLd3f3+4AOdi5XiSJKpRJaa5RS1WtV/5b23/3WHCCd\rTlc5eic4gSVSSqFrtfVsdnaWz3M5oija9u79wbDNrdYapTXWWkZHR/now0GMsdxe/osbv91kZuan\ruuCgnuNExbUiExMTXL/+IxcufMxzR5+nuFZicnKKZ9oOceJEL9lstgrUe4GpKffSxS95tuMI6XSG\r+fnfeeHFTl5+9SUU0NjYiHMOYwxNTU27MHWjSHK9MT/Hd1d/IJcbp1BYRSvN6z29jI3lWF1do6en\rl5GRz7ZVeX/HSRxa83jrPoIgoKvrFW7dynP+k2G6urtYXPyDc+fOc+xYJ8vLf24D7pmx3lq97+Rb\rtGSzIBpB4QViD97H2Fjwcczde6Uq+IEca6UYu3iJ1mwrT+7fT3HtbwqFVQ4eeIr2jnbGc+O0HTnM\rwsICZ069+QAZ1+TlXcy+lhaChgBrLcePv0Fb22EqFUumOcPBpw+gFIgI3vu9wdWStrojSKVZv1si\r3Kxw+atvuHZtBu9jUqkUv/z8K94LxhiMMTjn9m63pDv63j5FpvkxRDcgohAB5wXvhb4z72FdTLhZ\rJgxDvPdoraOVlZV1QHZvXk0cn46Mks8vkU6lCVIpGnQDoPDe42KLMREdHe281nUU55xMTU1dXlpa\ruioiUnfzknH69DvcXr5DWAkplzfZ2NgAINOcobGpkSAIGBw8y+LiItPT098ODAx8ICJrALt+m9Za\rCcNQoigSY4xYa8U5J3Eci/denHNSLpelWCzK3Nyc5PN5GR4e/h54opaleciRfOi9R0Tk6ytXJvv7\r+98VkULdFxPHcRxvc5k49d6LiIj3Xowxsr6+Hg0NDX2x02kiVXvmPeTRZIBZEVmt27KP6jD9B+To\r976kkXBsAAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5LTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAA\rACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMS0yNVQwODozMDo0MS0wNzowMKms+cAAAAAldEVYdGRh\rdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDk6MjU6MTMtMDc6MDB6FIQzAAAAZ3RFWHRMaWNlbnNlAGh0\rdHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2Ny\rZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRh\rdGUAMjAwOS0wMy0xOVQxMDo1Mjo0Ni0wNjowMHZlwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtz\rY2FwZS5vcmeb7jwaAAAAE3RFWHRTb3VyY2UAT3h5Z2VuIEljb25z7Biu6AAAACd0RVh0U291cmNl\rX1VSTABodHRwOi8vd3d3Lm94eWdlbi1pY29ucy5vcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Music, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3WAAAN1gGQb3mcAAAACXZwQWcAAAAWAAAAFgDcxelYAAADqklEQVQ4y4WVS0wbRxzGfzPe\r8SMGGwOBYN6IBqVtemiObSMVpYemXDg016IIiR44VLlQwYFjpRy55VSJ9JJzSZtjU6m0atRUIjS1\rWqHGvIx5hIcdg707Mz2sa6DYYaS/dqWd+fab3377HwEwNTWF1iZ8/foH70Wj0QbAUmMUi0WZTqc3\rl5aWfkkkEqWJiYmq8wTA7OwsxWLx7aGhobl4PN76OmFjjNjZ2clns9l73z96dLc9mTwYHR09M08C\rKOUgpQwrpWJBpcJKqUitCodC4Xg83tzV3T3xyc2bd1OpVGJmZqa6sDEWay3GGLQxGK1rljYGawxY\r6/T29Y0ODw9/tbCwUD89PX1WGOsL2/Iic15Zi+u6KMcJ9Pf3375169bE3NxccGxsrCLs+Lplx9Zf\raG1NxCAEQghyuRzb2zu4bknFYvEvxsfHV0ZGRu49e7bI/PxPvmNbcWzPd6s1ynG42NyMlJJMZoON\rjY1oS0vLncnJyd7BwQ+PHRt7zPhcx+WhgkGSyTbq6+sxRqO1vphOv2gKh8P/nEGhtUZrfa6wEAKB\rIOgomhIJDJaD/X2EkEgZOMnYYMt8awlLIRFC4GmPQ7fA3tEu2XyG9MsXvNn0Du2xjopOVcfVUAgE\ri9lFnqzOs5JLs55fZvNVlt1Xe+TzBb58f5r2uo6KztlU1HAsheS7P77lwcI3tMZaaKtr42r8Gj1d\rfaQ2//RNGX1W2Bg/EbUYW2EJKsXYu+MMXr5BPNJAJBQh5IS4/9vXfky1KafqlGM/9LUcW2EJBxVv\rNPTT0diJZzystbjaxdMeBoM2upyuGoxrCTtBicXiei7aaIQQSCRaGzyr0dpUYWxszVQIIQAIBCRg\r0Z7GYDjyjsjmMyxvrzDQWIcx2k/FSRTGmlOO/9uFEAJXuxyU9sgdHWCU//Kdo21+yD4kVXjKfOYp\rl+MDPuNyWziNwvhf1he2gOCguM+vuz+S1s/5e/cvBsJXscbye+YJD7fuoy4VUCFJWyyJp73yzv8X\rN2Ot3xbLKAIiwM9rj3lsHxC55FFcl4RFFNdz6bzQQzL/FoVUjs96P+ZK2xVKpVKlNZxgfPzn+awA\rAc3BVliL4u5LbkQ/orOhG1eX6Ih1cefaNMYYIqEICKoz3shmcV13dz2TeX4hEkna8tHUZFv4tO5z\rrLUkIo1sbW5WzixRvr7070Xh8HBja2t7P6jU8fNkMgkge3p6uhzHiXJisXKCCKCk3dc2J89zC8vL\rK8tg9erqGv8CLa3m9JMTKpMAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTAtMDUtMjRUMDc6NDI6MjAt\rMDY6MDA8thBuAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDEwLTA1LTI0VDA3OjQyOjIwLTA2OjAwTeuo\r0gAAADV0RVh0TGljZW5zZQBodHRwOi8vY3JlYXRpdmVjb21tb25zLm9yZy9saWNlbnNlcy9MR1BM\rLzIuMS87wbQYAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAA90RVh0U291\rcmNlAG51b3ZlWFQy6iA23AAAACJ0RVh0U291cmNlX1VSTABodHRwOi8vbnVvdmV4dC5wd3NwLm5l\rdJGJxy0AAAAASUVORK5CYII\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_PDF, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\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\r5XEfxWXGZf5kiPg+oiDinEjMOJiRk3FYVbgFbz8WraKKKhQhhDz+R/gvNfAhtB8fUrqPjHSPFxnv\rZs8nZDwLWMACmehef9OjjVZsWbFlxRbWuS87t0q0G93oRqv6P6QktMGDfWblAAAAJXRFWHRjcmVh\rdGUtZGF0ZQAyMDA5LTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUA\rMjAxMC0wMS0xMVQwOToyNTowOS0wNzowMGOTY18AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEt\rMTFUMDk6MjU6MDktMDc6MDASztvjAAAAZ3RFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1v\rbnMub3JnL2xpY2Vuc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcv\rbGljZW5zZXMvTEdQTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1\rMjo0Ni0wNjowMHZlwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RF\rWHRTb3VyY2UAT3h5Z2VuIEljb25z7Biu6AAAACd0RVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94\reWdlbi1pY29ucy5vcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_PPT, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADQ0lEQVQ4y7WVMWybVRCAv3vv\rz+/ETrBjxTFEwghTRR0jdaIsbIgBFsSGVFWwtF3ohiLGiKUbKyMSUhCCOZAtCRIMXSIk1CR12pTU\rjh3ixo6T37/fOwbHTho7RQj1SSfdu6f33b27ezpRVV7GCs5vROQtYO5/MteBB8EF49yzL9/9AVGM\rUUQUjCKGM1169q5NzKmIIlZ4b1E+X175ffMiGDMS49Ux9uk3+L0NbP4KJ99+NgBCug4RBQuIIOYM\rZy6CDyYLNDOvobUHdJa/Qvc3sAmHDTvYhMOEDhN6ggTY0GATIWZkDBlJQZjsIwcino43URwmf4XE\r+1+gO2vYEYcYQYwFY0EsiBnUTQCcDAcfpItY3yL7043TSxZJjCGnehfWBYkJhjioDwdn3rlBJ25z\rLEKr1Ua77QIIGIOIxRghOTZKGIZnZwjGWKKv7/pLIp7De0+tViM9nSYIAlQV7z2qinMOYwx/PH7M\r9etvIyLnKm/oqOhQ8Pj4OFG7jfOedDqNcw7vPc65PlRVmZqa6vX+v38QgCiK8N4DsLG0hGm1aNfr\rHJTL7DYaBIkEHnjzgw9xzvXB2WyWmZmZy8G9JwuQa7WYePoUH0X8qcrHCwt4kYFXeO+pVCovBqdS\rKZxz3UJms2SSSQhDyuvrVLe2aOzudqETE/1oBUgXCi9ORb1eP6vFxCtwfAzeQz6P39yiMJ0j3t/n\r7/v3ae3sYIOAyqNHZO7do9PpXA7OTU/TiWMqlQrP3ihw8GoegP0nTyiur5NYWyUxOkoqihi7dg0t\rlXjdWg6NodlsRuVyuQ7oALi6t4eIoKoQhpgw7OvJXI7wtK1OtrdxqRR/FYvI1as0Gw2+X1z8sVQq\rLanqIDifzxPHMZlMhlKp1M9ju90mLhRonPa15HKUGw1mb95k6+FD1n7+ZXl+fv6uqlaHpqJarWKM\rYXJyktnZWUQEESGKIuJslrhYBEBViZtNStvbrKys/Hrnzu1PVLVyeY5zueeK0FvJZJLDw0Ostf2W\rjOOYldXV5du3bj0H7XvuCfCRc07jONZOp6POOXXOqfdevfcax7FGUaRHR0daq9WihYWF74D8eUZP\r5PzM+4+jqQ38pqp7ww7lZQ3TfwCaHr3lMhqzqAAAACV0RVh0Y3JlYXRlLWRhdGUAMjAwOS0xMS0x\rNVQxNzowMzowNC0wNzowMNeq4s8AAAAldEVYdGRhdGU6Y3JlYXRlADIwMTAtMDEtMTFUMDk6MjU6\rMTEtMDc6MDCc1i2mAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDEwLTAxLTExVDA5OjI1OjExLTA3OjAw\r7YuVGgAAAGd0RVh0TGljZW5zZQBodHRwOi8vY3JlYXRpdmVjb21tb25zLm9yZy9saWNlbnNlcy9i\reS1zYS8zLjAvIG9yIGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL0xHUEwvMi4x\rL1uPPGMAAAAldEVYdG1vZGlmeS1kYXRlADIwMDktMDMtMTlUMTA6NTI6NDYtMDY6MDB2ZcMWAAAA\rGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAABN0RVh0U291cmNlAE94eWdlbiBJ\rY29uc+wYrugAAAAndEVYdFNvdXJjZV9VUkwAaHR0cDovL3d3dy5veHlnZW4taWNvbnMub3JnL+83\rqssAAAAASUVORK5CYII\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_RBP, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAMAAADzapwJAAAAB3RJTUUH3QIKFygfvjUA/wAAAAlw\rSFlzAAAOxAAADsQBlSsOGwAAAARnQU1BAACxjwv8YQUAAAKIUExURf////j4+Orr6+Xl5fPz8/7+\r/vf39+Tk5MPDw56dnZWVlbSzs9na2v39/fb29uLj48PDwpqamYOBgpaSlZGPkXt6epCPjrm5ud3d\r3fT09OPk5JqampCNkMvJy8nIyY6Ljn18fJWUlMDAwObm5vv7++vr6769vZGRkZCOkMrIyfr6+9XT\r1bKvsrKustjV2Pr5+sfFx5+entTV1PHy8bm3uPj5+N3b3YN8gg4FDGNuZU1hUxYKFIqCiN/e3/j3\r+MbExsXExdXU1MC+wPHx8d7c3oiChxoPFwYdDEOgWqLptGPMfgN+JAAVACMWII+Hju/v7768vtfW\r17KvsZmWmBsSGQQZCUidXGPUf1bDcaDbrl+/eA2gNRewQAuBKwAQACQYIba0trWztEI4PjaDSWTW\rgF3Hd1vBdFS+bl2+dw2cMxagOxalPBexQQBmGV1QWLm3uUg8RUyuZFzEdhajPAiMK2JTXEqpYgeJ\rKlO+bZ7arFi8cwycMweHKlrAc0W4YbPkv4rSnQCUIAybMhWfOgeIKkqpYVXBcEq7ZojSmun47Nbt\r3eT36Vi+cwCWJgyeNAeIKT80PD6lV43ZoOn47tvv4qbYtaHWsd/x5eL251bAcgCCGlpLVIuHicvX\rzuX+7azhvaLXsqfZtq7ivun/8b/SxZqVl//9/bKwsf79/VhTVQUOCHKZfrTrxa3hvK3hvbTrxG+U\regMLBltVWLy6vMG/wNfS00tERwsSDXifhbbtxrXsxnWbgAsRDUpCRtbR0fv7+sC+v+3s7bSytMTC\rw9POz0E5PRMfFxEbFUM8QNbQ0sXDxbe1t7KwssXDxMG8vcbAwsrIyu3t7urq6q6srrGusezs7bWz\rte3t7RsbwKwAAAABdFJOUwBA5thmAAABV0lEQVR42mNggIGr10yuM6CDS5fPMjAYXFFFEVQ9AxQ8\rd56B4cKhi3DBg4cOMzAcOXrs+ImTDAynTvtDRDdv0WfYum37jp27du/Zu49h/wElsPByhhUrV61e\rs3bhwnXrN2zctIwhASycyDBn7rz5C6YuXDh1waLFS5Yuy4cKT5g4afKUqdOmTZ0+Y+as2Qww4YLW\rtvaOzq6u7p7evv5ShHBZUW16XX1DY1NzcQuKcFpaRWVVdVZWcQ2acHpkRiZQuBxJuBAhXIIQTkpO\rSYUIZ+fk5kGFgxiCQ0LDwiMio6JjYuPihaHecXRydnF1c/fw9PL28fWz9Q8IhASKsYmBqZm5haWV\rtY2tnb2DCkSUVVVNXUNTS1tHV0/fQMPQiBEasIxSHNJCMrIMrHLyCopKyiqwAGfl4xcQFBIWERUT\rl5DkRYoeVjZ2Dk4ubh4WZEGIUUzMLKwwDgDX0HqoxaoxqAAAAABJRU5ErkJggg\x3D\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Script, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3WAAAN1gGQb3mcAAAACXZwQWcAAAAWAAAAFgDcxelYAAAEEklEQVQ4y32VwW8TRxjFf7Mz\ra+/GJE5wExpDEEQcOFSE9FRUFVSOLRcunFEViQuHqpdIcOBYiSM3rvwNkco/UNQDSCSAHQGpcYgd\rJ4DtOsbx7s7O9OD1JiVJV/q0q9Xo6X3vve8bAXD37l3i2HiXL//wfS6XGwcsRzxBEDjVanV7bW3t\rr4mJiXBxcfHQcwLg0aNHBEHwzbVr15by+fyJ/wO21oqPHz92t7a2Hv7x+PH9k8ViZ2Fh4cA5B8B1\rFY7jeK7rjrmu6zlC+OKIklJ6uVzuq5nTpxd//umn+6urqxMPHjw4HNgYi7UWYwxaa5qtFh8+fDiy\rer0eWKtmZ2cXrl+//vvKysrovXv3DgJjB8DWGKwxxHF8ZBljMMYQhiFKKXnu3Llfbty4sbi0tJS5\rdetWCqwS3QaMk7fveRhjQIhDdQ7DkHa7TavVIgxDd2ws/+vt27ff37x58+GLFy958uTPAWO7j7Ex\rZvCddHJYua7L6OgoYRiysVGj0Wjkpqamfrtz587Zq1d/3GM8ZGoSGbrdLlrrIxkP/+bzeXzfxxt0\rOFmtvit4nlc5IMVQQzeTQSrFl7BCCKy1dD9/Juj3yWQyHD9+nBHfZ6fbxREO0pH7NTZYa1LGQxNt\rwlgAURTRbDaZnJykVCpRLpVQSnHlyhVOnTrFxvv3RFojo/CgebEZON/r9dBxnDLe2dlheWWFeq3G\rd5cuEYYhO90uUkr6/T5Pnz6lVC7T6/XwvOwhqYgHrDOZDMqYVILnz59TqVQAWF5exvd9lJRIKXnz\r9i3b29tordFaE0XyiwExNs2q1hodx4RhSBAEnJ2dJZ/PA9But9ms14mNIYwiKpUKu7u7w3lPt0Gq\rsdmXin6/j7GWeq1GuVxmZmaGkZERms0mQgg8z6NQKADQarUIgmAwZNgB9mGpGCYjNoZavU59c5Ot\r7W1EYmShUGB+fp6pyUmEEHxqNnn27BmdTieJud2TwhqbpsIYg1IKrKXT6SClTEGz2Szfzs9zslhE\rSonjOJwsFrk4N4dSajCt7AM21qSMhyYAXJyb48KFC2SzWYwx+J7HsWPHCMOQSGsirQmCgPHxcXzP\rI451ynhPCmMxSdwirYljjbEWL5vFcRysMSmQVAohBCrpJoyihIw4CGz2T55SCAGr5TIbGxtYwJGS\r/u4ujUaD8+fPI4RACEEcx1Qqf/O518NxxBfmGbNP4xhrQUnJ9PQ0tVqNTMZF65hYa16+ekUQBExP\rf421UKvXWFtbS5n+J26NrS2iKGrVNzdLI75ftGAFYLGMjo1yYmqKT5+aifOG129eU3k3GJgojEAg\rrLGNVqv9j+uqvUVVLBYBnDNnzpxWSuXSW8ARKKkQjki62bsKrTXJYnIQAqJI96rV6joQr6+v8y8s\rweHk83G/dQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wNS0yNFQwNzo0MjoyMC0wNjowMDy2EG4A\rAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDUtMjRUMDc6NDI6MjAtMDY6MDBN66jSAAAANXRFWHRM\raWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL0xHUEwvMi4xLzvBtBgA\rAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAD3RFWHRTb3VyY2UAbnVvdmVY\rVDLqIDbcAAAAInRFWHRTb3VyY2VfVVJMAGh0dHA6Ly9udW92ZXh0LnB3c3AubmV0kYnHLQAAAABJ\rRU5ErkJggg\x3D\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Text, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3WAAAN1gGQb3mcAAAACXZwQWcAAAAWAAAAFgDcxelYAAACx0lEQVQ4y5WUTU8TURSG3/s1\rTG0oNiomNRIksPMfGElkiWzYsCaGhA0L46YJLFiasGTHlt/QRP6AxjUYw4Zo+ZDWNhaRFDq99xwX\r88HItAVvctJZ3L7z3OecOwIA1tbW4Bz509MvX+Tz+fsAGH1Wp9OR1Wr158HBwedisRiUy+We+wQA\rbG9vo9PpPJ+bm6uMjIw8HhTMzKLZbF7U6/WtDzs7G09KpfOlpaXMPgkAxmhIKX1jTMEY40shcqJP\rKaX8fD7/8OnYWPn17OzG/v5+cXNzs3cwEYOZQUSw1uJXq4VGo9G32u02wKwnJiaW5ufn3+/u7g6v\rr69ng8FhMBOBieCc61tEBCJCEATQWqvJyck3CwsL5Uql4i0vLyfBOvIWEke/Od8HEQFC9PQcBAHO\rzs7QarUQBIEpFEberqysHC0uLm7t7X3Bp08fQ2JOERNR+BydpFcZYzA8PIwgCHB8fIJarZYfHR19\rt7q6+mxm5tU1cUxKkYaLiwtYa/sSx/oKhQKmpnLwwxM+qla/P/B9/1tGRezQeB6U1hgQCwagtYYx\rBkop/Dk/hxASUqq0YwIzJcRxE3kAsYiKiUBApDCsLDGFnW+327DODSSGENBKYWhoCL7vh0BRTnYq\rXEjteR400aBYSKVgtIaUMhnBTDARg4mTWbXWgpgHBsNaBJ0OjDHwPC9SyCD6h5hAqam4urqCc27g\rVEgpE1VKqZCauY/j9O2K57Zf46SEEAKU+l/WMXEyFUQErTXUbSpSL4lhmAmcVkFMCbG19m6OoxU3\rOyamjApiUDRuXdtN3tyXVEpopSCECFWQi05+Y9woffO0wYBvfSJBiPCCOGaQc8mnIeWYUo4d7mbh\repMQ6O24Vq+j2+22fpyefr2Xy5X4dtybDRTty8tao9H87RmTNBWlUgkA5Pj4+JjWOv8/ofGytts+\rPDw6BNgdH5/gL8NGX96P3YUKAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDEwLTA1LTI0VDA3OjQyOjIw\rLTA2OjAwPLYQbgAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxMC0wNS0yNFQwNzo0MjoyMC0wNjowME3r\rqNIAAAA1dEVYdExpY2Vuc2UAaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQ\rTC8yLjEvO8G0GAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAPdEVYdFNv\rdXJjZQBudW92ZVhUMuogNtwAAAAidEVYdFNvdXJjZV9VUkwAaHR0cDovL251b3ZleHQucHdzcC5u\rZXSRicctAAAAAElFTkSuQmCC", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Unknown, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAJhAAACYQHBMFX6AAAACXZwQWcAAAAWAAAAFgDcxelYAAAC4ElEQVQ4y6WV30tUQRTHP2fu\r/miV1AIlFNstoSWwqDCqt6iHgoXoZSHoRepFEFKQiCQKetjX+heiHvoB29NCPRaB1goVhBuahgrW\raoXrlnXXuff2sHcv++MqUgcOM8zc85nvnDNzRxzHQURCQBxo4/+sAOQcx1kPuAM7E4nExdHR0TMi\r4vwL0XEcSaVSzzOZzF3gawWsotHozt7eA4d+ra2hlCCi3FZwgOn8H1oiAbrawoi4UV4HwuEw0Wg0\rCyiAQN2qXl8Efpdsbj+dx3IcYu0RXnwssPDdZCSxmwvH2pEqcL3VgEUEpcpKlVIMP5hm4HQnR3ta\rEBGunO1m+P4Mt9NzhAxF8nhHOc6NrTZVA1biQddKNq+mVhn7VCwvJkJAKS6f7EQJPBxbQimFoZQ3\rvzHYVSwiBAMGQUPx8uMKytuJIhwsz88um2gbb7xecUMqKvCIITy7dpBw0PACRYTx6VWUCIei24mE\rAjWxG4PBgygRYh1NKBco7nZfzxQxlDCS2F0D3BRMRXEVyGtFWDNt3n4uculkF309rb5AX7Cnrh7u\r+uPxJY7sbeHquVgNsDK/YfG8j6rSIVX+7P03rp/fS8BQNeN+qn2L5+emdtjVto39Xc2bpsA/xxvA\rAT4s/OTyqa4aoGVZ3m1VSm0CFinfojpFIsLhWAvBQDnYtm0sy0Jr7cFDoRBO1T+h4bj5qbVth/Sb\rJfZ0RDja04rWmlKpVOOFQiGfTqezQNG3eNTlTkTIzhYZvjdJ8k4Wy7IolUosLy+zuLiIiJDP59eT\ryWQqn89nKuDGHPsUJt7ZxIl9rfR2N6G1RmtNoVAgHo+Ty+WswcHBG1NTU0+AL5VsNID9bEdzkPRI\rH5ZlYZomWmsMwyCXy+mhoaGbExMT96uhvsdtK2YYBqZprvb399+anJx8VA+tBttzc3M/stnsu608\rTSsrK+sDAwP35ufnn/pBAcR9TIPAfqB1S5JBAzPAkh8U4C+ZqRQt1j0xQwAAACV0RVh0Y3JlYXRl\rLWRhdGUAMjAwOS0xMS0xNVQxNzowMzowNC0wNzowMNeq4s8AAAAldEVYdGRhdGU6Y3JlYXRlADIw\rMTAtMDEtMjVUMDg6MzA6NDEtMDc6MDCprPnAAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDEwLTAxLTEx\rVDA5OjI1OjEwLTA3OjAwS/yergAAAGd0RVh0TGljZW5zZQBodHRwOi8vY3JlYXRpdmVjb21tb25z\rLm9yZy9saWNlbnNlcy9ieS1zYS8zLjAvIG9yIGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xp\rY2Vuc2VzL0xHUEwvMi4xL1uPPGMAAAAldEVYdG1vZGlmeS1kYXRlADIwMDktMDMtMTlUMTA6NTI6\rNDYtMDY6MDB2ZcMWAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAABN0RVh0\rU291cmNlAE94eWdlbiBJY29uc+wYrugAAAAndEVYdFNvdXJjZV9VUkwAaHR0cDovL3d3dy5veHln\rZW4taWNvbnMub3JnL+83qssAAAAASUVORK5CYII\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_WAV, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADlElEQVQ4y7WVzWsdVRjGf2fO\rnTs3nUTS3CQEEoVgaCQgtGDQu3AhBrQIIm76Fwh2U6EguHDZnQsRXKn9BwpuXIrECNogJJpEb5EE\rJLFtEm3SkNyPuXO+XhfJvUlsbkDEFw5zzjDndx6e95kZJSL8H1VoT5RSY8DT/5F3X0QenAIDY81m\rdtdai1KAUiilUBzNT16P1Rwr1JpisVgBngCrWr2ONQZd0ABorRERlFIYY+jr60NCoFQqobXGh0Cr\r1cJ7T5IkwPG5J8G0sgwB4mKMcw5rLaVSiYv9/aBg9dEqP/25wG/7S9w/+J3PX79DFEXU63UKhVOo\r02AfPNZa0vQCCrDWMjY6yhufXeVxtMOP24tce+EtBpJ+dhs1rLdYa0GE4H13cKvVQkSIogiUwjuH\rVzkLu3f58NVbfHT1Yy4PX0YVc6Y+mUQrTdZsclayopMLawwSAkopJASMMThyBstPcePFG0wPTrP6\ryyoKRUkXAcjzHGPMofJuikMIOOeIjrrdaDRQKHp0AsDOzg7OOTSKJCoBYIxBRDDGdAc75wghYJ1D\rKUWtVkOhuKB7ANja2kJrTYTuHGaMYX9/v52Ks8EC7O3tca9apZllPN7dRYmiGB1uajab9Pb2krmc\rus0BWF9fxznH8PBwd48VUEwSxsfHeW5ykjRNMcFxYJoADA4OkiQJLWeou8N75XK5k+uuiguFAr1p\rSrlcplarMTIygvGWA9MAYGhoiBACmW9SNxkAxWKR0dHR88FxHBNpjVKKOI65dOkSJrSoHUHKQwN8\ruX2b2dnvqe+0AEjTlFKpRJqm3a1I05RSkqC1pu9iylfN29z6+gP2HtYAuLk2QxwLc4/u8Ew2QkEX\rGBgYIIoienp62m0624ooiojjmPfWXmEh+4693SK9B4fRGoqH+WL3JleefZ63x9+n+muVEIQQPJub\rm9vAX8dJEGm/OZXNrS05qNXEey+fbr8rby6PyLVvKzJ77xvZ2NiQdq2trUkIQUII4r2XpaWfs6mp\rqek2S0ROg7MskyzLxBgj3vsOyHsv1WpVQghijJHFxcUOdGVl2VQqlZdPQp8A53kuWZZJnudijBFr\rrTjnxHsvjUZDQgiSZZnMz8+L916Wl5fMzMzMa/+Eishpj8+ro+bgvSeKIlZWllvXr78zMz+/8MOZ\rG04ofsk511HZVuq97/jZtmJubu7BxMTElbOUtodqf/L+5T/voYj8cd4DfwN9pF2yl1YnnwAAACV0\rRVh0Y3JlYXRlLWRhdGUAMjAwOS0xMS0xNVQxNzowMzowNC0wNzowMNeq4s8AAAAldEVYdGRhdGU6\rY3JlYXRlADIwMTAtMDEtMTFUMDk6MjU6MDYtMDc6MDCV2xO2AAAAJXRFWHRkYXRlOm1vZGlmeQAy\rMDEwLTAxLTExVDA5OjI1OjA2LTA3OjAw5IarCgAAAGd0RVh0TGljZW5zZQBodHRwOi8vY3JlYXRp\rdmVjb21tb25zLm9yZy9saWNlbnNlcy9ieS1zYS8zLjAvIG9yIGh0dHA6Ly9jcmVhdGl2ZWNvbW1v\rbnMub3JnL2xpY2Vuc2VzL0xHUEwvMi4xL1uPPGMAAAAldEVYdG1vZGlmeS1kYXRlADIwMDktMDMt\rMTlUMTA6NTI6NDYtMDY6MDB2ZcMWAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48\rGgAAABN0RVh0U291cmNlAE94eWdlbiBJY29uc+wYrugAAAAndEVYdFNvdXJjZV9VUkwAaHR0cDov\rL3d3dy5veHlnZW4taWNvbnMub3JnL+83qssAAAAASUVORK5CYII\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_XLS, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADSElEQVQ4y7WVvW8jVRDAf/Pe\rem1nnfWZXBJocgqJrojEKU2gAf6Gk6iRrqBFJAVNChqUgoo28AdQIQpOQoqEUK5AgERHh5CSiHDk\rYkIc2/Hau++9ofAHVj5OQuhWmtXMrN7vzc6HRlSVF/FE04aIrADr/5P5C/BrdMW5/vYnj74UqxgD\r1ipDXRED1oIYxYx8xjLSGdoRHH16tPn9kx9/uwomrjpUHW/df52NpQcszy3x4TcfYc0IYMeXjC8F\ricAKRMYCFgBzFbySLnDvzhxvLL/GZz9/zu+dIyrVQHlmSmqByoxSqRiqsWXGRlRtTMWUbs4xQDP+\rAwi8eneJ9998j3t3lijP+GFqjMViEBGsGAyCEcEwso25HbycvEJBn49/2B4dNFRKJSIRBIMdwcYg\rK4LBYAAjzwE/XH+Izx0q/AsQQcwwUpERxBgEEIYvQbDGsl98EG4Er5TuE2zg+PiYJEl4ltVohZe4\rW+njun+yWLdkWUZcrQKQ5zlxHAOwtraGjgbjGrhWqzHIc/7K5+jamJNLy8rLnlgMhbfUajVEhCRJ\rEBGyLKNareK9v31AAAaDASEEmq5BuR/Rz/4m9gWVcgmRgnq9joiQpukQEEUkSUKv10NEbgeHEFBV\rHtSPmJ2dxc05VldXAXj61JGmKSEE6vX6sF+NmfieG3GSJHjvKYqCfr+P955OpzOJpt1uc3l5SRQN\rj3a7XVSVLMtoNBq3g1ut1iTycfQhBERkok9LnudEUURRFDjnJpxrkze/sECj0cCYYZ+KCNbaiR1F\rEdYOx9Z7P/m7PM/pdruDk5OTFqDXJ+/0FBGhVCpRqVTw3k8KFUIgTVOKoqBcLuOc4+zsjDRNGQwG\ruru7+9XBwcGequq1iBcXF2k0GpMc9/t92u02nU6HXq830c/Pzzk8PGJjY4NSqcT+/pNvt7e3t1S1\reWOOm80mxhjiOKZcLpPn+aTi3nucczjnEBGiyHJ4eMje3t53W1ub76rqs1uLNz8/j3OOLMtI05SL\ri4truR53iDFGv378eG9rc/PRNBQAVZ0I8I73XouiUOeceu/Ve68hBA0hqKpqCEHzPNdWqzXY2dn5\rAlicZoxFpnfef1xNOfCTqp7e9FFe1DL9B8uMrvP98FXPAAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5\rLTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMS0xMVQw\rOToyNTowNS0wNzowMKQzCSsAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDk6MjU6MDUt\rMDc6MDDVbrGXAAAAZ3RFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vu\rc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQ\rTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1Mjo0Ni0wNjowMHZl\rwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RFWHRTb3VyY2UAT3h5\rZ2VuIEljb25z7Biu6AAAACd0RVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94eWdlbi1pY29ucy5v\rcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_XML, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADGElEQVQ4y7WVz2skRRSAv9fV\r1TMxIW52UVbZPQjRlSiCuELiD7ytKHhR/wdZr/EP8O5NPIsH0YOgR0EUAoFZ42ISMCMqCqJRWQ+B\rTGa6u7qr6nnI9GR6J5tFxIKiq6nqr7736nW3qCr/R0ubgYhcAi7/R97vqrrfAgOX8rzo1XWNCCCC\riCCMx9PXE5sTQ2PIsmwNmAFL6RyDwYCjowFpmpIkCSKCxogZ36NKp9ulcg6bZaRpSpZldLtd4GTf\raTCJCJ1Oh7m5+yfQmd6YLyy0jEVasbTBkggheAaHQ2KMnL9wgSzLWlARaaWm0TwbLEKapswvLGCM\rIXhPDagqaZrS6XRmwA0uuRu42Tl4jw+BxBhMkhBjnKRnGtisv6uxtZZOlhFVj0McwxojVUVjxFrL\r7c+2zqs1Oe4+BBg5/Idbx2aqiAj1t79Sf/wNIkL5yU38UYGO584ET2r3x1v49zawVy6SGIO1FuOV\r+NUPZNceO47g8nnKd78kfP/nDHTWWARJEsL7PbqvXyV77hEya0nTlPqLPubRB0gvnsNaS/eZh5l7\r7SpH73x+d+OmbDpvvED92Tb+xi+ICPHWgKr3M3MvPzGBVJs/Mfpgk3vXX+K01jq8JhVm5UHsQ/dR\rfboNz18h/+gG3RcfR+7pTMzqvX3Ovf0qyUL3VLA0XzcRWSvLsue9n1gZY05K7JTSijESY0RVMcaQ\rpumaqn49awx47xkOh8e1HAIxRhYXF3HOYYzBGEOe51RVRVmWeB8wJmE4HP4F/D0BqSpj67XSOc2L\rQoui0NFopKPRSPM81zzPtSgKrapKnXO6u7urMUaNMWoIQXd3d4qVlZWnG5aq3vaCAHVVcXh4OAnP\rWov3HlVlfn6esiw5ODiYSPX7e/X1629e6/f7N+98eIC1lqWlpVaeRYQkSQghYK0lyzJUlb297+r1\r9bde6fV6mzOnN50K55wWRaHOOXXOaV3X6r3XEMIk9OFwqFtbW7qzs12srj717HT4030avOq9n8Aa\r4DQ0xqhVVenGxsb+8vLyk3eCqmqr3P7NP+8PVf3trAX/AMqU0uEnPkl+AAAAJXRFWHRjcmVhdGUt\rZGF0ZQAyMDA5LTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAx\rMC0wMS0xMVQwOToyNTowMS0wNzowMFB8LTgAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFU\rMDk6MjU6MDEtMDc6MDAhIZWEAAAAZ3RFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMu\rb3JnL2xpY2Vuc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGlj\rZW5zZXMvTEdQTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1Mjo0\rNi0wNjowMHZlwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RFWHRT\rb3VyY2UAT3h5Z2VuIEljb25z7Biu6AAAACd0RVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94eWdl\rbi1pY29ucy5vcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Public
	#tag EndConstant


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
			Name="SubType"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
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
