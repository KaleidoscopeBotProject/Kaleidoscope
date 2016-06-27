#tag Class
Protected Class BattlenetException
Inherits KaleidoscopeException
	#tag Method, Flags = &h1000
		Sub Constructor(error As String, errno As Integer = 0, previous As RuntimeException = Nil)
		  
		  Super.Constructor(error, errno, previous)
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
