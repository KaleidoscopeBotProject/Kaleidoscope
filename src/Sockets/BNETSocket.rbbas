#tag Class
Protected Class BNETSocket
Inherits TCPSocket
	#tag Event
		Sub Connected()
		  
		  stdout.WriteLine("BNET: Connected to " + Me.RemoteAddress + "!")
		  
		  If Me.client.state = Nil Then
		    Me.client.state = New BNETState(Me.client)
		  End If
		  
		  Me.client.state.connectedTime = Microseconds()
		  
		  Me.Write(ChrB(&H01))
		  
		  If Me.client.state.versionByte <> &H00 Then
		    
		    Me.client.socBNET.Write(Packets.CreateBNET_SID_AUTH_INFO(_
		    Me.client.state.platform, Me.client.state.product, _
		    Me.client.state.versionByte, _
		    0, Me.client.state.localIP, Me.client.state.timezoneBias, _
		    1033, 1033, "USA", "United States"_
		    ))
		    
		  End If
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataAvailable()
		  
		  If Me.client.state = Nil Then
		    // We were most likely disconnected already since its null.
		    Return
		  End If
		  
		  If Me.client.state.bnetReadBuffer = Nil Then
		    Me.client.state.bnetReadBuffer = Me.ReadAll()
		  Else
		    Me.client.state.bnetReadBuffer = Me.client.state.bnetReadBuffer + Me.ReadAll()
		  End If
		  
		  If Me.client.state.bnetReadBuffer.LittleEndian <> True Then
		    Me.client.state.bnetReadBuffer.LittleEndian = True
		  End If
		  
		  If Me.client.packetParser.State = Me.client.packetParser.NotRunning Then
		    Me.client.packetParser.Run()
		  End If
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Error()
		  
		  stdout.WriteLine("BNET: Socket error #" + Format(Me.LastErrorCode, "-#") + "!")
		  
		  Me.client.state = Nil
		  
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		client As BNETClient
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Address"
			Visible=true
			Group="Behavior"
			Type="String"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
