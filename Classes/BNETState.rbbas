#tag Class
Protected Class BNETState
	#tag Method, Flags = &h0
		Sub Constructor(client As BNETClient)
		  
		  Me.accountName           = ""
		  Me.bnetReadBuffer        = Nil
		  Me.bnlsReadBuffer        = Nil
		  Me.client                = client
		  Me.clientToken           = Battlenet.getClientToken()
		  Me.gameKey1              = client.config.gameKey1
		  Me.gameKey2              = client.config.gameKey2
		  Me.gameKeyOwner          = client.config.gameKeyOwner
		  Me.localIP               = Battlenet.getLocalIP()
		  Me.logonType             = 0
		  Me.nullTimer             = new PacketTimer()
		  Me.password              = client.config.password
		  Me.platform              = client.config.platform
		  Me.product               = client.config.product
		  Me.serverSignature       = ""
		  Me.serverToken           = 0
		  Me.statstring            = ""
		  Me.timezoneBias          = Battlenet.getTimezoneBias()
		  Me.udpToken              = 0
		  Me.uniqueName            = ""
		  Me.username              = client.config.username
		  Me.versionAndKeyPassed   = False
		  Me.versionByte           = 0
		  Me.versionCheckFileName  = ""
		  Me.versionCheckFileTime  = 0
		  Me.versionCheckSignature = ""
		  Me.versionChecksum       = 0
		  Me.versionNumber         = 0
		  Me.versionSignature      = ""
		  
		  ReDim Me.channelList(-1)
		  
		  Me.nullTimer.socBNET = Me.client.socBNET
		  Me.nullTimer.socBNLS = Me.client.socBNLS
		  Me.nullTimer.Period  = 60000
		  Me.nullTimer.Mode    = Me.nullTimer.ModeMultiple
		  Me.nullTimer.Enabled = False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  
		  Me.bnetReadBuffer = Nil
		  Me.bnlsReadBuffer = Nil
		  
		  Me.nullTimer.Enabled = False
		  Me.nullTimer = Nil
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		accountName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		bnetReadBuffer As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		bnlsReadBuffer As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		channelList() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		client As BNETClient
	#tag EndProperty

	#tag Property, Flags = &h0
		clientToken As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		gameKey1 As String
	#tag EndProperty

	#tag Property, Flags = &h0
		gameKey2 As String
	#tag EndProperty

	#tag Property, Flags = &h0
		gameKeyOwner As String
	#tag EndProperty

	#tag Property, Flags = &h0
		localIP As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		logonType As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		nullTimer As PacketTimer
	#tag EndProperty

	#tag Property, Flags = &h0
		password As String
	#tag EndProperty

	#tag Property, Flags = &h0
		platform As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		product As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		serverSignature As String
	#tag EndProperty

	#tag Property, Flags = &h0
		serverToken As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		statstring As String
	#tag EndProperty

	#tag Property, Flags = &h0
		timezoneBias As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		udpToken As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		uniqueName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		username As String
	#tag EndProperty

	#tag Property, Flags = &h0
		versionAndKeyPassed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		versionByte As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		versionCheckFileName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		versionCheckFileTime As UInt64
	#tag EndProperty

	#tag Property, Flags = &h0
		versionCheckSignature As String
	#tag EndProperty

	#tag Property, Flags = &h0
		versionChecksum As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		versionNumber As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		versionSignature As String
	#tag EndProperty


	#tag ViewBehavior
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