#tag Window
Begin Window FileServerDemo
   BackColor       =   "&cFFFFFF00"
   Backdrop        =   0
   CloseButton     =   True
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
      InitialParent   =   ""
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
   Begin Timer LogTimer
      Height          =   32
      Index           =   -2147483648
      Left            =   545
      LockedInPosition=   False
      Mode            =   2
      Period          =   250
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   478
      Width           =   32
   End
   Begin PushButton PushButton5
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
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
   Begin WebServer.FileServer Sock
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
      Scope           =   0
      SessionTimeout  =   600
      TabPanelIndex   =   0
      Threading       =   True
      Top             =   478
      UseCompression  =   ""
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
      InitialParent   =   ""
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
      Width           =   64
   End
   Begin PushButton PushButton2
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Host Folder"
      Default         =   ""
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
      Top             =   415
      Underline       =   False
      Visible         =   True
      Width           =   97
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
      BackColor       =   "&cFFFFFF00"
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
      InitialParent   =   ""
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
      Text            =   8080
      TextColor       =   "&c00000000"
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
      InitialParent   =   ""
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
   Begin Listbox Listbox1
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   4
      ColumnsResizable=   True
      ColumnWidths    =   "60%,20%,10%"
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
      InitialValue    =   "Log Data	Date	Type	Thread ID"
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
   Begin TextField Username
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   "&cFFFFFF00"
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
      InitialParent   =   ""
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
      TextColor       =   "&c00000000"
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
      BackColor       =   "&cFFFFFF00"
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
      InitialParent   =   ""
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
      TextColor       =   "&c00000000"
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
      BackColor       =   "&cFFFFFF00"
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
      InitialParent   =   ""
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
      TextColor       =   "&c00000000"
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   488
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
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
      TextColor       =   "&c00000000"
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   415
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   8
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
   Begin TextField SearchField
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   "&cFFFFFF00"
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
      InitialParent   =   ""
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
      TextColor       =   "&c00000000"
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
      ButtonStyle     =   0
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
      Width           =   83
   End
   Begin CheckBox CheckBox5
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Threading"
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
      TabIndex        =   25
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   489
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   164
   End
   Begin PushButton PushButton8
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Host Shortener"
      Default         =   ""
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
      TabIndex        =   26
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   439
      Underline       =   False
      Visible         =   True
      Width           =   97
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
		    If MsgBox("This will reset all open sockets. Proceed?", 36, "Change Network Interface") <> 6 Then Return
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
		  Dim script As New HTTP.ScriptDocument
		  script.Path = New HTTP.URI("/scripts/helloworld.bs")
		  Sock.AddRedirect(script)
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
		Protected Messages() As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SharedFile As FolderItem
	#tag EndProperty


#tag EndWindowCode

#tag Events LogLevel
	#tag Event
		Sub Open()
		  'For i As Integer = 2 DownTo -2
		  'Me.AddRow(Format(i, "-0"))
		  'Next
		  'Me.ListIndex = 3
		  Me.AddRow("Off")
		  Me.RowTag(0) = 4
		  Me.AddRow("Errors Only")
		  Me.RowTag(1) = 3
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
#tag Events LogTimer
	#tag Event
		Sub Action()
		  Dim message As String
		  Dim severity As Double
		  Dim ThreadID As String
		  While UBound(messages) > -1
		    Dim p As Dictionary = messages.Pop
		    message = P.Value("Message")
		    severity = p.Value("Severity")
		    If p.Value("ThreadID") <> 0 Then
		      ThreadID = "0x" + Left(Hex(p.Value("ThreadID")) + "00000000", 8)
		    Else
		      ThreadID = "Main Thread"
		    End If
		    message = ReplaceAll(message, WebServer.VirtualRoot, "virtual_root")
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
		    Dim lcount As Integer = UBound(lines)
		    For i As Integer = 0 To lcount
		      If lines(i).Trim <> "" Then
		        Select Case Severity
		        Case HTTP.BaseServer.Log_Request, HTTP.BaseServer.Log_Status
		          If Severity < squelch And squelch <> HTTP.BaseServer.Log_Response Then Continue While
		          If i = 0 And severity <> HTTP.BaseServer.Log_Status Then
		            Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "HTTP Request", ThreadID)
		            Listbox1.RowPicture(Listbox1.LastIndex) = greenarrowright
		          ElseIf severity = HTTP.BaseServer.Log_Status Then
		            Listbox1.AddRow(lines(i), " ", " ", ThreadID)
		          Else
		            Listbox1.AddRow(lines(i), " ", " ")
		            Listbox1.RowPicture(Listbox1.LastIndex) = New Picture(greenarrowright.Width, greenarrowright.Height)
		          End If
		          
		          Listbox1.RowTag(Listbox1.LastIndex) = &c0080FF99
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		          
		        Case HTTP.BaseServer.Log_Response
		          If Severity < squelch And squelch <> HTTP.BaseServer.Log_Request Then Continue While
		          
		          If i = 0 Then
		            Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "HTTP Reply", ThreadID)
		            Listbox1.RowPicture(Listbox1.LastIndex) = blue_left_arrow
		          Else
		            Listbox1.AddRow(lines(i), " ", " ")
		            Listbox1.RowPicture(Listbox1.LastIndex) = New Picture(blue_left_arrow.Width, blue_left_arrow.Height)
		          End If
		          
		          Listbox1.RowTag(Listbox1.LastIndex) = &c00FF0099
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		        Case HTTP.BaseServer.Log_Error
		          If Severity < squelch Then Continue While
		          If i = 0 Then
		            Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "Error!", ThreadID)
		            Listbox1.RowPicture(Listbox1.LastIndex) = error
		          Else
		            Listbox1.AddRow(lines(i), " ", " ")
		            Listbox1.RowPicture(Listbox1.LastIndex) = New Picture(error.Width, error.Height)
		          End If
		          Listbox1.RowTag(Listbox1.LastIndex) = &cFF000099
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		        Case HTTP.BaseServer.Log_Debug
		          If Severity < squelch Then Continue While
		          Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "Debug", ThreadID)
		          Listbox1.RowTag(Listbox1.LastIndex) = &cFFFF0099
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		          Listbox1.RowPicture(Listbox1.LastIndex) = debugIcon
		        Case HTTP.BaseServer.Log_Socket
		          If Severity < squelch Then Continue While
		          Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "Socket", ThreadID)
		          Listbox1.RowTag(Listbox1.LastIndex) = &cC0C0C099
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		          Listbox1.RowPicture(Listbox1.LastIndex) = socketIcon
		        Case HTTP.BaseServer.Log_Trace
		          If Severity < squelch Then Continue While
		          Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "Trace", ThreadID)
		          Listbox1.RowTag(Listbox1.LastIndex) = &c80808099
		          Listbox1.CellTag(Listbox1.LastIndex, 0) = severity
		          Listbox1.RowPicture(Listbox1.LastIndex) = traceIcon
		        Else
		          Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "Unspecified", ThreadID)
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
#tag Events PushButton5
	#tag Event
		Sub Action()
		  Listbox1.DeleteAllRows
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
		  Dim msg As New Dictionary
		  msg.Value("Message") = Message
		  msg.Value("Severity") = Severity
		  If App.CurrentThread <> Nil Then
		    msg.Value("ThreadID") = App.CurrentThread.ThreadID
		  Else
		    msg.Value("ThreadID") = 0
		  End If
		  Messages.Insert(0, msg)
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function TamperResponse(ByRef Response As HTTP.Response) As Boolean
		  If Response.StatusCode = 200 Then
		    Response.SetHeader("X-Judgement-Render") = "Your request is granted."
		  ElseIf Response.StatusCode = 302 Then
		    Response.SetHeader("X-Judgement-Render") = "Your request is pending."
		  Else
		    Response.SetHeader("X-Judgement-Render") = "Your request is denied."
		  End If
		  Return True
		  
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  SharedFile = SelectFolder()'GetOpenFolderItem("")
		  If SharedFile = Nil Then Return
		  Begin()
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CheckBox1
	#tag Event
		Sub Open()
		  Me.Value = Sock.UseCompression
		  Me.Enabled = GZIPAvailable
		End Sub
	#tag EndEvent
	#tag Event
		Sub Action()
		  Sock.UseCompression = Me.Value
		End Sub
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
#tag Events CheckBox3
	#tag Event
		Sub Action()
		  Sock.DirectoryBrowsing = Me.Value
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  'Me.Value = Sock.DirectoryBrowsing
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Listbox1
	#tag Event
		Function CellBackgroundPaint(g As Graphics, row As Integer, column As Integer) As Boolean
		  #pragma Unused column
		  If row > Me.LastIndex Or Me.ListCount < 1 Then Return False
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
	#tag Event
		Function HeaderPressed(column as Integer) As Boolean
		  #pragma Unused column
		  Return True
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events CheckBox2
	#tag Event
		Sub Action()
		  Username.Enabled = Me.Value
		  Password.Enabled = Me.Value
		  realmtext.Enabled = Me.Value
		  sock.AuthenticationRequired = Me.Value
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
#tag Events UseSessions
	#tag Event
		Sub Open()
		  Me.Value = Sock.UseSessions
		End Sub
	#tag EndEvent
	#tag Event
		Sub Action()
		  Sock.UseSessions = Me.Value
		  
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
#tag Events CheckBox4
	#tag Event
		Sub Action()
		  If sock.IsListening Then
		    If MsgBox("This will reset all open connections. Proceed?", 52, "Confirm socket reset") <> 6 Then
		      Me.Value = (sock.ConnectionType = ConnectionTypes.Insecure)
		    Else
		      Sock.StopListening
		      If Me.Value Then
		        Dim f As FolderItem = Sock.CertificateFile
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
		    End If
		  ElseIf Me.Value Then
		    Dim f As FolderItem = Sock.CertificateFile
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
		    sock.CertificateFile.Delete
		    sock.CertificateFile = Nil
		    sock.CertificatePassword = ""
		    sock.ConnectionType = ConnectionTypes.Insecure
		  End If
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CheckBox5
	#tag Event
		Sub Action()
		  Sock.Threading = Me.Value
		  
		  If Me.Value Then
		    Listbox1.ColumnWidths = "60%, 20%, 10%, *"
		  Else
		    Listbox1.ColumnWidths = "70%, 20%, 10%, *"
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  Me.Value = Sock.Threading
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton8
	#tag Event
		Sub Action()
		  ShortURLDemo.Show
		End Sub
	#tag EndEvent
#tag EndEvents
