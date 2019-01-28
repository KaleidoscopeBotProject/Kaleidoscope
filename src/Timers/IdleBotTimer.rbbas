#tag Class
Protected Class IdleBotTimer
Inherits Timer
	#tag Event
		Sub Action()
		  
		  If Me.client = Nil Then
		    Me.Mode = Me.ModeOff
		    Return
		  End If
		  
		  Dim baseInterval As UInt64 = Me.client.config.idleBaseInterval
		  Dim delayInterval As UInt64 = Me.client.config.idleDelayInterval
		  
		  If baseInterval < 1 Then baseInterval = 1
		  
		  Me.Period = baseInterval + Floor( Rnd() * delayInterval )
		  
		  Battlenet.IdleBot( Me.client )
		  
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		client As BNETClient
	#tag EndProperty


End Class
#tag EndClass
