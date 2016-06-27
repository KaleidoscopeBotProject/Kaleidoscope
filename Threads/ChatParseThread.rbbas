#tag Class
Protected Class ChatParseThread
Inherits Thread
	#tag Event
		Sub Run()
		  
		  Dim msg As ChatMessage
		  
		  Do
		    msg = Me.messages.Pop()
		    Select Case msg.eventId
		      
		      // TODO: Implement chat event handling.
		      
		    End Select
		  Loop Until UBound(Me.messages) < 0
		  
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		client As BNETClient
	#tag EndProperty

	#tag Property, Flags = &h0
		messages() As ChatMessage
	#tag EndProperty


End Class
#tag EndClass
