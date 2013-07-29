#tag Class
Protected Class ScriptDocument
Inherits HTTP.Response
	#tag Method, Flags = &h21
		Private Sub CompilerErrorHandler(Sender As RbScript, line as Integer, errorNumber as Integer, errorMsg as String)
		  #pragma Unused Sender
		  #pragma Unused errorMsg
		  'Return an HTTP 500 Internal Server Error page.
		  line = line + 1
		  StatusCode = 500
		  Dim data As String = ErrorPage(500, "<b>Script compiler error #" + Str(errorNumber) + " on line " + Str(line) + "</b>: " _
		  + ScriptErrorToString(errorNumber) + "<br /></blockquote>" + EndOfLine)
		  SetHeader("Content-Length") = Str(data.LenB)
		  MIMEType = New ContentType("text/html")
		  MessageBody = data
		  Expires = New Date(1999, 12, 31, 23, 59, 59)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(Source As String = HelloWorldSrc)
		  Me.ScriptRunner = New RbScript
		  ScriptRunner.Source = Source
		  AddHandler ScriptRunner.CompilerError, AddressOf Me.CompilerErrorHandler
		  AddHandler ScriptRunner.Input, AddressOf Me.InputHandler
		  AddHandler ScriptRunner.Print, AddressOf Me.PrintHandler
		  AddHandler ScriptRunner.RuntimeError, AddressOf Me.RuntimeErrorHandler
		  ScriptRunner.Context = Me
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function InputHandler(Sender As RbScript, Prompt As String) As String
		  #pragma Unused Sender
		  #pragma Unused Prompt
		  Return "Don't call Input!"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PrintHandler(Sender As RbScript, Msg As String)
		  #pragma Unused Sender
		  Me.MessageBody = Me.MessageBody + msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RuntimeErrorHandler(Sender As RbScript, line as Integer, error as RuntimeException)
		  #pragma Unused Sender
		  'Return an HTTP 500 Internal Server Error page.
		  Dim htmlstack, funcName As String
		  #If DebugBuild Then
		    Dim s() As String = Error.CleanStack
		    funcName = Introspection.GetType(Error).FullName
		    If UBound(s) <= -1 Then
		      htmlstack = "<br />(empty)<br />"
		    Else
		      htmlstack = Join(s, "<br />    ")
		    End If
		    htmlstack = "<b>Script runtime exception on line " + Str(line) + "</b>: " + funcName + "<br /><b>Error Number</b>: " + Str(Error.ErrorNumber) + "<br /><b>Message</b>: " _
		    + Error.Message + "<br /><b>Stack trace</b>:<blockquote>    " + htmlstack + "</blockquote>" + EndOfLine
		  #endif
		  StatusCode = 500
		  Dim data As String = ErrorPage(500, htmlstack)
		  SetHeader("Content-Length") = Str(data.LenB)
		  MIMEType = New ContentType("text/html")
		  MessageBody = data
		  Expires = New Date(1999, 12, 31, 23, 59, 59)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ScriptErrorToString(code as integer) As string
		  //RBScript error codes to messages.
		  
		  static errors as new Dictionary( _
		  1: "Syntax error", _
		  2: "Expected a different data type than the one specified.", _
		  3: "Select Case does not support that type of expression.", _
		  4: "The compiler is not implemented (obsolete).", _
		  5: "The parser's internal stack has overflowed.", _
		  6: "Too many parameters for this function.", _
		  7: "Not enough parameters for this function call.", _
		  8: "Wrong number of parameters for this function call.", _
		  9: "Parameters are incompatible with this function.", _
		  10: "Assignment of an incompatible data type.", _
		  11: "This method or property does not exist", _
		  12: "Undefined operator.", _
		  13: "Logic operations require Boolean operands.", _
		  14: "Array bounds must be integers.", _
		  15: "Can't call something that isn't a function.", _
		  16: "Can't get an element from something that isn’t an array.", _
		  17: "Not enough subscripts for this array’s dimensions.", _
		  18: "Too many subscripts for this array’s dimensions.", _
		  19: "Can't assign an entire array.", _
		  20: "Can't use an entire array in an expression.", _
		  21: "Parameters passed ByRef cannot be expressions.", _
		  22: "Identifier already exists.", _
		  23: "The backend code generator failed.", _
		  24: "Ambiguous call to overloaded method.", _
		  25: "Multiple inheritance is not allowed.", _
		  26: "Cannot create an instance of an interface.", _
		  27: "Cannot implement a class as though it were an interface.", _
		  28: "Cannot inherit from something that is not a class.", _
		  29: "This class does not fully implement the specified interface.", _
		  30: "Event handlers cannot live outside of a class.", _
		  31: "You must use the value returned by this function.", _
		  32: "Can’t use “Self” keyword outside of a class.", _
		  33: "Can’t use “Me” keyword outside of a class.", _
		  34: "This method does not return a value.", _
		  35: "An exception object required here.", _
		  36: "Obselete.", _
		  37: "Obselete.", _
		  38: "Obselete.", _
		  39: "Obselete.", _
		  40: "Destructors can’t have parameters.", _
		  41: "Can’t use “Super” keyword outside of a class.", _
		  42: "Can’t use “Super” keyword in a class that has no parent.", _
		  43: "This #else does not have a matching #if preceding it.", _
		  44: "This #endif does not have a matching #if preceding it.", _
		  45: "Only Boolean constants can be used with #if.", _
		  46: "Only Boolean constants can be used with #if.", _
		  47: "The Next variable does not match the loop's counter variable.", _
		  48: "The size of an array must be a constant or number.", _
		  49: "You can't pass an array to an external function.", _
		  50: "External functions cannot use objects as parameters.", _
		  51: "External functions cannot use ordinary strings as parameters. Use CString, _ PString, _ WString, _ or CFStringRef instead.", _
		  52: "This kind of array can not be sorted.", _
		  53: "This property is protected. It can only be used from within its class.", _
		  54: "This method is protected. It can only be called from within its class.", _
		  55: "This local variable or constant has the same name as a Declare in this method. You must resolve this conflict.", _
		  56: "This global variable has the same name as a global function. You must resolve this conflict.", _
		  57: "This property has the same name as a method. You must resolve this conflict.", _
		  58: "This property has the same name as an event. You must resolve this conflict.", _
		  59: "This global variable has the same name as a class. You must resolve this conflict.", _
		  60: "This global variable has the same name as a module. You must change one of them.", _
		  61: "This local variable or parameter has the same name as a constant. You must resolve this conflict.", _
		  62: "(%1) is reserved and can't be used as a variable or property name.", _
		  63: "There is no class with this name.", _
		  64: "The library name must be a string constant.", _
		  65: "This Declare Function statement is missing its return type.", _
		  66: "You can’t use the New operator with this class.", _
		  67: "This method doesn't return a value.", _
		  68: "End quote missing.", _
		  69: "A class cannot be its own superclass.", _
		  70: "Cannot assign a value to this property.", _
		  71: "Cannot get this property’s value.", _
		  72: "The If statement is missing its condition.", _
		  73: "The current function must return a value, _ but this Return statement does not specify any value.", _
		  74: "Parameter options (%1) and (%2) are incompatible.", _
		  75: "Parameter option (%1) was already specified.", _
		  76: "A parameter passed by reference cannot have a default value.", _
		  77: "A ParamArray cannot have a default value.", _
		  78: "An Assigns parameter cannot have a default value.", _
		  79: "An Extends parameter cannot have a default value.", _
		  80: "Only the first parameter may use the Extends option.", _
		  81: "Only the last parameter may use the Assigns option.", _
		  82: "An ordinary parameter cannot follow a ParamArray.", _
		  83: "Only one parameter may use the Assigns option.", _
		  84: "Only one parameter may use the ParamArray option.", _
		  85: "A ParamArray cannot have more than one dimension.", _
		  86: "The keyword “Then” is expected after this If statement’s condition.", _
		  87: "(obsolete)", _
		  88: "Constants must be defined with constant values.", _
		  89: "Illegal use of the Call keyword.", _
		  90: "No cases may follow the Else block.", _
		  91: "(%1) is not a legal property accessor type.", _
		  92: "This (%1) accessor must end with “End (%1)”, _ not “End (%2)”.", _
		  93: "Duplicate method definition.", _
		  94: "The library name for this declaration is blank.", _
		  95: "This If statement is missing an End If statement.", _
		  96: "This Select Case statement is missing an End Select statement.", _
		  97: "This For loop is missing its Next statement.", _
		  98: "This While loop is missing its Wend statement.", _
		  99: "This Try statement is missing an End Try statement.", _
		  100: "This Do loop is missing its Loop statement.", _
		  101: "Too few parentheses.", _
		  102: "Too many parentheses.", _
		  103: "The Continue statement only works inside a loop.", _
		  104: "There is no (%1) block to (%2) here.", _
		  105: "Shared methods cannot access instance properties.", _
		  106: "Shared methods cannot access instance methods.", _
		  107: "Shared computed property accessors cannot access instance properties.", _
		  108: "Shared computed property accessors cannot access instance methods.", _
		  109: "The Constructor of this class is protected, _ and can only be called from within this class.", _
		  110: "This String field needs to specify its length.", _
		  111: "Structures cannot contain (%1) fields.", _
		  112: "Structures cannot contain multidimensional arrays.", _
		  113: "Enumerated types can only contain integers.", _
		  114: "An Enumeration cannot be defined in terms of another enumeration.", _
		  115: "This is a constant; its value can’t be changed.", _
		  116: "A String field must be at least 1 byte long.", _
		  117: "The storage size specifier only applies to String fields.", _
		  118: "A Structure cannot contain itself.", _
		  119: "(%1) is a structure, _ not a class, _ and cannot be instantiated with New.", _
		  120: "(%1) is an enumeration, _ not a class, _ and cannot be instantiated with New.", _
		  121: "This type is private, _ and can only be used within its module.", _
		  122: "Class members cannot be global.", _
		  123: "Module members must be public or private; they cannot be protected.", _
		  124: "Members of inner modules cannot be global.", _
		  125: "A Dim statement creates only one new object at a time.", _
		  126: "A constant was expected here, _ but this is some other kind of expression.", _
		  127: "This module is private, _ and can only be used within its containing module.", _
		  128: "Duplicate property definition.", _
		  129: "This datatype cannot be used as an array element.", _
		  130: "Delegate parameters cannot be optional.", _
		  131: "Delegates cannot use Extends, _ Assigns, _ or ParamArray.", _
		  132: "The Declare statement is illegal in RBScript.", _
		  133: "It is not legal to dereference a Ptr value in an RBScript.", _
		  134: "Delegate creation from Ptr values is not allowed in RBScript.", _
		  135: "Delegate constant definition.", _
		  136: "Ambiguous interface method implementation.", _
		  137: "Illegal explicit interface method implementation. The class does not claim to implement this interface.", _
		  138: "The interface does not declare this method.", _
		  139: "This method contains a #If without a closing #endif statement.", _
		  140: "This interface contains a cyclical interface aggregation.", _
		  141: "The Extends modifier cannot be used on a class method.", _
		  142: "You cannot assign a non-value type to a value.", _
		  143: "Duplicate attribute name.", _
		  144: "Delegates cannot return structures.", _
		  145: "You cannot create a delegate from this identifier.", _
		  146: "You cannot use an Operator_Convert method to perform a convert-to operation on an interface.", _
		  147: "The ElseIf statement is missing its condition.", _
		  148: "This type cannot be used as an explicit constant type.", _
		  149: "Recursive constant declaration error.", _
		  150: "Custom error created using #error.", _
		  151: "This is not a local variable or parameter.", _
		  152: "The maximum units in last position parameter must be a constant.", _
		  153: "The maximum units in last position parameter is out of range.", _
		  154: "The StructureAlignment attribute’s value must be of the following: 1, _ 2, _ 4, _ 8, _ 16, _ 32, _ 64, _ or 128.", _
		  155: "Pair creation via the: operator is not allowed in RBScript.", _
		  156: "Introspection via the GetTypeInfo operator is not allowed in RBScript.", _
		  157: "The For statement is missing its condition.", _
		  158: "The While statement is missing its condition.", _
		  159: "Unsigned integer used in negative step loops can cause an infinite loop." )
		  
		  return errors.value( code )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  #pragma BreakOnExceptions Off
		  ScriptRunner.Run
		  #pragma BreakOnExceptions Default
		  Return Super.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(HeadersOnly As Boolean) As String
		  ScriptRunner.Run
		  Return Super.ToString(HeadersOnly)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private ScriptRunner As RbScript
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Source As String
	#tag EndProperty


	#tag Constant, Name = HelloWorldSrc, Type = String, Dynamic = False, Default = \"StatusCode \x3D 200\rPrint(\"<html><head><title>Test Page</title></head><body><p>Hello\x2C world!</p></body></html>\")\rSetHeader(\"Foo\") \x3D \"Bar\"\rSetCookie(\"ScriptCookie\") \x3D \"123456\"\rDim s() As String\rs(1) \x3D \"crash\"\r", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AuthPassword"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthRealm"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AuthUsername"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compressible"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="HTTP.Response"
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
			Name="MessageBody"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ProtocolVersion"
			Group="Behavior"
			Type="Single"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionID"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTPParse.HTTPMessage"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StatusCode"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="HTTP.Response"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StatusMessage"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="HTTP.Response"
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
	#tag EndViewBehavior
End Class
#tag EndClass
