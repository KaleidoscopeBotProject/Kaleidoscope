#tag Class
Protected Class ChatResponse
	#tag Method, Flags = &h0
		Sub Constructor(type As Integer, text As String)
		  
		  Me.type = type
		  Me.text = text
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		text As String
	#tag EndProperty

	#tag Property, Flags = &h0
		type As Integer
	#tag EndProperty


	#tag Constant, Name = TYPE_EMOTE, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TYPE_PACKET, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TYPE_TALK, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TYPE_WHISPER, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant


End Class
#tag EndClass
