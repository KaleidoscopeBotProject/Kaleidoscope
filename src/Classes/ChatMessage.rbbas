#tag Class
Protected Class ChatMessage
	#tag Property, Flags = &h0
		accountNumber As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		eventId As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		flags As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		ipAddress As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		ping As Int32
	#tag EndProperty

	#tag Property, Flags = &h0
		registrationAuthority As UInt32
	#tag EndProperty

	#tag Property, Flags = &h0
		text As String
	#tag EndProperty

	#tag Property, Flags = &h0
		username As String
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
			Name="text"
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="username"
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
