#tag Window
Begin Window FormGenerator
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   270
   ImplicitInstance=   False
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
   Placement       =   0
   Resizeable      =   False
   Title           =   "Edit HTTP Form"
   Visible         =   True
   Width           =   561
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
      InitialParent   =   ""
      Italic          =   ""
      Left            =   27
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   242
      Underline       =   ""
      Visible         =   True
      Width           =   20
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
      InitialParent   =   ""
      Italic          =   ""
      Left            =   6
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
      Top             =   242
      Underline       =   ""
      Visible         =   True
      Width           =   20
   End
   Begin PushButton PushButton3
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "OK"
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   283
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   244
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin PushButton PushButton4
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Cancel"
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   199
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
      Top             =   244
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin Listbox HTTPForm
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
      Height          =   232
      HelpTag         =   ""
      Hierarchical    =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Form Element	Value"
      Italic          =   ""
      Left            =   1
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
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   0
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
      _ScrollWidth    =   -1
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h0
		Function SetFormData(ExistingData As Dictionary) As Dictionary
		  Me.FormData = Nil
		  HTTPForm.DeleteAllRows
		  If ExistingData <> Nil Then
		    For Each key As String In ExistingData.Keys
		      HTTPForm.AddRow(key, ExistingData.Value(key))
		      HTTPForm.CellType(HTTPForm.LastIndex, 0) = Listbox.TypeEditable
		      HTTPForm.CellType(HTTPForm.LastIndex, 1) = Listbox.TypeEditable
		    Next
		  End If
		  
		  Self.ShowModal()
		  Return FormData
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private FormData As Dictionary
	#tag EndProperty


#tag EndWindowCode

#tag Events PushButton2
	#tag Event
		Sub Action()
		  If HTTPForm.ListIndex > -1 Then
		    HTTPForm.RemoveRow(HTTPForm.ListIndex)
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton1
	#tag Event
		Sub Action()
		  HTTPForm.AddRow("New-Form-Element", "New-Form-Value", "")
		  HTTPForm.CellType(HTTPForm.LastIndex, 0) = Listbox.TypeEditable
		  HTTPForm.EditCell(HTTPForm.LastIndex, 0)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton3
	#tag Event
		Sub Action()
		  FormData = New Dictionary
		  For i As Integer = 0 To HTTPForm.ListCount - 1
		    FormData.Value(HTTPForm.Cell(i, 0)) = HTTPForm.Cell(i, 1)
		  Next
		  
		  Self.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton4
	#tag Event
		Sub Action()
		  FormData = Nil
		  Self.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events HTTPForm
	#tag Event
		Function CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  #pragma Unused x
		  #pragma Unused y
		  Me.EditCell(row, column)
		End Function
	#tag EndEvent
#tag EndEvents
