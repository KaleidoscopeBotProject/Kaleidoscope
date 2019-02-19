#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  
		  Me.uptimeConstant = Microseconds()
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


	#tag Method, Flags = &h0
		Function AuthorName() As String
		  
		  Return "Caaaaarrrrlll"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ParseArgs(args() As String)
		  
		  args.Remove(0)
		  
		  #If TargetLinux = True Then
		    If UBound(args) >= 0 And Len(args(0)) = 0 Then
		      args.Remove(0)
		    End If
		  #EndIf
		  
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
		    #If DebugBuild = False Then
		      Me.configFile = SpecialFolder.CurrentWorkingDirectory.Child("kaleidoscope.conf")
		    #Else
		      Me.configFile = SpecialFolder.CurrentWorkingDirectory.Parent.Child("kaleidoscope.conf")
		    #EndIf
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
		        Case "autoRejoin"
		          client.config.autoRejoin = Battlenet.strToBool(val)
		        Case "bnetHost"
		          client.config.bnetHost = val
		        Case "bnetPort"
		          client.config.bnetPort = Val(val)
		        Case "bnlsHost"
		          client.config.bnlsHost = val
		        Case "bnlsPort"
		          client.config.bnlsPort = Val(val)
		        Case "createAccount"
		          client.config.createAccount = Val(val)
		        Case "email"
		          client.config.email = val
		        Case "gameKey1"
		          client.config.gameKey1 = Battlenet.strToGameKey(val)
		        Case "gameKey2"
		          client.config.gameKey2 = Battlenet.strToGameKey(val)
		        Case "gameKeyOwner"
		          client.config.gameKeyOwner = val
		        Case "greetAclExclusive"
		          client.config.greetAclExclusive = Battlenet.strToBool(val)
		        Case "greetEnabled"
		          client.config.greetEnabled = Battlenet.strToBool(val)
		        Case "greetMessage"
		          client.config.greetMessage = val
		        Case "homeChannel"
		          client.config.homeChannel = val
		        Case "idleBaseInterval"
		          client.config.idleBaseInterval = Val(val)
		        Case "idleDelayInterval"
		          client.config.idleDelayInterval = Val(val)
		        Case "idleEnabled"
		          client.config.idleEnabled = Battlenet.strToBool(val)
		        Case "idleMessage"
		          client.config.idleMessage = val
		        Case "password"
		          client.config.password = val
		        Case "passwordNew"
		          client.config.passwordNew = val
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
		  #ElseIf TargetMacOS Then
		    Return "Mac OS X"
		  #Else
		    Return "Unknown"
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PlatformVersion() As String
		  
		  
		  #If TargetWin32 Then
		    
		    Soft Declare Function GetVersion Lib "Kernel32" () As UInt32
		    
		    Dim mb As New MemoryBlock(4)
		    mb.UInt32Value(0) = GetVersion()
		    
		    Dim dwMajorVersion As Integer = mb.Int8Value(0)
		    Dim dwMinorVersion As Integer = mb.Int8Value(1)
		    Dim dwBuild        As Integer = mb.Int16Value(2)
		    
		    Dim dblVersion As Double = Val(Format(dwMajorVersion, "#") + "." + Format(dwMinorVersion, "#"))
		    Dim strVersion As String = Format(dblVersion, "0.0####") + " Build " + Format(dwBuild, "000#")
		    
		    Select Case dblVersion
		    Case 5.0
		      Return "2000 (" + strVersion + ")"
		    Case 5.1
		      Return "XP (" + strVersion + ")"
		    Case 5.2
		      Return "Server 2003 (" + strVersion + ")"
		    Case 6.0
		      Return "Vista (" + strVersion + ")"
		    Case 6.1
		      Return "7 (" + strVersion + ")"
		    Case 6.2
		      Return "8 (" + strVersion + ")"
		    Case 6.3
		      Return "8.1 (" + strVersion + ")"
		    Case 10.0
		      Return "10 (" + strVersion + ")"
		    Case Else
		      Return strVersion
		    End Select
		    
		  #ElseIf TargetLinux Then
		    
		    Dim kernelString As String = ""
		    Dim sh As New Shell()
		    
		    // All but the node name (hostname)
		    sh.Execute("uname -r -v -m -p -i -o")
		    
		    If sh.ErrorCode = 0 Then
		      kernelString = ReplaceLineEndings(sh.Result, " ")
		    Else
		      kernelString = App.PlatformName()
		    End If
		    
		    sh.Close()
		    
		    Return kernelString
		    
		  #ElseIf TargetMacOS Then
		    
		    // TODO
		    Return ""
		    
		  #Else
		    
		    Return ""
		    
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrefixLines(value As String, prefix As String) As String
		  
		  Dim lines() As String
		  Dim i, j As Integer
		  
		  lines = Split(ReplaceLineEndings(value, EndOfLine), EndOfLine)
		  i     = 0
		  j     = UBound(lines)
		  
		  If j = -1 Then Return prefix + value
		  
		  While i <= j
		    lines(i) = prefix + lines(i)
		    i = i + 1
		  Wend
		  
		  Return Join(lines, EndOfLine)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProjectName() As String
		  
		  Return "Kaleidoscope"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RandomString(length As Integer, mask As String) As String
		  
		  Dim buf As String
		  Dim maskLen As Integer
		  
		  maskLen = Len(mask)
		  
		  While Len(buf) < length
		    buf = buf + Mid(mask, 1 + Floor(Rnd() * maskLen), 1)
		  Wend
		  
		  Return buf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SystemUptime() As Double
		  
		  // Returns system uptime in seconds, double-precision in case we have
		  // a higher prevision available
		  
		  #If TargetWin32 = True Then
		    
		    Return Microseconds() / 1000000
		    
		  #ElseIf TargetLinux = True Then
		    
		    Soft Declare Function sysinfo Lib "libc" (sysinfo As Ptr) As Integer
		    
		    Dim mb As New MemoryBlock(64)
		    If sysinfo(mb) <> 0 Then
		      Return 0
		    End If
		    
		    // Uptime is represented as a signed 32-bit integer
		    // See sysinfo struct on Linux (glibc sys/sysinfo.h)
		    // <http://man7.org/linux/man-pages/man2/sysinfo.2.html>
		    Return mb.Long(0)
		    
		  #Else
		    
		    Return Ticks() / 60 // Hope for the best
		    
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TimeString(Period As UInt64, Fullstring As Boolean = False, ShortLegend As Boolean = False) As String
		  
		  Dim Buffer As String = ""
		  Dim Years, Days, Hours, Minutes, Seconds As UInt64
		  Dim LYear, LDay, LHour, LMinute, LSecond As String
		  
		  If ShortLegend = False Then
		    LYear = "year"
		    LDay = "day"
		    LHour = "hour"
		    LMinute = "minute"
		    LSecond = "second"
		  Else
		    LYear = "y"
		    LDay = "d"
		    LHour = "h"
		    LMinute = "m"
		    LSecond = "s"
		  End If
		  
		  // BEGIN CONVERSIONS
		  
		  // Period is in seconds:
		  Seconds = Period
		  
		  // 60 seconds in 1 minute:
		  Minutes = Seconds \ 60
		  Seconds = Seconds Mod 60
		  
		  // 60 minutes in 1 hour:
		  Hours = Minutes \ 60
		  Minutes = Minutes Mod 60
		  
		  // 24 hours in 1 day:
		  Days = Hours \ 24
		  Hours = Hours Mod 24
		  
		  // 365 days in 1 year:
		  Years = Days \ 365
		  Days = Days Mod 365
		  
		  // END CONVERSIONS
		  
		  If Fullstring = True Then
		    // Return something like "5 days, 0 hours, 1 minute, 13 seconds"
		    If ShortLegend = False Then
		      Buffer = Buffer + Str(Years) + " " + LYear
		      If Years <> 1 Then Buffer = Buffer + "s"
		      Buffer = Buffer + Str(Days) + " " + LDay
		      If Days <> 1 Then Buffer = Buffer + "s"
		      Buffer = Buffer + ", " + Str(Hours) + " " + LHour
		      If Hours <> 1 Then Buffer = Buffer + "s"
		      Buffer = Buffer + ", " + Str(Minutes) + " " + LMinute
		      If Minutes <> 1 Then Buffer = Buffer + "s"
		      Buffer = Buffer + ", " + Str(Seconds) + " " + LSecond
		      If Seconds <> 1 Then Buffer = Buffer + "s"
		    Else
		      Buffer = Buffer + Str(Years) + LYear + " " + Str(Days) + LDay + " " _
		      + Str(Hours) + LHour + " " + Str(Minutes) + LMinute + " " _
		      + Str(Seconds) + LSecond
		    End If
		    Return Buffer
		  End If
		  
		  // Return something like "5 days, 1 minute, 13 seconds"
		  
		  If Years <> 0 Then
		    If ShortLegend = False Then
		      Buffer = Buffer + ", " + Str(Years) + " " + LYear
		      If Years <> 1 Then Buffer = Buffer + "s"
		    Else
		      Buffer = Buffer + Str(Years) + LYear + " "
		    End If
		  End If
		  
		  If Days <> 0 Then
		    If ShortLegend = False Then
		      Buffer = Buffer + ", " + Str(Days) + " " + LDay
		      If Days <> 1 Then Buffer = Buffer + "s"
		    Else
		      Buffer = Buffer + Str(Days) + LDay + " "
		    End If
		  End If
		  
		  If Hours <> 0 Then
		    If ShortLegend = False Then
		      Buffer = Buffer + ", " + Str(Hours) + " " + LHour
		      If Hours <> 1 Then Buffer = Buffer + "s"
		    Else
		      Buffer = Buffer + Str(Hours) + LHour + " "
		    End If
		  End If
		  
		  If Minutes <> 0 Then
		    If ShortLegend = False Then
		      Buffer = Buffer + ", " + Str(Minutes) + " " + LMinute
		      If Minutes <> 1 Then Buffer = Buffer + "s"
		    Else
		      Buffer = Buffer + Str(Minutes) + LMinute + " "
		    End If
		  End If
		  
		  If Seconds <> 0 Then
		    If ShortLegend = False Then
		      Buffer = Buffer + ", " + Str(Seconds) + " " + LSecond
		      If Seconds <> 1 Then Buffer = Buffer + "s"
		    Else
		      Buffer = Buffer + Str(Seconds) + LSecond + " "
		    End If
		  End If
		  
		  If Seconds = 0 And Minutes = 0 And Hours = 0 And Days = 0 And Years = 0 Then
		    If ShortLegend = False Then
		      Buffer = ", 0 seconds"
		    Else
		      Buffer = "0s"
		    End If
		  End If
		  
		  If Left(Buffer, 2) = ", " Then
		    Return Mid(Buffer, 3)
		  ElseIf Right(Buffer, 1) = " " Then
		    Return Mid(Buffer, 1, Len(Buffer) - 1)
		  Else
		    Return Buffer
		  End If
		  
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

	#tag Property, Flags = &h0
		uptimeConstant As Double
	#tag EndProperty


	#tag Constant, Name = SIGTERM, Type = Double, Dynamic = False, Default = \"15", Scope = Public
	#tag EndConstant


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
		#tag ViewProperty
			Name="uptimeConstant"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
