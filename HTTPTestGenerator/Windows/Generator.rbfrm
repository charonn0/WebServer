#tag Window
Begin Window Generator
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   605
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   2
   Resizeable      =   False
   Title           =   "HTTP Request Generator"
   Visible         =   True
   Width           =   1210
   Begin GroupBox GroupBox3
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Response"
      Enabled         =   True
      Height          =   587
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   618
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   9
      Underline       =   ""
      Visible         =   True
      Width           =   579
      Begin MessageView MessageView1
         AcceptFocus     =   ""
         AcceptTabs      =   True
         AutoDeactivate  =   True
         BackColor       =   16777215
         Backdrop        =   ""
         Enabled         =   True
         EraseBackground =   True
         HasBackColor    =   False
         Height          =   384
         HelpTag         =   ""
         InitialParent   =   "GroupBox3"
         Left            =   622
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   204
         UseFocusRing    =   ""
         Visible         =   True
         Width           =   569
      End
      Begin BevelButton CookiesButton
         AcceptFocus     =   False
         AutoDeactivate  =   True
         BackColor       =   0
         Bevel           =   4
         Bold            =   False
         ButtonType      =   0
         Caption         =   ""
         CaptionAlign    =   3
         CaptionDelta    =   0
         CaptionPlacement=   1
         Enabled         =   True
         HasBackColor    =   False
         HasMenu         =   0
         Height          =   22
         HelpTag         =   ""
         Icon            =   1167294463
         IconAlign       =   1
         IconDX          =   0
         IconDY          =   0
         Index           =   -2147483648
         InitialParent   =   "GroupBox3"
         Italic          =   False
         Left            =   631
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         MenuValue       =   0
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         TextColor       =   0
         TextFont        =   "System"
         TextSize        =   ""
         TextUnit        =   0
         Top             =   177
         Underline       =   False
         Value           =   False
         Visible         =   False
         Width           =   22
      End
      Begin Label IPAddress1
         AutoDeactivate  =   True
         Bold            =   True
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox3"
         Italic          =   ""
         Left            =   1034
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Multiline       =   ""
         Scope           =   0
         Selectable      =   False
         TabIndex        =   0
         TabPanelIndex   =   0
         Text            =   ""
         TextAlign       =   0
         TextColor       =   255
         TextFont        =   "System"
         TextSize        =   8
         TextUnit        =   0
         Top             =   45
         Transparent     =   True
         Underline       =   ""
         Visible         =   True
         Width           =   157
      End
      Begin BevelButton ResponseHeaderView
         AcceptFocus     =   False
         AutoDeactivate  =   True
         BackColor       =   0
         Bevel           =   4
         Bold            =   False
         ButtonType      =   0
         Caption         =   ""
         CaptionAlign    =   3
         CaptionDelta    =   0
         CaptionPlacement=   1
         Enabled         =   False
         HasBackColor    =   False
         HasMenu         =   0
         Height          =   22
         HelpTag         =   "Expanded Header View"
         Icon            =   86560767
         IconAlign       =   1
         IconDX          =   0
         IconDY          =   0
         Index           =   -2147483648
         InitialParent   =   "GroupBox3"
         Italic          =   False
         Left            =   1169
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         MenuValue       =   0
         Scope           =   0
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         TextColor       =   0
         TextFont        =   "System"
         TextSize        =   ""
         TextUnit        =   0
         Top             =   177
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   22
      End
   End
   Begin GroupBox GroupBox2
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Log"
      Enabled         =   True
      Height          =   285
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   13
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   311
      Underline       =   ""
      Visible         =   True
      Width           =   580
   End
   Begin TCPSocket Sock
      Address         =   ""
      Height          =   32
      Index           =   -2147483648
      Left            =   501
      LockedInPosition=   False
      Port            =   0
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   -1
      Width           =   32
   End
   Begin TextArea OutputLog
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   8421504
      Bold            =   ""
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   254
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   ""
      Left            =   20
      LimitText       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   True
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollbarVertical=   True
      Styled          =   True
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   16777215
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   331
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
   End
   Begin Label Label2
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
      Left            =   631
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      Text            =   "Status Code:"
      TextAlign       =   2
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   29
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   87
   End
   Begin Label Label3
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
      Left            =   631
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      Text            =   "Status Message:"
      TextAlign       =   2
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   52
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   87
   End
   Begin Label CodeName
      AutoDeactivate  =   True
      Bold            =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   724
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      Text            =   ""
      TextAlign       =   0
      TextColor       =   255
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   52
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   231
   End
   Begin Label Code
      AutoDeactivate  =   True
      Bold            =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   724
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      Text            =   ""
      TextAlign       =   0
      TextColor       =   16711680
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   29
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   186
   End
   Begin Label Label5
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
      Left            =   928
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   5
      TabPanelIndex   =   0
      Text            =   "Remote IP:"
      TextAlign       =   2
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   29
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   100
   End
   Begin Label IPAddress
      AutoDeactivate  =   True
      Bold            =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   1040
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      Text            =   ""
      TextAlign       =   0
      TextColor       =   255
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   29
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   151
   End
   Begin GroupBox GroupBox1
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Request"
      Enabled         =   True
      Height          =   297
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   13
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   9
      Underline       =   ""
      Visible         =   True
      Width           =   580
      Begin ComboBox ProtocolVer
         AutoComplete    =   False
         AutoDeactivate  =   True
         Bold            =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         InitialValue    =   "HTTP/1.1\r\nHTTP/1.0"
         Italic          =   ""
         Left            =   480
         ListIndex       =   0
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   27
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   100
      End
      Begin HintTextField URL
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
         HasText         =   ""
         Height          =   22
         HelpTag         =   ""
         HintText        =   "Request URL"
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   125
         LimitText       =   0
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Mask            =   ""
         Password        =   ""
         ReadOnly        =   ""
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   0
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   27
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   350
      End
      Begin Listbox RequestHeaders
         AutoDeactivate  =   True
         AutoHideScrollbars=   True
         Bold            =   ""
         Border          =   True
         ColumnCount     =   2
         ColumnsResizable=   True
         ColumnWidths    =   ""
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
         Height          =   100
         HelpTag         =   ""
         Hierarchical    =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         InitialValue    =   "Header Name	Header Value"
         Italic          =   ""
         Left            =   20
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         RequiresSelection=   ""
         Scope           =   0
         ScrollbarHorizontal=   ""
         ScrollBarVertical=   True
         SelectionType   =   0
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   61
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   560
         _ScrollWidth    =   -1
      End
      Begin PushButton PushButton1
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "+"
         Default         =   ""
         Enabled         =   True
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   20
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   4
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   161
         Underline       =   ""
         Visible         =   True
         Width           =   20
      End
      Begin PushButton PushButton2
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "-"
         Default         =   ""
         Enabled         =   True
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   41
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   5
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   161
         Underline       =   ""
         Visible         =   True
         Width           =   20
      End
      Begin TextArea MessageBody
         AcceptTabs      =   ""
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   True
         BackColor       =   16777215
         Bold            =   ""
         Border          =   True
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Format          =   ""
         Height          =   58
         HelpTag         =   ""
         HideSelection   =   True
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   20
         LimitText       =   0
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Mask            =   ""
         Multiline       =   True
         ReadOnly        =   ""
         Scope           =   0
         ScrollbarHorizontal=   ""
         ScrollbarVertical=   True
         Styled          =   True
         TabIndex        =   6
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   0
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   210
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   560
      End
      Begin PushButton Sender
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "Send"
         Default         =   ""
         Enabled         =   True
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   260
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   7
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   277
         Underline       =   ""
         Visible         =   True
         Width           =   80
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
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   34
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Multiline       =   ""
         Scope           =   0
         Selectable      =   False
         TabIndex        =   7
         TabPanelIndex   =   0
         Text            =   "Message Body:"
         TextAlign       =   0
         TextColor       =   0
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   189
         Transparent     =   False
         Underline       =   ""
         Visible         =   True
         Width           =   263
      End
      Begin CheckBox AutoHost
         AutoDeactivate  =   True
         Bold            =   ""
         Caption         =   "Auto Host Header"
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   454
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         State           =   1
         TabIndex        =   9
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   162
         Underline       =   ""
         Value           =   True
         Visible         =   True
         Width           =   126
      End
      Begin ComboBox RequestMethod
         AutoComplete    =   True
         AutoDeactivate  =   True
         Bold            =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         InitialValue    =   "GET\r\nHEAD\r\nPOST\r\nTRACE\r\nDELETE\r\nPUT\r\nOPTIONS"
         Italic          =   ""
         Left            =   20
         ListIndex       =   0
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   27
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   100
      End
      Begin BevelButton EditCookies
         AcceptFocus     =   False
         AutoDeactivate  =   True
         BackColor       =   0
         Bevel           =   4
         Bold            =   False
         ButtonType      =   0
         Caption         =   ""
         CaptionAlign    =   3
         CaptionDelta    =   0
         CaptionPlacement=   1
         Enabled         =   True
         HasBackColor    =   False
         HasMenu         =   0
         Height          =   22
         HelpTag         =   ""
         Icon            =   1167294463
         IconAlign       =   1
         IconDX          =   0
         IconDY          =   0
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   65
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         MenuValue       =   0
         Scope           =   0
         TabIndex        =   10
         TabPanelIndex   =   0
         TabStop         =   True
         TextColor       =   0
         TextFont        =   "System"
         TextSize        =   ""
         TextUnit        =   0
         Top             =   161
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   22
      End
      Begin HintTextField UAString
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
         HasText         =   ""
         Height          =   22
         HelpTag         =   ""
         HintText        =   "User-Agent String"
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   224
         LimitText       =   0
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Mask            =   ""
         Password        =   ""
         ReadOnly        =   ""
         Scope           =   0
         TabIndex        =   11
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   0
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   161
         Underline       =   ""
         UseFocusRing    =   True
         Visible         =   True
         Width           =   218
      End
      Begin PushButton PushButton3
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "HTTP Form"
         Default         =   ""
         Enabled         =   True
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   99
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   12
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   161
         Underline       =   ""
         Visible         =   True
         Width           =   97
      End
   End
   Begin Timer DataReceivedTimer
      Height          =   32
      Index           =   -2147483648
      Left            =   -3
      LockedInPosition=   False
      Mode            =   0
      Period          =   1000
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   597
      Width           =   32
   End
   Begin Listbox ResponseHeaders
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   ""
      Border          =   True
      ColumnCount     =   2
      ColumnsResizable=   True
      ColumnWidths    =   ""
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
      Height          =   100
      HelpTag         =   ""
      Hierarchical    =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Header Name	Header Value"
      Italic          =   ""
      Left            =   631
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      RequiresSelection=   ""
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   77
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
      _ScrollWidth    =   -1
   End
   Begin CheckBox AutoUA
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Auto User-Agent"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   349
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      State           =   1
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   -53
      Underline       =   ""
      Value           =   True
      Visible         =   True
      Width           =   126
   End
   Begin CheckBox gziprequest
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Request GZip"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   480
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      State           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   -53
      Underline       =   ""
      Value           =   False
      Visible         =   True
      Width           =   126
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h0
		Sub Generate()
		  mTheURL = Nil
		  Me.Request = New HTTPRequest()
		  Me.Request.Method = HTTPMethod(Me.RequestMethod.Text)
		  If Me.Request.Method = HTTP.RequestMethod.InvalidMethod Then Me.Request.MethodName = Me.RequestMethod.Text
		  Me.Request.Path = Join(theURL.ServerFile, "/")
		  If Me.Request.path = "" Then Me.Request.path = "/"
		  Me.Request.ProtocolVersion = CDbl(NthField(ProtocolVer.Text, "/", 2))
		  Me.Request.Arguments = TheURL.Arguments
		  Dim heads As New InternetHeaders
		  For i As Integer = 0 To RequestHeaders.LastIndex
		    heads.AppendHeader(RequestHeaders.Cell(i, 0), RequestHeaders.Cell(i, 1))
		  Next
		  Me.Request.Headers = New HTTPHeaders(heads.Source)
		  
		  If AutoHost.Value Then
		    If Me.Request.Headers.HasHeader("Host") Then
		      Me.Request.Headers.SetHeader("Host", theURL.FQDN)
		    Else
		      Me.Request.Headers.AppendHeader("Host", theURL.FQDN)
		    End If
		  End If
		  Dim ua As String
		  If UAString.HasText Then
		    ua = UAString.Text
		  Else
		    ua = "BSHTTPGen\1.0"
		  End If
		  If Me.Request.Headers.HasHeader("User-Agent") Then
		    Me.Request.Headers.SetHeader("User-Agent", ua)
		  Else
		    Me.Request.Headers.AppendHeader("User-Agent", ua)
		  End If
		  
		  Me.Request.MessageBody = MessageBody.Text
		  
		  
		  If gziprequest.Value Then
		    Me.Request.Headers.SetHeader("Accept-Encoding", "gzip")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Update(Raw As String)
		  Response = New HTTPResponse(Raw, "", False)
		  'Dim response, h(), data As String
		  'response = NthField(Raw, CRLF, 1)
		  'Raw = Replace(Raw, response + CRLF, "")
		  'h = Split(NthField(Raw, CRLF + CRLF, 1), CRLF)
		  'data = NthField(Raw, CRLF + CRLF, 2)
		  
		  Code.Text = Str(Response.StatusCode)'NthField(response, " ", 2)
		  Select Case Response.StatusCode
		  Case 200
		    Code.TextColor = &c00808000
		    CodeName.TextColor = &c00808000
		  Case 301, 302, 304
		    Code.TextColor = &c00800000
		    CodeName.TextColor = &c00800000
		  Case 204, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 422, 426, 500, 501, 502, 503, 504, 505, 506, 509
		    Code.TextColor = &cFF000000
		    CodeName.TextColor = &cFF000000
		    
		  End Select
		  ResponseHeaders.DeleteAllRows
		  CodeName.Text = Response.StatusMessage
		  For i As Integer = 0 To Response.Headers.Count - 1
		    Dim n, v As String
		    n = Response.Headers.Name(i)
		    v = Response.Headers.Value(n)
		    
		    ResponseHeaders.AddRow(n, v)
		  Next
		  CookiesButton.Visible = UBound(Response.Headers.Cookies) > -1
		  CookiesButton.Invalidate(True)
		  CookiesButton.HelpTag = Str(UBound(Response.Headers.Cookies) + 1) + " cookies"
		  ResponseHeaderView.Enabled = True
		  
		  If Sock.IsConnected Then
		    IPAddress1.Text = "Open"
		    IPAddress.TextColor = &c00804000
		  Else
		    IPAddress1.Text = "Closed by server"
		    IPAddress1.TextColor = &c80808000
		    IPAddress.TextColor = &c80808000
		  End If
		  
		  MessageView1.Response = Me.Response
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mTheURL As URI
	#tag EndProperty

	#tag Property, Flags = &h0
		Output As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As HTTPRequest
	#tag EndProperty

	#tag Property, Flags = &h0
		Response As HTTPResponse
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mTheURL = Nil Then
			    mTheURL = New URI(URL.Text)
			  End If
			  return mTheURL
			End Get
		#tag EndGetter
		TheURL As URI
	#tag EndComputedProperty


#tag EndWindowCode

#tag Events CookiesButton
	#tag Event
		Sub Action()
		  CookieViewer.ShowCookies(Response.Headers.Cookies)
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  If Me.Enabled Then
		    Me.Icon = cookie_icon
		  Else
		    Me.Icon = cookie_icon_grey
		  End If
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  Me.Icon = cookie_icon_grey
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ResponseHeaderView
	#tag Event
		Sub Action()
		  HeaderViewer.ShowHeaders(Response.Headers)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Sock
	#tag Event
		Sub Connected()
		  Output = ""
		  IPAddress.Text = Me.RemoteAddress
		  IPAddress.TextColor = &c00804000
		  IPAddress1.Text = "Connected"
		  IPAddress.TextColor = &c00804000
		  
		  Me.Write(Request.ToString)
		  URL.AddItem(URL.Text)
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub DataAvailable()
		  IPAddress1.Text = "Receiving"
		  IPAddress.TextColor = &c00804000
		  Output = Output + Me.ReadAll
		  OutputLog.Text = "-----------Request-----------" + CRLF + Request.ToString + CRLF _
		  + "-----------Response-----------" + CRLF + OutPut + CRLF
		  
		  DataReceivedTimer.Mode = Timer.ModeSingle
		End Sub
	#tag EndEvent
	#tag Event
		Sub Error()
		  Select Case Me.LastErrorCode
		  Case 102
		    IPAddress1.Text = "Closed by server"
		    IPAddress1.TextColor = &c80808000
		    IPAddress.TextColor = &c80808000
		    
		  Case 103
		    IPAddress.Text = TheURL.FQDN
		    IPAddress1.Text = "Bad domain"
		    IPAddress1.TextColor = &cFF000000
		    IPAddress.TextColor = &cFF000000
		    ResponseHeaders.DeleteAllRows
		    MessageView1.Message.Text = ""
		    MessageView1.PagePanel1.Value = 3
		    Code.Text = ""
		    CodeName.Text = ""
		    
		  Else
		    IPAddress1.Text = "Socket error: " + Str(Me.LastErrorCode)
		    IPAddress1.TextColor = &cFF000000
		    IPAddress.TextColor = &cFF000000
		  End Select
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events RequestHeaders
	#tag Event
		Function CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  #pragma Unused x
		  #pragma Unused y
		  Me.EditCell(row, column)
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events PushButton1
	#tag Event
		Sub Action()
		  RequestHeaders.AddRow("New-Header-Name", "New-Header-Value", "")
		  RequestHeaders.CellType(RequestHeaders.LastIndex, 0) = Listbox.TypeEditable
		  RequestHeaders.EditCell(RequestHeaders.LastIndex, 0)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  If RequestHeaders.ListIndex > -1 Then
		    RequestHeaders.RemoveRow(RequestHeaders.ListIndex)
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Sender
	#tag Event
		Sub Action()
		  Output = ""
		  Generate()
		  Sock.Close
		  Sock.Address = theURL.FQDN
		  If theURL.Port <> 0 Then
		    Sock.Port = theURL.Port
		  Else
		    Sock.Port = 80
		  End If
		  
		  Sock.Connect()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events EditCookies
	#tag Event
		Sub MouseEnter()
		  Me.Icon = cookie_icon
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  Me.Icon = cookie_icon_grey
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Action()
		  Dim c As HTTPCookie
		  Dim editindex As Integer = -1
		  If RequestHeaders.Cell(RequestHeaders.ListIndex, 0) = "Cookie" Then
		    c = New HTTPCookie(NthField(RequestHeaders.Cell(RequestHeaders.ListIndex, 1), ":", 1), NthField(RequestHeaders.Cell(RequestHeaders.ListIndex, 1), ":", 2))
		    editindex = RequestHeaders.ListIndex
		  End If
		  c = CookieEdit.GetCookie(c)
		  If c <> Nil Then
		    If editindex > -1 Then
		      RequestHeaders.Cell(editindex, 1) = c.Name + "=" + c.Value
		    Else
		      RequestHeaders.AddRow("Cookie", c.Name + "=" + c.Value, "HTTP Cookie")
		    End If
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton3
	#tag Event
		Sub Action()
		  Dim formgen As New FormGenerator
		  Dim data As Dictionary = formgen.SetFormData(DecodeFormData(MessageBody.Text))
		  If Data <> Nil Then
		    MessageBody.Text = EncodeFormData(data)
		    
		    For i As Integer = RequestHeaders.ListCount - 1 DownTo 0
		      If RequestHeaders.Cell(i, 0) = "Content-Type" Then
		        RequestHeaders.RemoveRow(i)
		      End If
		    Next
		    For i As Integer = RequestHeaders.ListCount - 1 DownTo 0
		      If RequestHeaders.Cell(i, 0) = "Content-Length" Then
		        RequestHeaders.RemoveRow(i)
		      End If
		    Next
		    
		    RequestHeaders.AddRow("Content-Type", "application/x-www-form-urlencoded")
		    RequestHeaders.AddRow("Content-Length", Str(LenB(MessageBody.Text)))
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events DataReceivedTimer
	#tag Event
		Sub Action()
		  Update(Output)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events gziprequest
	#tag Event
		Sub Open()
		  Me.Enabled = GZIPAvailable
		End Sub
	#tag EndEvent
#tag EndEvents
