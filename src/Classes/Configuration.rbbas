#tag Class
Protected Class Configuration
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  Me.bnetHost     = "useast.battle.net"
		  Me.bnetPort     = 6112
		  Me.bnlsHost     = "bnls.bnetdocs.org"
		  Me.bnlsPort     = 9367
		  Me.email        = ""
		  Me.gameKey1     = ""
		  Me.gameKey2     = ""
		  Me.gameKeyOwner = "Kaleidoscope"
		  Me.homeChannel  = ""
		  Me.password     = ""
		  Me.platform     = Battlenet.Platform_IX86
		  Me.product      = 0
		  Me.username     = ""
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		bnetHost As String
	#tag EndProperty

	#tag Property, Flags = &h0
		bnetPort As UInt16
	#tag EndProperty

	#tag Property, Flags = &h0
		bnlsHost As String
	#tag EndProperty

	#tag Property, Flags = &h0
		bnlsPort As UInt16
	#tag EndProperty

	#tag Property, Flags = &h0
		email As String
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
		homeChannel As String
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
		trigger As String
	#tag EndProperty

	#tag Property, Flags = &h0
		username As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="bnetHost"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="bnlsHost"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="email"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="gameKey1"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="gameKey2"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="gameKeyOwner"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="password"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
		#tag ViewProperty
			Name="trigger"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="username"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
