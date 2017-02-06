#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  
		  Me.exitCode = 0
		  
		  Me.ParseArgs(args)
		  Me.ParseConfig()
		  BotCommand.registerAll()
		  
		  stdout.WriteLine(Me.ProjectName() + "-" + Me.VersionString())
		  stdout.WriteLine("")
		  
		  For Each c As BNETClient In Me.clients
		    c.Connect()
		  Next
		  
		  Do Until Me.exitCode <> 0
		    Me.DoEvents(1)
		    Me.YieldToNextThread()
		  Loop
		  
		  Return Me.exitCode
		  
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
		  
		  If Len(buf) > 0 Then
		    stderr.WriteLine(buf)
		  End If
		  
		  Me.exitCode = 1
		  Return True
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Sub ParseArgs(args() As String)
		  
		  args.Remove(0)
		  
		  Dim index As Integer
		  Dim upperbound As Integer = UBound(args)
		  
		  If upperbound Mod 2 = 0 Then
		    stderr.WriteLine("Insufficient number of arguments")
		    Me.exitCode = 1
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
		      Me.exitCode = 1
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
		    Raise New ConfigParseException("Null file handle to config file")
		  End If
		  
		  If Me.configFile.Exists = False Then
		    Raise New ConfigParseException("Config file does not exist: " + Me.configFile.AbsolutePath)
		  End If
		  
		  If Me.configFile.IsReadable = False Then
		    Raise New ConfigParseException("Access denied while accessing config")
		  End If
		  
		  Dim stream As TextInputStream
		  Dim lineId, cursor, depth As Integer
		  Dim line, lineStr, groups(), group, key, val As String
		  Dim client As BNETClient, access As UserAccess
		  
		  Try
		    
		    stream = TextInputStream.Open(Me.configFile)
		    lineId = 0
		    depth = 0
		    ReDim groups(-1)
		    
		    While Not stream.EOF()
		      
		      line = Trim(stream.ReadLine(Encodings.UTF8))
		      lineId = lineId + 1
		      lineStr = " at line " + Format(lineId, "-#")
		      
		      If Len(line) = 0 Then Continue While
		      If Left(line, 1) = "#" Then Continue While
		      
		      If Right(line, 1) = "{" Then
		        
		        groups.Append(Trim(Left(line, Len(line) - 1)))
		        group = groups(UBound(groups))
		        depth = depth + 1
		        
		        Select Case group
		        Case ""
		          If depth > 1 Then
		            Raise New ConfigParseException("Global scope group being used inside of scoped group" + lineStr)
		          End If
		        Case "access"
		          If depth < 2 Or groups(depth - 2) <> "client" Or client = Nil Then
		            Raise New ConfigParseException("Group '" + group + "' being used outside of 'client' group" + lineStr)
		          End If
		          access = New UserAccess()
		        Case "client"
		          If depth > 1 Then
		            Raise New ConfigParseException("Group '" + group + "' cannot be a subgroup" + lineStr)
		          End If
		          client = New BNETClient()
		        Case Else
		          Raise New ConfigParseException("Undefined group '" + group + "'" + lineStr)
		        End Select
		        
		        Continue While
		        
		      End If
		      
		      If line = "}" Then
		        
		        Select Case group
		        Case ""
		        Case "access"
		          client.acl.Append(access)
		        Case "client"
		          Me.clients.Append(client)
		        Case Else
		          Raise New ConfigParseException("Undefined group '" + group + "'" + lineStr)
		        End Select
		        
		        Call groups.Pop()
		        depth = depth - 1
		        If UBound(groups) >= 0 Then
		          group = groups(UBound(groups))
		        Else
		          group = ""
		        End If
		        Continue While
		        
		      End If
		      
		      key = Trim(NthField(line, "=", 1))
		      val = Trim(Mid(line, Len(key) + 2))
		      
		      cursor = InStr(val, "#")
		      If cursor > 0 Then val = Left(val, cursor - 1)
		      val = RTrim(val)
		      
		      If depth = 0 Then
		        Raise New ConfigParseException("Global scope directives are not supported" + lineStr)
		      End If
		      
		      Select Case group
		      Case ""
		        
		        Select Case key
		        Case "logPackets"
		          Me.logPackets = Battlenet.strToBool(val)
		          If Me.logPackets Then stderr.WriteLine("Packet logging enabled!")
		        Case "trigger"
		          Me.trigger = val
		        Case Else
		          Raise New ConfigParseException("Undefined directive '" + key + "' in global scope" + lineStr)
		        End Select
		        
		      Case "access"
		        
		        If client = Nil Then
		          Raise New ConfigParseException("Group '" + group + "' being used outside of 'client' group" + lineStr)
		        End If
		        
		        Select Case key
		        Case "accountName"
		          access.accountName = val
		        Case "aclAdmin"
		          access.aclAdmin = Battlenet.strToBool(val)
		        Case "ignoreRealm"
		          access.ignoreRealm = Battlenet.strToBool(val)
		        Case "supplementalRealms"
		          access.supplementalRealms = val
		        Case Else
		          Raise New ConfigParseException("Undefined directive '" + key + "' in group '" + group + "'" + lineStr)
		        End Select
		        
		      Case "client"
		        
		        If client = Nil Then
		          Raise New ConfigParseException("Group '" + group + "' being used with null client object" + lineStr)
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
		        Case "email"
		          client.config.email = val
		        Case "gameKey1"
		          client.config.gameKey1 = Battlenet.strToGameKey(val)
		        Case "gameKey2"
		          client.config.gameKey2 = Battlenet.strToGameKey(val)
		        Case "gameKeyOwner"
		          client.config.gameKeyOwner = val
		        Case "password"
		          client.config.password = val
		        Case "platform"
		          client.config.platform = Battlenet.strToPlatform(val)
		        Case "product"
		          client.config.product = Battlenet.strToProduct(val)
		        Case "trigger"
		          client.config.trigger = val
		        Case "username"
		          client.config.username = val
		        Case Else
		          Raise New ConfigParseException("Undefined directive '" + key + "' in group '" + group + "'" + lineStr)
		        End Select
		        
		      Case Else
		        
		        Raise New ConfigParseException("Undefined directive '" + key + "' in group '" + group + "'" + lineStr)
		        
		      End Select
		      
		    Wend
		    
		  Catch err As BattlenetException
		    
		    Raise New ConfigParseException(err.Message + lineStr, err)
		    
		  Finally
		    
		    If stream <> Nil Then stream.Close()
		    
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PlatformName() As String
		  
		  #If TargetWin32 Then
		    Return "Windows"
		  #ElseIf TargetLinux Then
		    Return "Linux"
		  #Else
		    Return "Mac OS X"
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProjectName() As String
		  
		  Return "Kaleidoscope"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VersionString() As String
		  
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
		exitCode As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		logPackets As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		trigger As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="exitCode"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="logPackets"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="trigger"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
