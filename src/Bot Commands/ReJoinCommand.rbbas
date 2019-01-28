#tag Class
Protected Class ReJoinCommand
Inherits BotCommand
	#tag Event
		Function Action(client As BNETClient, message As ChatMessage, suggestedResponseType As Integer, args As String) As ChatResponse
		  
		  #pragma Unused suggestedResponseType
		  #pragma Unused args
		  
		  Dim channel As String
		  
		  If LenB( client.state.channel ) = 0 And LenB( client.state.lastChannel ) = 0 Then
		    Return New ChatResponse( suggestedResponseType, "Cannot rejoin channel, not in any channel and last channel is unknown." )
		  End If
		  
		  If LenB( client.state.channel ) = 0 Then
		    channel = client.state.lastChannel
		  Else
		    channel = client.state.channel
		  End If
		  
		  client.state.joinCommandState = New Pair( message.username, channel )
		  
		  Return New ChatResponse( ChatResponse.TYPE_PACKET, Packets.CreateBNET_SID_LEAVECHAT() + _
		  Packets.CreateBNET_SID_JOINCHANNEL( Packets.FLAG_NOCREATE, channel ))
		  
		End Function
	#tag EndEvent

	#tag Event
		Function Match(value As String, trigger As String) As Boolean
		  
		  #pragma Unused trigger
		  
		  Return (value = "rj" Or value = "rejoin")
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1000
		Sub Constructor()
		  
		  Super.Constructor(True)
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="aclAdmin"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="BotCommand"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
