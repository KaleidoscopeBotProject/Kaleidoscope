#tag Module
Protected Module Battlenet
	#tag Method, Flags = &h1
		Protected Function getClientToken() As UInt32
		  
		  Dim mem As New MemoryBlock(4)
		  
		  mem.UInt8Value(0) = Floor(Rnd() * 255)
		  mem.UInt8Value(1) = Floor(Rnd() * 255)
		  mem.UInt8Value(2) = Floor(Rnd() * 255)
		  mem.UInt8Value(3) = Floor(Rnd() * 255)
		  
		  Return mem.UInt32Value(0)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function getKeyData(strKey As String, clientToken As UInt32, serverToken As UInt32) As String
		  
		  // For use with 0x51 SID_AUTH_CHECK
		  
		  Soft Declare Function kd_quick Lib Battlenet.libBNCSUtil (_
		  key As Ptr, clientToken As UInt32, serverToken As UInt32, _
		  publicVal As Ptr, productVal As Ptr, privateVal As Ptr, privateValLen As UInt32) _
		  As Boolean
		  
		  Dim mKey As New MemoryBlock(LenB(strKey) + 1)
		  mKey.CString(0) = strKey
		  
		  Dim mPublicVal As New MemoryBlock(4)
		  Dim mProductVal As New MemoryBlock(4)
		  Dim mPrivateVal As New MemoryBlock(20)
		  
		  Dim returnVal As Boolean = kd_quick(_
		  mKey, clientToken, serverToken, _
		  mPublicVal, mProductVal, mPrivateVal, mPrivateVal.Size)
		  
		  If returnVal = False Then Return ""
		  
		  Dim mReturnVal As New MemoryBlock(16 + mPrivateVal.Size)
		  
		  mReturnVal.UInt32Value(0) = LenB(strKey)
		  mReturnVal.UInt32Value(4) = mProductVal.UInt32Value(0)
		  mReturnVal.UInt32Value(8) = mPublicVal.UInt32Value(0)
		  mReturnVal.UInt32Value(12) = 0
		  mReturnVal.StringValue(16, mPrivateVal.Size) = mPrivateVal.StringValue(0, mPrivateVal.Size)
		  
		  Return mReturnVal
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function getLocalIP() As UInt32
		  
		  Dim soc As New TCPSocket()
		  Dim mem As New MemoryBlock(4)
		  
		  mem.UInt8Value(0) = Val(NthField(soc.LocalAddress, ".", 4))
		  mem.UInt8Value(1) = Val(NthField(soc.LocalAddress, ".", 3))
		  mem.UInt8Value(2) = Val(NthField(soc.LocalAddress, ".", 2))
		  mem.UInt8Value(3) = Val(NthField(soc.LocalAddress, ".", 1))
		  
		  Return mem.UInt32Value(0)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function getTimezoneBias() As UInt32
		  
		  Dim o As New Date()
		  
		  Return (0 - o.GMTOffset) * 60
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function isDiablo2(product As UInt32) As Boolean
		  
		  Select Case product
		  Case Battlenet.Product_D2DV
		  Case Battlenet.Product_D2XP
		  Case Else
		    Return False
		  End Select
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function isWarcraft3(product As UInt32) As Boolean
		  
		  Select Case product
		  Case Battlenet.Product_W3DM
		  Case Battlenet.Product_W3XP
		  Case Battlenet.Product_WAR3
		  Case Else
		    Return False
		  End Select
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub login(client As BNETClient)
		  
		  Const TYPE_OLS      = &H00
		  Const TYPE_NLS_BETA = &H01
		  Const TYPE_NLS      = &H02
		  
		  Select Case client.state.logonType
		  Case TYPE_OLS
		    
		    client.socBNET.Write(Packets.CreateBNET_SID_LOGONRESPONSE2(_
		    client.state.clientToken, client.state.serverToken, _
		    Battlenet.passwordDataOLS(client.state.password, _
		    client.state.clientToken, client.state.serverToken), _
		    client.state.username))
		    
		  Case TYPE_NLS_BETA, TYPE_NLS
		    
		    stderr.WriteLine("DEBUG: NLS")
		    
		  Case Else
		    
		    Raise New InvalidPacketException()
		    
		  End Select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function needsGameKey1(product As UInt32) As Boolean
		  
		  Select Case product
		  Case Battlenet.Product_D2DV
		  Case Battlenet.Product_D2XP
		  Case Battlenet.Product_JSTR
		  Case Battlenet.Product_SEXP
		  Case Battlenet.Product_STAR
		  Case Battlenet.Product_W2BN
		  Case Battlenet.Product_W3XP
		  Case Battlenet.Product_WAR3
		  Case Else
		    Return False
		  End Select
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function needsGameKey2(product As UInt32) As Boolean
		  
		  Select Case product
		  Case Battlenet.Product_D2XP
		  Case Battlenet.Product_W3XP
		  Case Else
		    Return False
		  End Select
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function passwordDataOLS(password As String, clientToken As UInt32, serverToken As UInt32) As String
		  
		  Soft Declare Sub doubleHashPassword Lib Battlenet.libBNCSUtil (_
		  password As Ptr,clientToken As UInt32, serverToken As UInt32, _
		  passwordHash As Ptr)
		  
		  Dim mPassword As New MemoryBlock(LenB(password) + 1)
		  mPassword.CString(0) = password
		  
		  Dim mPasswordHash As New MemoryBlock(20)
		  
		  doubleHashPassword(mPassword, clientToken, serverToken, mPasswordHash)
		  
		  Return mPasswordHash
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function productToBNET(value As UInt32) As UInt32
		  
		  Select Case value
		  Case 1
		    Return Battlenet.Product_STAR
		  Case 2
		    Return Battlenet.Product_SEXP
		  Case 3
		    Return Battlenet.Product_W2BN
		  Case 4
		    Return Battlenet.Product_D2DV
		  Case 5
		    Return Battlenet.Product_D2XP
		  Case 6
		    Return Battlenet.Product_JSTR
		  Case 7
		    Return Battlenet.Product_WAR3
		  Case 8
		    Return Battlenet.Product_W3XP
		  Case 9
		    Return Battlenet.Product_DRTL
		  Case 10
		    Return Battlenet.Product_DSHR
		  Case 11
		    Return Battlenet.Product_SSHR
		  Case 12
		    Return Battlenet.Product_W3DM
		  Case Else
		    Raise New OutOfBoundsException()
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function productToBNLS(value As UInt32) As UInt32
		  
		  Select Case value
		  Case Battlenet.Product_STAR
		    Return 1
		  Case Battlenet.Product_SEXP
		    Return 2
		  Case Battlenet.Product_W2BN
		    Return 3
		  Case Battlenet.Product_D2DV
		    Return 4
		  Case Battlenet.Product_D2XP
		    Return 5
		  Case Battlenet.Product_JSTR
		    Return 6
		  Case Battlenet.Product_WAR3
		    Return 7
		  Case Battlenet.Product_W3XP
		    Return 8
		  Case Battlenet.Product_DRTL
		    Return 9
		  Case Battlenet.Product_DSHR
		    Return 10
		  Case Battlenet.Product_SSHR
		    Return 11
		  Case Battlenet.Product_W3DM
		    Return 12
		  Case Else
		    Raise New OutOfBoundsException()
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function strToBool(value As String) As Boolean
		  
		  Select Case value
		  Case "1"
		  Case "On"
		  Case "True"
		  Case "Y"
		  Case "Yes"
		  Case Else
		    Return False
		  End Select
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function strToPlatform(value As String) As UInt32
		  
		  Select Case value
		  Case "IX86", "68XI", "windows", "win32", "win64", "win", "linux", "unix"
		    Return Battlenet.Platform_IX86
		  Case "PMAC", "CAMP", "powerpc", "classicmac", "macclassic"
		    Return Battlenet.Platform_PMAC
		  Case "XMAC", "CAMX", "macintosh", "mac", "osx", "macosx", "macos"
		    Return Battlenet.Platform_XMAC
		  Case Else
		    Raise New UnsupportedFormatException()
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function strToProduct(value As String) As UInt32
		  
		  Select Case value
		  Case "CHAT", "Telnet"
		    Return Battlenet.Product_CHAT
		  Case "D2DV", "D2"
		    Return Battlenet.Product_D2DV
		  Case "D2XP", "LOD"
		    Return Battlenet.Product_D2XP
		  Case "DRTL", "D1"
		    Return Battlenet.Product_DRTL
		  Case "DSHR", "DS"
		    Return Battlenet.Product_DSHR
		  Case "JSTR", "SCJ"
		    Return Battlenet.Product_JSTR
		  Case "SEXP", "BW"
		    Return Battlenet.Product_SEXP
		  Case "SSHR", "SS"
		    Return Battlenet.Product_SSHR
		  Case "STAR", "SC"
		    Return Battlenet.Product_STAR
		  Case "W2BN", "W2"
		    Return Battlenet.Product_W2BN
		  Case "W3DM", "W3D"
		    Return Battlenet.Product_W3DM
		  Case "W3XP", "TFT"
		    Return Battlenet.Product_W3XP
		  Case "WAR3", "W3"
		    Return Battlenet.Product_WAR3
		  Case Else
		    Raise New UnsupportedFormatException()
		  End Select
		  
		End Function
	#tag EndMethod


	#tag Constant, Name = libBNCSUtil, Type = String, Dynamic = False, Default = \"", Scope = Protected
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"/usr/lib/libbncsutil.so"
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"C:\\Windows\\bncsutil.dll"
	#tag EndConstant

	#tag Constant, Name = Platform_IX86, Type = Double, Dynamic = False, Default = \"&H49583836", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Platform_PMAC, Type = Double, Dynamic = False, Default = \"&H504D4143", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Platform_XMAC, Type = Double, Dynamic = False, Default = \"&H584D4143", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_CHAT, Type = Double, Dynamic = False, Default = \"&H43484154", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_D2DV, Type = Double, Dynamic = False, Default = \"&H44324456", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_D2XP, Type = Double, Dynamic = False, Default = \"&H44325850", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_DRTL, Type = Double, Dynamic = False, Default = \"&H4452544C", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_DSHR, Type = Double, Dynamic = False, Default = \"&H44534852", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_JSTR, Type = Double, Dynamic = False, Default = \"&H4A535452", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_SEXP, Type = Double, Dynamic = False, Default = \"&H53455850", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_SSHR, Type = Double, Dynamic = False, Default = \"&H53534852", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_STAR, Type = Double, Dynamic = False, Default = \"&H53544152", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_W2BN, Type = Double, Dynamic = False, Default = \"&H5732424E", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_W3DM, Type = Double, Dynamic = False, Default = \"&H5733444D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_W3XP, Type = Double, Dynamic = False, Default = \"&H57335850", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Product_WAR3, Type = Double, Dynamic = False, Default = \"&H57415233", Scope = Protected
	#tag EndConstant


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
End Module
#tag EndModule
