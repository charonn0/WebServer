#tag Window
Begin Window FileServerDemo
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   5.18e+2
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
   Width           =   7.79e+2
   Begin PushButton PushButton1
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Host Folder"
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
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
      TextSize        =   0
      TextUnit        =   0
      Top             =   439
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin PushButton PushButton2
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Host File"
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
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
      TextSize        =   0
      TextUnit        =   0
      Top             =   412
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin CheckBox CheckBox1
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Enable GZip Compression"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
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
      TextSize        =   11
      TextUnit        =   0
      Top             =   465
      Underline       =   ""
      Value           =   False
      Visible         =   True
      Width           =   175
   End
   Begin TextField port
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   ""
      Left            =   257
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   ""
      ReadOnly        =   ""
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   8080
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   415
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   53
   End
   Begin ComboBox nic
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   ""
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
      TextSize        =   0
      TextUnit        =   0
      Top             =   414
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   132
   End
   Begin ComboBox LogLevel
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   ""
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
      TextSize        =   0
      TextUnit        =   0
      Top             =   408
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   116
   End
   Begin CheckBox CheckBox3
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Directory Browsing"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
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
      TextSize        =   0
      TextUnit        =   0
      Top             =   440
      Underline       =   ""
      Value           =   True
      Visible         =   True
      Width           =   162
   End
   Begin TextField Username
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   ""
      Left            =   322
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   ""
      ReadOnly        =   ""
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Username"
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   440
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin CheckBox CheckBox2
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Authenticate"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
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
      TextSize        =   0
      TextUnit        =   0
      Top             =   416
      Underline       =   ""
      Value           =   False
      Visible         =   True
      Width           =   88
   End
   Begin TextField password
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   ""
      Left            =   322
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   ""
      ReadOnly        =   ""
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Password"
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   464
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin TextField realmtext
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   ""
      Left            =   322
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   ""
      ReadOnly        =   ""
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "realm"
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   488
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin ComboBox nic1
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialValue    =   "None\r\nBasic\r\nHash"
      Italic          =   ""
      Left            =   416
      ListIndex       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   15
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   415
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   68
   End
   Begin PushButton PushButton4
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Generator"
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
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
      TextSize        =   0
      TextUnit        =   0
      Top             =   465
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin Listbox Listbox1
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   ""
      Border          =   True
      ColumnCount     =   3
      ColumnsResizable=   ""
      ColumnWidths    =   "70%,20%,10%"
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   True
      EnableDrag      =   ""
      EnableDragReorder=   ""
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   401
      HelpTag         =   ""
      Hierarchical    =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Log Data	Date	Type"
      Italic          =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   ""
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   17
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   0
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   779
      _ScrollWidth    =   -1
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   249
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   18
      TabPanelIndex   =   0
      Text            =   ":"
      TextAlign       =   0
      TextColor       =   &h000000
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   415
      Transparent     =   True
      Underline       =   ""
      Visible         =   True
      Width           =   8
   End
   Begin Timer LogTimer
      Height          =   32
      Index           =   -2147483648
      Left            =   741
      LockedInPosition=   False
      Mode            =   2
      Period          =   1
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   477
      Width           =   32
   End
   Begin CheckBox UseSessions
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Use Sessions"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
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
      TextSize        =   11
      TextUnit        =   0
      Top             =   489
      Underline       =   ""
      Value           =   True
      Visible         =   True
      Width           =   175
   End
   Begin HTTP.FileServer Sock
      AuthenticationRealm=   "Restricted Area"
      AuthenticationRequired=   ""
      DirectoryBrowsing=   True
      EnforceContentType=   True
      Height          =   32
      Index           =   -2147483648
      KeepAlive       =   ""
      Left            =   699
      LockedInPosition=   False
      MaximumSocketsConnected=   10
      MinimumSocketsAvailable=   2
      Port            =   0
      Scope           =   1
      SessionTimeout  =   ""
      TabPanelIndex   =   0
      Top             =   477
      UseSessions     =   True
      Width           =   32
   End
   Begin ComboBox SecurityLevel
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialValue    =   "TLS\r\nSSL"
      Italic          =   ""
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
      TextSize        =   0
      TextUnit        =   0
      Top             =   412
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   49
   End
   Begin CheckBox CheckBox4
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Security:"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
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
      TextSize        =   0
      TextUnit        =   0
      Top             =   416
      Underline       =   ""
      Value           =   False
      Visible         =   True
      Width           =   74
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
		  Sock.Document = SharedFile
		  Dim redirect As New HTTPParse.VirtualResponse("/bs", "http://www.boredomsoft.org")
		  Sock.AddRedirect(redirect)
		  Sock.UseSessions = UseSessions.Value
		  'Sock.ConnectionType = ConnectionTypes.TLSv1
		  'Sock.CertificateFile = SpecialFolder.Desktop.Child("TestCert.RBCert")
		  'Sock.CertificatePassword = "CertDemo"
		  sock.Listen
		  If Sock.ConnectionType = ConnectionTypes.Insecure Then
		    ShowURL("http://" + Sock.NetworkInterface.IPAddress + ":" + Str(Sock.Port) + "/")
		  Else
		    ShowURL("https://" + Sock.NetworkInterface.IPAddress + ":" + Str(Sock.Port) + "/")
		  End If
		End Sub
	#tag EndMethod


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
		  Me.AddRow("Normal")
		  Me.RowTag(0) = 1
		  Me.AddRow("Debug")
		  Me.RowTag(1) = -1
		  Me.AddRow("Socket")
		  Me.RowTag(2) = -2
		  Me.AddRow("Trace")
		  Me.RowTag(3) = -3
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
#tag Events nic1
	#tag Event
		Sub Open()
		  'Me.ListIndex = Sock.AuthType
		End Sub
	#tag EndEvent
	#tag Event
		Sub Change()
		  'Sock.AuthType = Me.ListIndex
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
		        Case HTTP.BaseServer.Log_Debug
		          If Severity < squelch Then Return
		          Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "Debug")
		          Listbox1.RowTag(Listbox1.LastIndex) = &cFFFF0099
		          Listbox1.RowPicture(Listbox1.LastIndex) = debugIcon
		        Case HTTP.BaseServer.Log_Socket
		          If Severity < squelch Then Return
		          Listbox1.AddRow(lines(i), now.ShortDate + " " + Now.LongTime, "Socket")
		          Listbox1.RowTag(Listbox1.LastIndex) = &cC0C0C099
		          Listbox1.RowPicture(Listbox1.LastIndex) = socketIcon
		        Case HTTP.BaseServer.Log_Trace
		          If Severity < squelch Then Return
		          Listbox1.AddRow(lines(i)), now.ShortDate + " " + Now.LongTime, "Trace"
		          Listbox1.RowTag(Listbox1.LastIndex) = &c80808099
		          Listbox1.RowPicture(Listbox1.LastIndex) = traceIcon
		        Else
		          Listbox1.AddRow(lines(i)), now.ShortDate + " " + Now.LongTime, "Unspecified"
		          Listbox1.RowTag(Listbox1.LastIndex) = &cFFFFFF99
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
		Function Authenticate(ClientRequest As HTTPParse.Request) As Boolean
		  Return Username.Text  = ClientRequest.AuthUsername And Password.Text = ClientRequest.AuthPassword 'And realmtext.Text = ClientRequest.AuthRealm
		End Function
	#tag EndEvent
	#tag Event
		Sub Log(Message As String, Severity As Integer)
		  Messages.Insert(0, Message:Severity)
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function TamperResponse(ByRef Response As HTTPParse.Response) As Boolean
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
