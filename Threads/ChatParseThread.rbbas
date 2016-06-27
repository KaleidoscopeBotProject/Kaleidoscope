#tag Class
Protected Class ChatParseThread
Inherits Thread
	#tag Event
		Sub Run()
		  
		  Dim msg As ChatMessage
		  Dim acl As UserAccess
		  Dim res As ChatResponse
		  
		  Do Until UBound(Me.messages) < 0
		    
		    msg = Me.messages.Pop()
		    acl = Nil
		    res = Nil
		    
		    Select Case msg.eventId
		    Case Battlenet.EID_WHISPER, Battlenet.EID_TALK, Battlenet.EID_EMOTE
		      acl = Me.client.getAcl(msg.username)
		      res = BotCommand.handleCommand(Me.client, acl, msg)
		    End Select
		    
		    If res = Nil Then Continue Do
		    
		    Select Case res.type
		    Case res.TYPE_PACKET
		      Me.client.socBNET.Write(res.text)
		    Case res.TYPE_TALK
		      Me.client.socBNET.Write(Packets.CreateBNET_SID_CHATCOMMAND(res.text))
		    Case res.TYPE_EMOTE
		      Me.client.socBNET.Write(Packets.CreateBNET_SID_CHATCOMMAND("/me " + res.text))
		    Case res.TYPE_WHISPER
		      Me.client.socBNET.Write(Packets.CreateBNET_SID_CHATCOMMAND("/w " + msg.username + " " + res.text))
		    End Select
		    
		  Loop
		  
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		client As BNETClient
	#tag EndProperty

	#tag Property, Flags = &h0
		messages() As ChatMessage
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
