#tag Class
Protected Class ChannelUser
	#tag Method, Flags = &h0
		Sub Constructor(username As String, metadata As String, ping As Int32, flags As UInt32)
		  
		  Me.username = username
		  Me.metadata = metadata
		  Me.ping     = ping
		  Me.flags    = flags
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		flags As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		metadata As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ping As Int32
	#tag EndProperty

	#tag Property, Flags = &h0
		username As String
	#tag EndProperty


End Class
#tag EndClass
