#tag Window
Begin Window FileServerDemo
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   518
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   1027555327
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   2
   Resizeable      =   True
   Title           =   "Server Demo"
   Visible         =   True
   Width           =   779
   Begin PushButton PushButton1
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Host Folder"
      Default         =   False
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   10
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   439
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin PushButton PushButton2
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Host File"
      Default         =   False
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   10
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   412
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin CheckBox CheckBox1
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Enable GZip Compression"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   113
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      State           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   11.0
      TextUnit        =   0
      Top             =   465
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   175
   End
   Begin TextField port
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   257
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "8080"
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   415
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   53
   End
   Begin ComboBox nic
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   False
      Left            =   113
      ListIndex       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   414
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   132
   End
   Begin ComboBox LogLevel
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   False
      Left            =   657
      ListIndex       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   408
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   116
   End
   Begin CheckBox CheckBox3
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Directory Browsing"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   113
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      State           =   1
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   440
      Underline       =   False
      Value           =   True
      Visible         =   True
      Width           =   162
   End
   Begin TextField Username
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   322
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Username"
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   440
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin CheckBox CheckBox2
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Authenticate"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   322
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      State           =   0
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   416
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   88
   End
   Begin TextField password
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   322
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Password"
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   464
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin TextField realmtext
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   322
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "realm"
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   488
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin PushButton PushButton4
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Generator"
      Default         =   False
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   10
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   16
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   465
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin Listbox Listbox1
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   3
      ColumnsResizable=   False
      ColumnWidths    =   "70%,20%,10%"
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   1
      GridLinesVertical=   1
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   379
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Log Data	Date	Type"
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   17
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   22
      Underline       =   False
      UseFocusRing    =   False
      Visible         =   True
      Width           =   779
      _ScrollWidth    =   -1
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   249
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   18
      TabPanelIndex   =   0
      Text            =   ":"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   415
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   8
   End
   Begin Timer LogTimer
      Height          =   32
      Index           =   -2147483648
      Left            =   545
      LockedInPosition=   False
      Mode            =   2
      Period          =   1
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   478
      Width           =   32
   End
   Begin CheckBox UseSessions
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Use Sessions"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   113
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      State           =   1
      TabIndex        =   19
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   11.0
      TextUnit        =   0
      Top             =   489
      Underline       =   False
      Value           =   True
      Visible         =   True
      Width           =   175
   End
   Begin HTTP.FileServer Sock
      AllowPipeLinedRequests=   False
      AuthenticationRealm=   "Restricted Area"
      AuthenticationRequired=   False
      CertificatePassword=   ""
      DirectoryBrowsing=   True
      EnforceContentType=   True
      Height          =   32
      Index           =   -2147483648
      Left            =   503
      LockedInPosition=   False
      MaximumSocketsConnected=   10
      MinimumSocketsAvailable=   2
      Port            =   0
      Scope           =   1
      SessionTimeout  =   60
      TabPanelIndex   =   0
      Top             =   478
      UseSessions     =   True
      Width           =   32
   End
   Begin ComboBox SecurityLevel
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialValue    =   "TLS\r\nSSL"
      Italic          =   False
      Left            =   589
      ListIndex       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   20
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   412
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   49
   End
   Begin CheckBox CheckBox4
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Security:"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   503
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      State           =   0
      TabIndex        =   21
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   416
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   74
   End
   Begin PushButton PushButton5
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Clear Log"
      Default         =   False
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   693
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   22
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   10.0
      TextUnit        =   0
      Top             =   438
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin TextField SearchField
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   0
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   23
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   0
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   735
   End
   Begin PushButton PushButton6
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Next"
      Default         =   False
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   739
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   24
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   0
      Underline       =   False
      Visible         =   True
      Width           =   34
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Close()
		  Sock.StopListening
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Begin()
		  If Sock.IsListening Then
		    If Not MsgBox("This will reset all open sockets. Proceed?", 36, "Change Network Interface") = 6 Then Return
		  End If
		  Sock.StopListening
		  If nic.Text.Trim <> "" Then
		    Sock.NetworkInterface = nic.RowTag(nic.ListIndex)
		  Else
		    sock.NetworkInterface = System.GetNetworkInterface(0)
		  End If
		  Sock.Port = Val(port.Text)
		  Sock.DocumentRoot = SharedFile
		  Sock.UseSessions = UseSessions.Value
		  sock.Listen
		  If Sock.ConnectionType = ConnectionTypes.Insecure Then
		    ShowURL("http://" + Sock.NetworkInterface.IPAddress + ":" + Str(Sock.Port) + "/")
		  Else
		    ShowURL("https://" + Sock.NetworkInterface.IPAddress + ":" + Str(Sock.Port) + "/")
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CurrentSearchIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private LastLogDirection As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Messages() As Pair
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SharedFile As FolderItem
	#tag EndProperty


#tag EndWindowCode

#tag Events PushButton1
	#tag Event
		Sub Action()
		  SharedFile = SelectFolder()'GetOpenFolderItem("")
		  If SharedFile = Nil Then Return
		  Begin()
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  SharedFile = GetOpenFolderItem("")
		  If SharedFile = Nil Then Return
		  Begin()
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CheckBox1
	#tag Event
		Sub Open()
		  Me.Value = GZIPAvailable
		  Me.Enabled = GZIPAvailable
		End Sub
	#tag EndEvent
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  #pragma Unused X
		  #pragma Unused Y
		  MsgBox("Must be (en/dis)abled at compile time.")
		  Return True
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events port
	#tag Event
		Sub TextChange()
		  Sock.Port = Val(Me.Text)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events nic
	#tag Event
		Sub Open()
		  Dim i As Integer
		  For i = 0 To System.NetworkInterfaceCount - 1
		    Me.AddRow(System.GetNetworkInterface(i).IPAddress)
		    If System.GetNetworkInterface(i).IPAddress <> "0.0.0.0" Then
		      Me.RowTag(i) = System.GetNetworkInterface(i)
		    End If
		  Next
		  For i = Me.ListCount - 1 DownTo 0
		    If Me.RowTag(i) = Nil Then
		      Me.RemoveRow(i)
		    Else
		      Me.ListIndex = i
		    End If
		  Next
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events LogLevel
	#tag Event
		Sub Open()
		  'For i As Integer = 2 DownTo -2
		  'Me.AddRow(Format(i, "-0"))
		  'Next
		  'Me.ListIndex = 3
		  Me.AddRow("Off")
		  Me.RowTag(0) = 3
		  Me.AddRow("Errors Only")
		  Me.RowTag(1) = 2
		  Me.AddRow("Normal")
		  Me.RowTag(2) = 1
		  Me.AddRow("Debug")
		  Me.RowTag(3) = -1
		  Me.AddRow("Trace")
		  Me.RowTag(4) = -2
		  Me.AddRow("Socket")
		  Me.RowTag(5) = -3
		  Me.ListIndex = 2
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CheckBox3
	#tag Event
		Sub Action()
		  If Sock.IsListening Then
		    If Not MsgBox("This will reset all open sockets. Proceed?", 36, "Change socket variable") = 6 Then Return
		  End If
		  Sock.DirectoryBrowsing = Me.Value
		  If Sock.IsListening Then
		    Sock.StopListening
		    Sock.Listen
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  'Me.Value = Sock.DirectoryBrowsing
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CheckBox2
	#tag Event
		Sub Open()
		  'Me.Value = Sock.Authenticate
		  'Username.Enabled = Me.Value
		  'Password.Enabled = Me.Value
		  'realmtext.Enabled = Me.Value
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Action()
		  Username.Enabled = Me.Value
		  Password.Enabled = Me.Value
		  realmtext.Enabled = Me.Value
		  sock.AuthenticationRequired = Me.Value
		  Sock.StopListening
		  Sock.Listen
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events realmtext
	#tag Event
		Sub TextChange()
		  Sock.AuthenticationRealm = Me.Text
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton4
	#tag Event
		Sub Action()
		  Generator.Show
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Listbox1
	#tag Event
		Function CellBackgroundPaint(g As Graphics, row As Integer, column As Integer) As Boolean
		  #pragma Unused column
		  If row > Me.LastIndex Then Return False
		  If Me.RowTag(row) <> Nil Then
		    g.ForeColor = Me.RowTag(row)
		    g.FillRect(0, 0, g.Width, g.Height)
		  End If
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Function CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  #pragma Unused x
		  #pragma Unused y
		  #pragma Unused row
		  #pragma Unused column
		  Return True
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events LogTimer
	#tag Event
		Sub Action()
		  Dim message As String
		  Dim severity As Integer
		  While UBound(messages) > -1
		    Dim p As Pair = messages.Pop
		    message = P.Left
		    severity = p.Right
		    Dim lines() As String = Split(Message, EndOfLine)
		    Dim squelch As Integer
		    #pragma BreakOnExceptions Off
		    Try
		      squelch = LogLevel.RowTag(LogLevel.ListIndex)
		    Catch
		      'meh
		    End Try
		    #pragma BreakOnExceptions default
		    Dim now As New Date
		    For i As Integer = 0 To UBound(lines)
		      If lines(i).Trim <> "" Then
		        Select Case Severity
		        Case HTTP.BaseServer.Log_Request
		          If Severity < squelch And squelch <> HTTP.BaseServer.Log_Response Then Return
		          If i = 0 Then
		            Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "HTTP Request")
		            Listbox1.RowPicture(Listbox1.LastIndex) = greenarrowright
		          Else
		            Listbox1.AddRow(lines(i), " ", " ")
		            Listbox1.RowPicture(Listbox1.LastIndex) = New Picture(greenarrowright.Width, greenarrowright.Height)
		          End If
		          
		          Listbox1.RowTag(Listbox1.LastIndex) = &c0080FF99
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		          
		        Case HTTP.BaseServer.Log_Response
		          If Severity < squelch And squelch <> HTTP.BaseServer.Log_Request Then Return
		          
		          If i = 0 Then
		            Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "HTTP Reply")
		            Listbox1.RowPicture(Listbox1.LastIndex) = blue_left_arrow
		          Else
		            Listbox1.AddRow(lines(i), " ", " ")
		            Listbox1.RowPicture(Listbox1.LastIndex) = New Picture(blue_left_arrow.Width, blue_left_arrow.Height)
		          End If
		          
		          Listbox1.RowTag(Listbox1.LastIndex) = &c00FF0099
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		        Case HTTP.BaseServer.Log_Error
		          If Severity < squelch Then Return
		          If i = 0 Then
		            Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "Error!")
		            Listbox1.RowPicture(Listbox1.LastIndex) = error
		          Else
		            Listbox1.AddRow(lines(i), " ", " ")
		            Listbox1.RowPicture(Listbox1.LastIndex) = New Picture(error.Width, error.Height)
		          End If
		          Listbox1.RowTag(Listbox1.LastIndex) = &cFF000099
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		        Case HTTP.BaseServer.Log_Debug
		          If Severity < squelch Then Return
		          Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "Debug")
		          Listbox1.RowTag(Listbox1.LastIndex) = &cFFFF0099
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		          Listbox1.RowPicture(Listbox1.LastIndex) = debugIcon
		        Case HTTP.BaseServer.Log_Socket
		          If Severity < squelch Then Return
		          Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "Socket")
		          Listbox1.RowTag(Listbox1.LastIndex) = &cC0C0C099
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		          Listbox1.RowPicture(Listbox1.LastIndex) = socketIcon
		        Case HTTP.BaseServer.Log_Trace
		          If Severity < squelch Then Return
		          Listbox1.AddRow(lines(i)), now.ShortDate + " " + Now.LongTime, "Trace"
		          Listbox1.RowTag(Listbox1.LastIndex) = &c80808099
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		          Listbox1.RowPicture(Listbox1.LastIndex) = traceIcon
		        Else
		          Listbox1.AddRow(lines(i)), now.ShortDate + " " + Now.LongTime, "Unspecified"
		          Listbox1.RowTag(Listbox1.LastIndex) = &cFFFFFF99
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		        End Select
		      End If
		    Next
		    Listbox1.ScrollPosition = Listbox1.LastIndex
		  Wend
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events UseSessions
	#tag Event
		Sub Open()
		  Me.Value = Sock.UseSessions
		End Sub
	#tag EndEvent
	#tag Event
		Sub Action()
		  If Sock.UseSessions <> Me.Value Then
		    If Sock.IsListening Then
		      If Not MsgBox("This will reset all open sockets. Proceed?", 36, "Change socket variable") = 6 Then
		        Return
		      End If
		    End If
		    Sock.UseSessions = Me.Value
		  End If
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Sock
	#tag Event
		Function Authenticate(ClientRequest As HTTP.Request) As Boolean
		  Return Username.Text  = ClientRequest.AuthUsername And Password.Text = ClientRequest.AuthPassword 'And realmtext.Text = ClientRequest.AuthRealm
		End Function
	#tag EndEvent
	#tag Event
		Sub Log(Message As String, Severity As Integer)
		  Messages.Insert(0, Message:Severity)
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function TamperResponse(ByRef Response As HTTP.Response) As Boolean
		  If Response.StatusCode = 200 Then
		    Response.SetHeader("X-Judgement-Render", "Your request is granted.")
		  ElseIf Response.StatusCode = 302 Then
		    Response.SetHeader("X-Judgement-Render", "Your request is pending.")
		  Else
		    Response.SetHeader("X-Judgement-Render", "Your request is denied.")
		  End If
		  Return True
		  
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events CheckBox4
	#tag Event
		Sub Open()
		  'Me.Value = Sock.Authenticate
		  'Username.Enabled = Me.Value
		  'Password.Enabled = Me.Value
		  'realmtext.Enabled = Me.Value
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Action()
		  If Sock.IsListening Then
		    If Not MsgBox("This will reset all open sockets. Proceed?", 36, "Change Interface Security") = 6 Then Return
		  End If
		  Sock.StopListening
		  If Me.Value Then
		    Dim f As FolderItem = Sock.CertificateFile
		    If f = Nil Then f = SpecialFolder.Temporary.Child("cert.rbcert." + Str(Microseconds))
		    Dim s As String = CertificateEntry.GetCert(f, "")
		    If s <> "" And f.Exists Then
		      Sock.CertificateFile = f
		      Sock.CertificatePassword = s
		      If SecurityLevel.Text = "TLS" Then
		        Sock.ConnectionType = ConnectionTypes.TLSv1
		      Else
		        Sock.ConnectionType = ConnectionTypes.SSLv3
		      End If
		    Else
		      Sock.ConnectionType = ConnectionTypes.Insecure
		      Me.State = CheckBox.CheckedStates.Unchecked
		    End If
		  Else
		    Sock.ConnectionType = ConnectionTypes.Insecure
		  End If
		  Sock.Listen
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton5
	#tag Event
		Sub Action()
		  Listbox1.DeleteAllRows
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton6
	#tag Event
		Sub Action()
		  If CurrentSearchIndex > Listbox1.ListCount - 1 Then CurrentSearchIndex = 0
		  For i As Integer = CurrentSearchIndex To Listbox1.LastIndex
		    If InStr(Listbox1.Cell(i, 0), SearchField.Text) > 0 Then
		      Listbox1.ListIndex = i
		      Listbox1.ScrollPosition = i
		      CurrentSearchIndex = i + 1
		      Exit For
		    ElseIf i >= Listbox1.ListCount - 1 Then
		      If MsgBox("Continue search from start?", 36, "Log search") = 6 Then
		        i = 0
		      End If
		    End If
		  Next
		  
		Exception OutOfBoundsException
		  MsgBox("No more matches")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Appearance"
		InitialValue="&hFFFFFF"
		Type="Color"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		Type="Picture"
		EditorType="Picture"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CurrentSearchIndex"
		Group="Behavior"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		InheritedFrom="Window"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"10 - Drawer Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		Type="String"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LiveResize"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		Type="MenuBar"
		EditorType="MenuBar"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Placement"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		InheritedFrom="Window"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
		InheritedFrom="Window"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
		InheritedFrom="Window"
	#tag EndViewProperty
#tag EndViewBehavior
