#tag Window
Begin ContainerControl MessageView
   AcceptFocus     =   False
   AcceptTabs      =   True
   AutoDeactivate  =   True
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   Compatibility   =   ""
   Enabled         =   True
   EraseBackground =   True
   HasBackColor    =   False
   Height          =   384
   HelpTag         =   ""
   InitialParent   =   ""
   Left            =   32
   LockBottom      =   False
   LockLeft        =   False
   LockRight       =   False
   LockTop         =   False
   TabIndex        =   0
   TabPanelIndex   =   0
   TabStop         =   True
   Top             =   32
   Transparent     =   True
   UseFocusRing    =   False
   Visible         =   True
   Width           =   569
   Begin PagePanel PagePanel1
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   384
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      PanelCount      =   4
      Panels          =   ""
      Scope           =   "0"
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   0
      Value           =   0
      Visible         =   True
      Width           =   569
      Begin Label Label1
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "PagePanel1"
         Italic          =   False
         Left            =   17
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   "0"
         Selectable      =   False
         TabIndex        =   0
         TabPanelIndex   =   1
         TabStop         =   True
         Text            =   "Message Body:"
         TextAlign       =   0
         TextColor       =   
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   4
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin TextArea Message
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   True
         BackColor       =   
         Bold            =   False
         Border          =   True
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   354
         HelpTag         =   ""
         HideSelection   =   True
         Index           =   -2147483648
         InitialParent   =   "PagePanel1"
         Italic          =   False
         Left            =   3
         LimitText       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Mask            =   ""
         Multiline       =   True
         ReadOnly        =   True
         Scope           =   "0"
         ScrollbarHorizontal=   False
         ScrollbarVertical=   True
         Styled          =   True
         TabIndex        =   1
         TabPanelIndex   =   1
         TabStop         =   True
         Text            =   ""
         TextColor       =   
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   24
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   560
      End
      Begin HTMLViewer HTMLViewer1
         AutoDeactivate  =   True
         Enabled         =   True
         Height          =   344
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "PagePanel1"
         Left            =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   "0"
         TabIndex        =   0
         TabPanelIndex   =   3
         TabStop         =   True
         Top             =   20
         Visible         =   True
         Width           =   569
      End
      Begin Canvas ImagePreview
         AcceptFocus     =   False
         AcceptTabs      =   False
         AutoDeactivate  =   True
         Backdrop        =   0
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   384
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "PagePanel1"
         Left            =   0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         Scope           =   "0"
         TabIndex        =   0
         TabPanelIndex   =   2
         TabStop         =   True
         Top             =   0
         UseFocusRing    =   True
         Visible         =   True
         Width           =   569
      End
      Begin Label Status
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "PagePanel1"
         Italic          =   False
         Left            =   0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   False
         Multiline       =   False
         Scope           =   "0"
         Selectable      =   False
         TabIndex        =   1
         TabPanelIndex   =   3
         TabStop         =   True
         Text            =   ""
         TextAlign       =   0
         TextColor       =   
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   364
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   569
      End
      Begin LinkLabel LinkLabel1
         ActiveColor     =   
         AltText         =   ""
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Draggable       =   False
         Enabled         =   True
         Height          =   20
         HilightColor    =   
         HoverPeriod     =   250
         Index           =   -2147483648
         InitialParent   =   "PagePanel1"
         Italic          =   False
         Left            =   426
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         ResetPeriod     =   1000
         Scope           =   "0"
         Selectable      =   False
         TabIndex        =   2
         TabPanelIndex   =   1
         TabStop         =   True
         Text            =   "View as media"
         TextAlign       =   2
         TextColor       =   
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   3
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   137
      End
      Begin LinkLabel PageTitle
         ActiveColor     =   
         AltText         =   ""
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Draggable       =   False
         Enabled         =   True
         Height          =   20
         HilightColor    =   
         HoverPeriod     =   250
         Index           =   -2147483648
         InitialParent   =   "PagePanel1"
         Italic          =   False
         Left            =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         ResetPeriod     =   1000
         Scope           =   "0"
         Selectable      =   False
         TabIndex        =   2
         TabPanelIndex   =   3
         TabStop         =   True
         Text            =   ""
         TextAlign       =   0
         TextColor       =   
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   0
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   569
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h21
		Private Function Scale(Source As Picture, Ratio As Double = 1.0) As Picture
		  //Returns a scaled version of the passed Picture object.
		  //A ratio of 1.0 is 100% (no change,) 0.5 is 50% (half size) and so forth.
		  //This function should be cross-platform safe.
		  
		  Dim wRatio, hRatio As Double
		  wRatio = (Ratio * Source.width)
		  hRatio = (Ratio * Source.Height)
		  If wRatio = Source.Width And hRatio = Source.Height Then Return Source
		  Dim photo As New Picture(wRatio, hRatio, Source.Depth)
		  Photo.Graphics.DrawPicture(Source, 0, 0, Photo.Width, Photo.Height, 0, 0, Source.Width, Source.Height)
		  Return photo
		  
		Exception
		  Return Source
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetData(Raw As String, MIME As String)
		  PreviewPic = Nil
		  Message.Text = Raw
		  
		  Select Case NthField(MIME, ";", 1)
		  Case "image/png", "image/jpg", "image/jpeg", "image/bmp"
		    PreviewPic = Picture.FromData(Raw)
		    PreviewPanel = 1
		  Case "text/html", "text/xhtml"
		    PreviewPanel = 2
		    Dim f As FolderItem = GetTemporaryFolderItem()
		    f.Name = "preview.html"
		    Dim bs As BinaryStream = BinaryStream.Create(f, True)
		    bs.Write(Message.Text)
		    bs.Close
		    HTMLViewer1.LoadPage(f)
		  Else
		    PreviewPanel = 0
		  End Select
		  
		  PagePanel1.Value = PreviewPanel
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mResponse As HTTP.Response
	#tag EndProperty

	#tag Property, Flags = &h0
		PreviewPanel As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		PreviewPic As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		RequestURL As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mResponse
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mResponse = value
			  Message.Text = Me.Response.MessageBody
			  PagePanel1.Value = 0
			End Set
		#tag EndSetter
		Response As HTTP.Response
	#tag EndComputedProperty


#tag EndWindowCode

#tag Events HTMLViewer1
	#tag Event
		Sub StatusChanged(newStatus as String)
		  Status.Text = newStatus
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  Dim f As FolderItem = GetTemporaryFolderItem()
		  f.name = "blank.html"
		  Dim bs As BinaryStream = BinaryStream.Create(f, True)
		  bs.Write("<HTML><head>Blank</head><body>&nbsp; <!-- this page intentionally blank --></body></HTML>")
		  bs.Close
		  Me.LoadPage(f)
		End Sub
	#tag EndEvent
	#tag Event
		Sub TitleChanged(newTitle as String)
		  PageTitle.Text = newTitle
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub DocumentComplete(URL as String)
		  Self.RequestURL = URL
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ImagePreview
	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  #If RBVersion >= 2012 Then 'areas() was added in RS2012 R1
		    #pragma Unused areas
		  #endif
		  If PreviewPic <> Nil Then
		    If PreviewPic.Width > g.Width Or PreviewPic.Height > g.Height Then
		      Dim ratio As Double
		      If PreviewPic.Width > PreviewPic.Height Then
		        ratio = g.Width / PreviewPic.Width
		      Else
		        ratio = g.Height / PreviewPic.Height
		      End If
		      PreviewPic = Scale(PreviewPic, ratio)
		    End If
		    g.DrawPicture(PreviewPic, 0, 0)
		    
		  Else
		    g.ClearRect(0, 0, g.Width, g.Height)
		    
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events LinkLabel1
	#tag Event
		Sub Action()
		  If Response <> Nil Then
		    SetData(Response.MessageBody, Response.Headers.Value("Content-Type"))
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PageTitle
	#tag Event
		Sub Action()
		  ShowURL(Self.RequestURL)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="AcceptFocus"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AcceptTabs"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AutoDeactivate"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Appearance"
		InitialValue="&hFFFFFF"
		Type="Color"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		Type="Picture"
		EditorType="Picture"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="EraseBackground"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="300"
		Type="Integer"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HelpTag"
		Visible=true
		Group="Appearance"
		Type="String"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="InitialParent"
		Group="Position"
		Type="String"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Left"
		Visible=true
		Group="Position"
		Type="Integer"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockBottom"
		Visible=true
		Group="Position"
		Type="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockLeft"
		Visible=true
		Group="Position"
		Type="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockRight"
		Visible=true
		Group="Position"
		Type="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockTop"
		Visible=true
		Group="Position"
		Type="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="PreviewPanel"
		Group="Behavior"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="PreviewPic"
		Group="Behavior"
		Type="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="RequestURL"
		Group="Behavior"
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIndex"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabPanelIndex"
		Group="Position"
		InitialValue="0"
		Type="Integer"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabStop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Top"
		Visible=true
		Group="Position"
		Type="Integer"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Transparent"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="UseFocusRing"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="300"
		Type="Integer"
		InheritedFrom="ContainerControl"
	#tag EndViewProperty
#tag EndViewBehavior
