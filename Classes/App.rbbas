#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  
		  Me.ParseArgs(args)
		  Me.ParseConfig()
		  
		  stdout.WriteLine(Me.ProjectName() + "-" + Me.VersionString())
		  stdout.WriteLine("")
		  
		  For Each c As BNETClient In Me.clients
		    c.Connect()
		  Next
		  
		  Do
		    Me.DoEvents(1)
		    Me.YieldToNextThread()
		  Loop
		  
		  Return 0
		  
		End Function
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  
		  stderr.WriteLine("Exception of type " + Introspection.GetType(error).Name + " has occurred!")
		  
		  Dim buf As String = ""
		  
		  If error.ErrorNumber <> 0 Then
		    buf = buf + "#" + Format(error.ErrorNumber, "-#")
		  End If
		  
		  If Len(error.Message) > 0 Then
		    If Len(buf) > 0 Then buf = buf + ": "
		    buf = buf + error.Message
		  End If
		  
		  stderr.WriteLine(buf)
		  
		  Quit(1)
		  Return False
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Sub ParseArgs(args() As String)
		  
		  args.Remove(0)
		  
		  Dim index As Integer
		  Dim upperbound As Integer = UBound(args)
		  
		  If upperbound Mod 2 = 1 Then
		    stderr.WriteLine("Insufficient number of arguments")
		    Quit(1)
		    Return
		  End If
		  
		  Dim key, val As String
		  
		  For index = 0 To upperbound
		    
		    If index Mod 2 = 0 Then
		      key = args(index)
		      Continue For
		    End If
		    
		    val = args(index)
		    
		    Select Case key
		    Case "/config", "/c", "-config", "-c", "--config"
		      Me.configFile = New FolderItem(val)
		    Case Else
		      stderr.WriteLine("Invalid argument: " + key)
		      Quit(1)
		      Return
		    End Select
		    
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ParseConfig()
		  
		  If Me.configFile = Nil Then
		    Me.configFile = SpecialFolder.CurrentWorkingDirectory.Child("kaleidoscope.conf")
		  End If
		  
		  If Me.configFile = Nil Then
		    Raise New ConfigParseException("Null file handle to config file.")
		  End If
		  
		  If Me.configFile.IsReadable = False Then
		    Raise New ConfigParseException("Access denied while accessing config.")
		  End If
		  
		  Dim stream As TextInputStream
		  Dim lineId, cursor As Integer
		  Dim inGroup As Boolean
		  Dim line, group, key, val As String
		  Dim client As BNETClient
		  
		  Try
		    
		    stream = TextInputStream.Open(Me.configFile)
		    lineId = 0
		    inGroup = False
		    
		    While Not stream.EOF()
		      
		      line = Trim(stream.ReadLine(Encodings.UTF8))
		      lineId = lineId + 1
		      
		      If Len(line) = 0 Then Continue While
		      If Left(line, 1) = "#" Then Continue While
		      
		      If Right(line, 1) = "{" Then
		        
		        If inGroup = True Then
		          Raise New ConfigParseException("Subgroups not supported at line " + Format(lineId, "-#"))
		        End If
		        
		        group = Trim(Left(line, Len(line) - 1))
		        inGroup = True
		        
		        Select Case group
		        Case ""
		        Case "client"
		          client = New BNETClient()
		        Case Else
		          Raise New ConfigParseException("Undefined group '" + group + "' at line " + Format(lineId, "-#"))
		        End Select
		        
		        Continue While
		        
		      End If
		      
		      If line = "}" Then
		        
		        Select Case group
		        Case ""
		        Case "client"
		          Me.clients.Append(client)
		        Case Else
		          Raise New ConfigParseException("Undefined group '" + group + "' at line " + Format(lineId, "-#"))
		        End Select
		        
		        inGroup = False
		        group = ""
		        Continue While
		        
		      End If
		      
		      key = Trim(NthField(line, "=", 1))
		      val = Trim(Mid(line, Len(key) + 2))
		      
		      cursor = InStr(val, "#")
		      If cursor > 0 Then val = Left(val, cursor - 1)
		      val = RTrim(val)
		      
		      If inGroup = False Then
		        Raise New ConfigParseException("Global scope directives are not supported at line " + Format(lineId, "-#"))
		      End If
		      
		      Select Case group
		      Case ""
		        
		        Select Case key
		        Case "logPackets"
		          Me.logPackets = Battlenet.strToBool(val)
		          If Me.logPackets Then stderr.WriteLine("Packet logging enabled!")
		        Case Else
		          Raise New ConfigParseException("Undefined directive '" + key + "' in global scope at line " + Format(lineId, "-#"))
		        End Select
		        
		      Case "client"
		        
		        If client = Nil Then
		          Raise New ConfigParseException("Group '" + group + "' being used with null client object")
		        End If
		        
		        Select Case key
		        Case "bnetHost"
		          client.config.bnetHost = val
		        Case "bnetPort"
		          client.config.bnetPort = Val(val)
		        Case "bnlsHost"
		          client.config.bnlsHost = val
		        Case "bnlsPort"
		          client.config.bnlsPort = Val(val)
		        Case "gameKey1"
		          client.config.gameKey1 = val
		        Case "gameKey2"
		          client.config.gameKey2 = val
		        Case "gameKeyOwner"
		          client.config.gameKeyOwner = val
		        Case "password"
		          client.config.password = val
		        Case "platform"
		          client.config.platform = Battlenet.strToPlatform(val)
		        Case "product"
		          client.config.product = Battlenet.strToProduct(val)
		        Case "username"
		          client.config.username = val
		        Case Else
		          Raise New ConfigParseException("Undefined directive '" + key + "' in group '" + group + "' at line " + Format(lineId, "-#"))
		        End Select
		        
		      Case Else
		        
		        Raise New ConfigParseException("Undefined directive '" + key + "' in group '" + group + "' at line " + Format(lineId, "-#"))
		        
		      End Select
		      
		    Wend
		    
		  Finally
		    
		    If stream <> Nil Then stream.Close()
		    
		  End Try
		  
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
		configFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		logPackets As Boolean
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
