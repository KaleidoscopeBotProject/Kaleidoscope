#tag Class
Protected Class PacketParseThread
Inherits Thread
	#tag Event
		Sub Run()
		  
		  Dim pktLen As UInt16
		  
		  If Me.client = Nil Then Return
		  If Me.client.packetParser <> Me Then Return
		  If Me.client.state = Nil Then Return
		  
		  If Me.client.state.bnlsReadBuffer <> Nil Then
		    While Me.client.state.bnlsReadBuffer.Size >= 3
		      
		      pktLen = Me.client.state.bnlsReadBuffer.UInt16Value(0)
		      
		      If pktLen > Me.client.state.bnlsReadBuffer.Size Then Exit While
		      
		      If App.logPackets Then
		        stderr.WriteLine("BNLS: Received packet id 0x" + Right("0" + Hex(Me.client.state.bnlsReadBuffer.UInt8Value(2)), 2))
		      End If
		      
		      If Packets.ReceiveBNLS(Me.client, Me.client.state.bnlsReadBuffer.StringValue(0, pktLen)) = False Then
		        stderr.WriteLine("BNLS: Packet corruption during parsing, truncating buffer...")
		        Me.client.state.bnlsReadBuffer = Nil
		        Exit While
		      End If
		      
		      Me.client.state.bnlsReadBuffer = MidB(Me.client.state.bnlsReadBuffer, pktLen + 1)
		      
		    Wend
		  End If
		  
		  If Me.client.state.bnetReadBuffer <> Nil Then
		    While Me.client.state.bnetReadBuffer.Size >= 4
		      
		      If Me.client.state.bnetReadBuffer.UInt8Value(0) <> &HFF Then
		        stderr.WriteLine("BNET: Packet corruption at signature byte, truncating buffer...")
		        Me.client.state.bnetReadBuffer = Nil
		        Exit While
		      End If
		      
		      pktLen = Me.client.state.bnetReadBuffer.UInt16Value(2)
		      
		      If pktLen > Me.client.state.bnetReadBuffer.Size Then Exit While
		      
		      If App.logPackets Then
		        stderr.WriteLine("BNET: Received packet id 0x" + Right("0" + Hex(Me.client.state.bnetReadBuffer.UInt8Value(1)), 2))
		      End If
		      
		      If Packets.ReceiveBNET(Me.client, Me.client.state.bnetReadBuffer.StringValue(0, pktLen)) = False Then
		        stderr.WriteLine("BNET: Packet corruption during parsing, truncating buffer...")
		        Me.client.state.bnetReadBuffer = Nil
		        Exit While
		      End If
		      
		      Me.client.state.bnetReadBuffer = MidB(Me.client.state.bnetReadBuffer, pktLen + 1)
		      
		    Wend
		  End If
		  
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		client As BNETClient
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
