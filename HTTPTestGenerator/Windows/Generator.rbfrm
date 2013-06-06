#tag Window
Begin Window Generator
   BackColor       =   "&cFFFFFF00"
   Backdrop        =   0
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
   MenuBar         =   0
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
      Bold            =   False
      Caption         =   "Response"
      Enabled         =   True
      Height          =   587
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   618
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   9
      Underline       =   False
      Visible         =   True
      Width           =   579
      Begin MessageView MessageView1
         AcceptFocus     =   False
         AcceptTabs      =   True
         AutoDeactivate  =   True
         BackColor       =   "&cFFFFFF00"
         Backdrop        =   0
         Enabled         =   True
         EraseBackground =   True
         HasBackColor    =   False
         Height          =   384
         HelpTag         =   ""
         InitialParent   =   "GroupBox3"
         Left            =   622
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         PreviewPic      =   0
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   204
         UseFocusRing    =   False
         Visible         =   True
         Width           =   569
      End
      Begin BevelButton CookiesButton
         AcceptFocus     =   False
         AutoDeactivate  =   True
         BackColor       =   "&c00000000"
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
         Icon            =   1965037567
         IconAlign       =   1
         IconDX          =   0
         IconDY          =   0
         Index           =   -2147483648
         InitialParent   =   "GroupBox3"
         Italic          =   False
         Left            =   631
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MenuValue       =   0
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         TextColor       =   "&c00000000"
         TextFont        =   "System"
         TextSize        =   0.0
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
         Italic          =   False
         Left            =   1034
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   0
         TabPanelIndex   =   0
         Text            =   ""
         TextAlign       =   0
         TextColor       =   "&c0000FF00"
         TextFont        =   "System"
         TextSize        =   8.0
         TextUnit        =   0
         Top             =   45
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   157
      End
      Begin BevelButton ResponseHeaderView
         AcceptFocus     =   False
         AutoDeactivate  =   True
         BackColor       =   "&c00000000"
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
         Icon            =   849696767
         IconAlign       =   1
         IconDX          =   0
         IconDY          =   0
         Index           =   -2147483648
         InitialParent   =   "GroupBox3"
         Italic          =   False
         Left            =   1169
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MenuValue       =   0
         Scope           =   0
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         TextColor       =   "&c00000000"
         TextFont        =   "System"
         TextSize        =   0.0
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
      Bold            =   False
      Caption         =   "Log"
      Enabled         =   True
      Height          =   285
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   13
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   311
      Underline       =   False
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
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   "&c80808000"
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   254
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   True
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollbarVertical=   True
      Styled          =   True
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   "&cFFFFFF00"
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   331
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
   End
   Begin Label Label2
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
      Left            =   631
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      Text            =   "Status Code:"
      TextAlign       =   2
      TextColor       =   "&c00000000"
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   29
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   87
   End
   Begin Label Label3
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
      Left            =   631
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      Text            =   "Status Message:"
      TextAlign       =   2
      TextColor       =   "&c00000000"
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   52
      Transparent     =   False
      Underline       =   False
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
      Italic          =   False
      Left            =   724
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      Text            =   ""
      TextAlign       =   0
      TextColor       =   "&c0000FF00"
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   52
      Transparent     =   False
      Underline       =   False
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
      Italic          =   False
      Left            =   724
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      Text            =   ""
      TextAlign       =   0
      TextColor       =   "&cFF000000"
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   29
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   186
   End
   Begin Label Label5
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
      Left            =   928
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   5
      TabPanelIndex   =   0
      Text            =   "Remote IP:"
      TextAlign       =   2
      TextColor       =   "&c00000000"
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   29
      Transparent     =   False
      Underline       =   False
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
      Italic          =   False
      Left            =   1040
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      Text            =   ""
      TextAlign       =   0
      TextColor       =   "&c0000FF00"
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   29
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   151
   End
   Begin GroupBox GroupBox1
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Request"
      Enabled         =   True
      Height          =   297
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   13
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   9
      Underline       =   False
      Visible         =   True
      Width           =   580
      Begin ComboBox ProtocolVer
         AutoComplete    =   False
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         InitialValue    =   "HTTP/1.1\r\nHTTP/1.0"
         Italic          =   False
         Left            =   480
         ListIndex       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   27
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   100
      End
      Begin HintTextField URL
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
         HasText         =   False
         Height          =   22
         HelpTag         =   ""
         HintText        =   "Request URL"
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   125
         LimitText       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Mask            =   ""
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   "&c00000000"
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   27
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   350
      End
      Begin Listbox RequestHeaders
         AutoDeactivate  =   True
         AutoHideScrollbars=   True
         Bold            =   False
         Border          =   True
         ColumnCount     =   3
         ColumnsResizable=   True
         ColumnWidths    =   "45%, 45%, *"
         DataField       =   ""
         DataSource      =   ""
         DefaultRowHeight=   -1
         Enabled         =   True
         EnableDrag      =   False
         EnableDragReorder=   False
         GridLinesHorizontal=   0
         GridLinesVertical=   0
         HasHeading      =   True
         HeadingIndex    =   -1
         Height          =   100
         HelpTag         =   ""
         Hierarchical    =   False
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         InitialValue    =   "Header Name	Header Value	Add"
         Italic          =   False
         Left            =   20
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         RequiresSelection=   False
         Scope           =   0
         ScrollbarHorizontal=   False
         ScrollBarVertical=   True
         SelectionType   =   1
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   61
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   560
         _ScrollWidth    =   -1
      End
      Begin TextArea MessageBody
         AcceptTabs      =   False
         Alignment       =   0
         AutoDeactivate  =   True
         AutomaticallyCheckSpelling=   True
         BackColor       =   "&cFFFFFF00"
         Bold            =   False
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
         Italic          =   False
         Left            =   20
         LimitText       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Mask            =   ""
         Multiline       =   True
         ReadOnly        =   False
         Scope           =   0
         ScrollbarHorizontal=   False
         ScrollbarVertical=   True
         Styled          =   True
         TabIndex        =   6
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextColor       =   "&c00000000"
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   210
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   560
      End
      Begin PushButton Sender
         AutoDeactivate  =   True
         Bold            =   False
         ButtonStyle     =   0
         Cancel          =   False
         Caption         =   "Send"
         Default         =   False
         Enabled         =   True
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   260
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   7
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   277
         Underline       =   False
         Visible         =   True
         Width           =   80
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
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   34
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   7
         TabPanelIndex   =   0
         Text            =   "Message Body:"
         TextAlign       =   0
         TextColor       =   "&c00000000"
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   189
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   263
      End
      Begin ComboBox RequestMethod
         AutoComplete    =   True
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         InitialValue    =   "GET\r\nHEAD\r\nPOST\r\nTRACE\r\nDELETE\r\nPUT\r\nOPTIONS"
         Italic          =   False
         Left            =   20
         ListIndex       =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   27
         Underline       =   False
         UseFocusRing    =   True
         Visible         =   True
         Width           =   100
      End
      Begin BevelButton EditCookies
         AcceptFocus     =   False
         AutoDeactivate  =   True
         BackColor       =   "&c00000000"
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
         Icon            =   1965037567
         IconAlign       =   1
         IconDX          =   0
         IconDY          =   0
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   20
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MenuValue       =   0
         Scope           =   0
         TabIndex        =   10
         TabPanelIndex   =   0
         TabStop         =   True
         TextColor       =   "&c00000000"
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   162
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   22
      End
      Begin PushButton PushButton3
         AutoDeactivate  =   True
         Bold            =   False
         ButtonStyle     =   0
         Cancel          =   False
         Caption         =   "HTTP Form"
         Default         =   False
         Enabled         =   True
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   480
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   12
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   162
         Underline       =   False
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
      Bold            =   False
      Border          =   True
      ColumnCount     =   2
      ColumnsResizable=   True
      ColumnWidths    =   ""
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   100
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Header Name	Header Value"
      Italic          =   False
      Left            =   631
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      RequiresSelection=   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   77
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
      _ScrollWidth    =   -1
   End
   Begin CheckBox gziprequest
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Request GZip"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   480
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      State           =   1
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   -53
      Underline       =   False
      Value           =   True
      Visible         =   True
      Width           =   126
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h0
		Sub Generate()
		  mTheURL = Nil
		  Me.Request = New HTTP.Request()
		  Me.Request.Method = HTTPMethod(Me.RequestMethod.Text)
		  If Me.Request.Method = HTTP.RequestMethod.InvalidMethod Then Me.Request.MethodName = Me.RequestMethod.Text
		  Me.Request.Path = theURL
		  If Me.Request.path.ServerPath = "" Then Me.Request.path.ServerPath = "/"
		  Me.Request.ProtocolVersion = CDbl(NthField(ProtocolVer.Text, "/", 2))
		  For i As Integer = 0 To RequestHeaders.ListCount - 1
		    Me.Request.SetHeader(RequestHeaders.Cell(i, 0), RequestHeaders.Cell(i, 1))
		  Next
		  
		  If Not Me.Request.HasHeader("Host") And Me.Request.ProtocolVersion >= 1.1 Then
		    Me.Request.SetHeader("Host", theURL.FQDN)
		  End If
		  
		  If Not Me.Request.HasHeader("Connection") And Me.Request.ProtocolVersion >= 1.1 Then
		    Me.Request.SetHeader("Connection", "close")
		  End If
		  
		  If Me.Request.Headers.AcceptableTypes.Ubound <= -1 Then
		    Me.Request.SetHeader("Accept", "*/*")
		  End If
		  
		  Me.Request.MessageBody = MessageBody.Text
		  
		  
		  'If gziprequest.Value Then
		  'Me.Request.SetHeader("Accept-Encoding", "gzip")
		  'End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Update(Raw As String)
		  Response = New HTTP.Response(Raw)
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
		  CodeName.Text = HTTP.HTTPCodeToMessage(Response.StatusCode)
		  For i As Integer = 0 To Response.Headers.Count - 1
		    Dim n, v As String
		    n = Response.Headers.Name(i)
		    v = Response.Headers.Value(n)
		    
		    ResponseHeaders.AddRow(n, v)
		  Next
		  CookiesButton.Visible = Response.Headers.CookieCount > 0
		  CookiesButton.Invalidate(True)
		  CookiesButton.HelpTag = Str(Response.Headers.CookieCount) + " cookies"
		  ResponseHeaderView.Enabled = True
		  
		  If Sock.IsConnected Then
		    IPAddress1.Text = "Open"
		    IPAddress.TextColor = &c00804000
		  Else
		    IPAddress1.Text = "Closed by server"
		    IPAddress1.TextColor = &c80808000
		    IPAddress.TextColor = &c80808000
		  End If
		  '#If HTTP.GZIPAvailable Then
		  'If Response.GetHeader("Content-Encoding") = "gzip" Then
		  'Me.Response.MessageBody = GZip.Uncompress(Me.Response.MessageBody, Me.Response.MessageBody.LenB^2)
		  'End If
		  '#endif
		  MessageView1.Response = Me.Response
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mTheURL As HTTP.URI
	#tag EndProperty

	#tag Property, Flags = &h0
		Output As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As HTTP.Request
	#tag EndProperty

	#tag Property, Flags = &h0
		Response As HTTP.Response
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mTheURL = Nil Then
			    mTheURL = New HTTP.URI(URL.Text)
			  End If
			  return mTheURL
			End Get
		#tag EndGetter
		TheURL As HTTP.URI
	#tag EndComputedProperty


#tag EndWindowCode

#tag Events CookiesButton
	#tag Event
		Sub Action()
		  Dim allcookies() As Cookie
		  For i As Integer = 0 To Response.Headers.CookieCount - 1
		    allcookies.Append(Response.Headers.Cookie(i))
		  Next
		  CookieViewer.ShowCookies(AllCookies)
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
		  If column <> 2 Then
		    Me.EditCell(row, column)
		  Else
		    If MsgBox("Remove this header?", 52, "Confirm removal") = 6 Then
		      Me.RemoveRow(row)
		    End If
		  End If
		  
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Function CellTextPaint(g As Graphics, row As Integer, column As Integer, x as Integer, y as Integer) As Boolean
		  #pragma Unused row
		  #pragma Unused X
		  If Column = 2 Then
		    g.ForeColor = &c80808000
		    g.Underline = True
		    Dim strWidth As Double = g.StringWidth("Remove")
		    g.DrawString("Remove", g.Width - (strWidth + 5), Y)
		  End If
		End Function
	#tag EndEvent
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  Dim a, b As Integer
		  a = Me.RowFromXY(X, Y)
		  b = Me.ColumnFromXY(X, Y)
		  
		  If (a > Me.ListCount - 1 And b = 2) Or (Me.ListCount = 0 And x >= 0.9 * Me.Width) Then
		    Dim p As Pair = HeaderEdit.GetHeader()
		    If p <> Nil Then
		      If p.Right IsA Date Then
		        RequestHeaders.AddRow(p.Left, HTTPDate(p.Right.DateValue), "")
		        RequestHeaders.CellType(RequestHeaders.LastIndex, 0) = Listbox.TypeEditable
		        RequestHeaders.EditCell(RequestHeaders.LastIndex, 0)
		      Else
		        RequestHeaders.AddRow(p.Left, p.Right, "")
		        RequestHeaders.CellType(RequestHeaders.LastIndex, 0) = Listbox.TypeEditable
		        RequestHeaders.EditCell(RequestHeaders.LastIndex, 0)
		      End If
		      Return True
		    End If
		    
		  End If
		End Function
	#tag EndEvent
	#tag Event
		Function HeaderPressed(column as Integer) As Boolean
		  If column = 2 Then
		    Dim p As Pair = HeaderEdit.GetHeader()
		    If p <> Nil Then
		      If p.Right IsA Date Then
		        RequestHeaders.AddRow(p.Left, HTTPDate(p.Right.DateValue), "")
		        RequestHeaders.CellType(RequestHeaders.LastIndex, 0) = Listbox.TypeEditable
		        RequestHeaders.EditCell(RequestHeaders.LastIndex, 0)
		      Else
		        RequestHeaders.AddRow(p.Left, p.Right, "")
		        RequestHeaders.CellType(RequestHeaders.LastIndex, 0) = Listbox.TypeEditable
		        RequestHeaders.EditCell(RequestHeaders.LastIndex, 0)
		      End If
		    End If
		    Return True
		  End If
		End Function
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
		  Dim c As Cookie
		  Dim editindex As Integer = -1
		  
		  If RequestHeaders.ListIndex > -1 And RequestHeaders.Cell(RequestHeaders.ListIndex, 0) = "Cookie" Then
		    Dim n, v As String
		    n = NthField(RequestHeaders.Cell(RequestHeaders.ListIndex, 1), "=", 1)
		    v = NthField(RequestHeaders.Cell(RequestHeaders.ListIndex, 1), "=", 2)
		    c = New Cookie(n, v)
		    editindex = RequestHeaders.ListIndex
		  End If
		  c = CookieEdit.GetCookie(c)
		  If c <> Nil Then
		    If editindex > -1 Then
		      RequestHeaders.Cell(editindex, 1) = c.Name + "=" + c.Value
		    Else
		      RequestHeaders.AddRow("Cookie", c.Name + "=" + c.Value, "")
		    End If
		  End If
		  Me.Invalidate
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
		    
		    RequestHeaders.AddRow("Content-Type", "application/x-www-form-urlencoded", "")
		    RequestHeaders.AddRow("Content-Length", Str(LenB(MessageBody.Text)), "")
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
