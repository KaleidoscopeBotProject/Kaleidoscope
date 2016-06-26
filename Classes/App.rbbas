#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  
		  Dim c As New BNETClient()
		  Me.clients.Append(c)
		  
		  Me.ParseArgs(args)
		  
		  stdout.WriteLine(Me.ProjectName() + "-" + Me.VersionString())
		  stdout.WriteLine("")
		  
		  c.Connect()
		  
		  Do
		    Me.DoEvents(1)
		    Me.YieldToNextThread()
		  Loop
		  
		  Return 0
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Sub ParseArgs(args() As String)
		  
		  Dim client As BNETClient = Me.clients(0)
		  Dim index As Integer
		  Dim upperbound As Integer = UBound(args)
		  
		  If upperbound Mod 2 = 1 Then
		    stderr.WriteLine("Insufficient number of arguments")
		    Quit(1)
		    Return
		  End If
		  
		  Dim key, val As String
		  
		  For index = 1 To upperbound
		    
		    If index Mod 2 = 1 Then
		      key = args(index)
		      Continue For
		    End If
		    
		    val = args(index)
		    
		    Select Case key
		    Case "/bnethost", "-bnethost", "--bnethost"
		      client.config.bnetHost = val
		    Case "/bnetport", "-bnetport", "--bnetport"
		      client.config.bnetPort = Val(val)
		    Case "/bnlshost", "-bnlshost", "--bnlshost"
		      client.config.bnlsHost = val
		    Case "/bnlsport", "-bnlsport", "--bnlsport"
		      client.config.bnlsPort = Val(val)
		    Case "/log-packets", "-log-packets", "--log-packets"
		      Me.logPackets = Battlenet.strToBool(val)
		    Case "/platform", "-platform", "--platform", "/os", "-os", "--os"
		      client.config.platform = Battlenet.strToPlatform(val)
		    Case "/product", "-product", "--product", "/game", "-game", "--game"
		      client.config.product = Battlenet.strToProduct(val)
		    Case "/u", "/user", "/username", "-u", "-user", "-username", "--u", "--user", "--username"
		      client.config.username = val
		    Case "/p", "/pass", "/password", "-p", "-pass", "-password", "--p", "--pass", "--password"
		      client.config.password = val
		    Case Else
		      stderr.WriteLine("Invalid argument: " + key)
		      Quit(1)
		      Return
		    End Select
		    
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ProjectName() As String
		  
		  Return "Kaleidoscope"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function VersionString() As String
		  
		  Dim verstr As String
		  
		  #If DebugBuild Then
		    verstr = Format(Me.NonReleaseVersion, "-#")
		  #Else
		    verstr = Format(Me.NonReleaseVersion + 1, "-#")
		  #EndIf
		  
		  verstr = Format(Me.MajorVersion, "-#") + "." + _
		  Format(Me.MinorVersion, "-#") + "." + _
		  Format(Me.BugVersion, "-#") + "." + _
		  verstr
		  
		  Return verstr
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		clients() As BNETClient
	#tag EndProperty

	#tag Property, Flags = &h0
		logPackets As Boolean
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
