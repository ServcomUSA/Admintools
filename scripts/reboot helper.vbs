'Reboot script
'

On Error Resume Next

'Options - 1. Single Instance / Recurring [One Time]
'          2. Time - [Tonight, 2100]
'          3. Force Reboot? [Y]
'          4. User account [currently logged on]
'	   5. Reason [???]
'	   6. 

Dim numMenuChoice, strSeekTaskName 

constMainMenu = "Reboot Script Creator" & vbNewLine & _
	"Please select from the following options:" & _
	vbNewLine & "  1. Schedule a reboot" & _
	vbNewLine & "  2. View scheduled tasks" & _
	vbNewLine & "  3. Search this machine for a scheduled task" & _
	vbNewLine & "  Q. Quit "

numMenuChoice = 0

do while numMenuChoice <> "Q"
	numMenuChoice = InputBox (constMainMenu)

	'MsgBox (Len(numMenuChoice))
	
	if Len(numMenuChoice) = 0 then
		'MsgBox ("Quitting")
		Wscript.Quit
	
	end if
	numMenuChoice = UCase(numMenuChoice)

	select case Left(numMenuChoice, 1)
		case "1"
			'MsgBox ("New Script")
			ScheduleTask()
		case "2" 
			'MsgBox ("List Scripts")
			EnumAllScheduledTasks()
		case "3"
			strSeekTaskName = InputBox("What task are you looking for? Search for any part of the task name. Case doesn't matter.")
			SearchForTask(strSeekTaskName)
		
		case "Q"
			'MsgBox ("Quitting.")
			Wscript.Quit

		case else
			MsgBox ("Invalid Input")
	end select
 	
loop

Function EnumAllScheduledTasks()
	Set shell = CreateObject("Wscript.Shell")
	errorVal = shell.Run("cmd /c %windir%\system32\schtasks.exe /query | more && pause",1,true)
	'MsgBox  ("Error Message: " & errorVal)
	set shell = Nothing
End Function

Function SearchForTask(strName)
	Set shell = CreateObject("Wscript.Shell")
	strExec = "cmd.exe /c  %windir%\system32\schtasks.exe /query | find /i " & _
		Chr(34) & strName & Chr(34) & " && pause"
	errorVal = shell.Run(strExec)
	'MsgBox ("Error Message: " & errorVal)
	set shell = Nothing
End function

Function ScheduleTask( )

	Dim strTaskName, strTaskRun, strSchedule, strStartTime, strStartDate, strShutdownArgs, strShutdownArgsExplained
	Dim strTaskExecCommand, strTaskMenuText, strInput
	const constTaskSchedulerPrefix = "%windir%\system32\schtasks.exe /create "
	strShutdownArgsExplained = _
"shutdown.exe args are as follows:" & vbNewline & _
" /i         Display the graphical user interface (GUI)." & vbNewline & _
"            This must be the first option." & vbNewline & _
" /l         Log off. This cannot be used with /m or /d options." & vbNewline & _
" /s         Shutdown the computer." & vbNewline & _
" /r         Shutdown and restart the computer." & vbNewline & _
" /p         Turn off the local computer with no time-out or warning." & vbNewline & _
"            Can be used with /d and /f options." & vbNewline & _
" /e         Document the reason for an unexpected shutdown of a computer." & vbNewline & _
" /m \\computer Specify the target computer." & vbNewline & _
" /t xxx     Set the time-out period before shutdown to xxx seconds." & vbNewline & _
"            The valid range is 0-315360000 (10 years), with a default of 30." & vbNewline & _
"            If the timeout period is greater than 0, the /f parameter is" & vbNewline & _
"            implied." & vbNewline & _
" /c " & Chr(34) & "comment" & Chr(34) & "Comment on the reason for the restart or shutdown." & vbNewline & _
"            Maximum of 512 characters allowed." & vbNewline & _
" /f         Force running applications to close without forewarning users." & vbNewline & _
"            The /f parameter is implied when a value greater than 0 is" & vbNewline & _
"            specified for the /t parameter." & vbNewline & _
" /d [p|u:]xx:yy  Provide the reason for the restart or shutdown." & vbNewline & _
"            p indicates that the restart or shutdown is planned." & vbNewline & _
"            u indicates that the reason is user defined." & vbNewline & _
"            If neither p nor u is specified the restart or shutdown is" & vbNewline & _
"            unplanned." & vbNewline & _
"            xx is the major reason number (positive integer less than 256)." & vbNewline & _
"            yy is the minor reason number (positive integer less than 65536)." & vbNewLine & _
"THIS ARGUMENT WILL NOT BE VERIFIED, SO MAKE SURE YOU DO IT RIGHT."

	strShutdownArgsExplainedShort = _
"shutdown.exe args are as follows:" & vbNewline & _
" /i - GUI" & vbNewline & _
" /l - Log off" & vbNewline & _
" /s - Shutdown" & vbNewline & _
" /r - Restart " & vbNewline & _
" /p - No time-out or warning" & vbNewline & _
" /e - Document the reason" & vbNewline & _
" /m \\computer Specify the target computer." & vbNewline & _
" /t xxx - Time-out in seconds." & vbNewline & _
" /c - Comment on the reason" & vbNewline & _
" /f - Force running applications to close without forewarning users." & vbNewline & _
" /d [p|u:]xx:yy  - Provide the reason for the restart or shutdown." & vbNewline & _
"            p - restart or shutdown is planned." & vbNewline & _
"            u - reason is user defined." & vbNewline & _
"            xx - major reason ( < 256)." & vbNewline & _
"            yy - minor reason ( < 65536)."

			


	'Dim arrayTaskVars(5,5)

	'set defaults
	strShutdownArgs = "-r -f -d p:2:4" & Chr(34)
	strTaskRun = "/tr " & Chr(34) & "%windir%\system32\shutdown.exe " 
	strTaskName = "SingleReboot"
	strSchedule = "ONCE"
	strStartTime = "21:00"

	Set shell = CreateObject("Wscript.Shell")
	
	shell.Popup("If you accept the defaults, this will schedule a reboot at 9 PM tonight.")

	strSchedMonth = Month(Now())
	strSchedDay = Day(Now())
	strSchedYear = Year(Now())

	if Hour(Now()) >= 21 then
		strSchedDay = Day(DateAdd("d", 1, Now()))
		shell.Popup("It is after 21:00, so we're setting the date one day forward.")
	end if
	
	if Day(Now) < 10 then
		'InputBox("padding day with a 0")
		strSchedDay = "0" & strSchedDay
	end if
	
	if Month(Now()) < 10 then
		'InputBox("padding month with a 0")
		strSchedMonth = "0" & strSchedMonth
	end if

  	strStartDate = strSchedMonth & _ 
			"/" & strSchedDay & _
			"/" & strSchedYear






	do while strInput <> "Q"				
		strTaskMenuText = "This menu will create a scheduled " & _
		"REBOOT task on the local machine" & vbNewLine & _
		" " & vbNewLine & _
		"Select an option below to change a value, or select the last number to schedule the task as displayed" & vbNewLine & _
		"Task details: " & vbNewLine & _
		" 1. Task  Name: " & strTaskName & vbNewLine & _
		" 2. Running on: " & strSchedule & vbNewLine & _
		" 3. Start Time: " & strStartTime & vbNewLine & _
		" 4. Start Date: " & strStartDate & vbNewLine & _
		" 5. Shutdown.exe Arguments: " & strShutdownArgs & vbNewLine & _
		" Q. Quit without scheduling." & vbNewLine & _
		" S. Schedule this task."

	strInput = InputBox (strTaskMenuText)

	strInput = UCase (strInput)
	'MsgBox (Left(strInput,1))

	if Len(strInput) = 0 then
		'MsgBox ("Cancel = Quit")
		Exit Function
	end if

	select case (Left(strInput,1))
		case "1"
			strTaskName = UpdateValue("Task Name", strTaskName, "Plain Text w/o Spaces")
			if ValidateFormat(strTaskname, 1) = 0 then
				strTaskName = strTaskname & "%INVALIDSTRING"
			end if

		case "2"
			strSchedule = UCase( UpdateValue("Frequency", strSchedule, "ONCE, DAILY, WEEKLY, MONTHLY") )
			if ValidateFormat(strSchedule, 3) = 0 then
				strSchedule = strSchedule & "%INVALIDSTRING"
			end if
		case "3"
			strStartTime = UpdateValue("Start Time", strStartTime, "HH:MM or HH:MM:SS")
			if ValidateFormat(strStartTime, 4) = 0 then
				strStartTime = strStartTime & "%INVALIDSTRING"
			end if
		case "4"
			 strStartDate = UpdateValue("Start Date", strStartDate, "MM/DD/YYYY")
			if ValidateFormat( strStartDate, 2) = 0 then
				MsgBox("The following value is not a recognized date: " & strStartDate " - Please re-enter using the required format (MM/DD/YYYY)") 
				strStartDate =  strStartDate & "%INVALIDSTRING"
			end if
			if (IsDate(strStartDate)) then
				if ( CDate(strStartDate) < Date() ) then
					MsgBox("Error: Date selected is in the past. Date will be reset to default. Your input: " & strStartDate & "// Current Date: " & Date() )
					strStartDate = strSchedMonth & _ 
						"/" & strSchedDay & _
						"/" & strSchedYear
				end if
			end if
		case "5"
			shell.Popup (strShutdownArgsExplained)
			strShutdownArgs = UpdateValue("Shutdown.exe Arguments", strShutdownArgs, strShutdownArgsExplainedShort)
			if Right(strShutdownArgs,1) <> Chr(34) then strShutdownArgs = strShutdownArgs & Chr(34)
		case "Q"
			Exit function
		case "S"
			'runs two different tasks, depending on the OS version
			'this will fail badly if the OS is older than 2003 or you run it on an XP machine
			strComputer = "."
			Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")

			Set colItems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
			For Each objItem in colItems
				If InStr(objItem.Caption, "Server 2003") Then	'server is 2003
				'don't use the /np switch
					strTaskExecCommand = constTaskSchedulerPrefix & _ 
						strTaskRun & strShutdownArgs & " "  & _
						"/tn " & strTaskName & " " & _
						"/sc " & strSchedule & " " & _
						"/st " & strStartTime & " " & _
						"/sd " & strStartDate
				Else
				'must be a newer version (older than 2003 not supported), so do use the /np switch
					strTaskExecCommand = constTaskSchedulerPrefix & _ 
						strTaskRun & strShutdownArgs & " "  & _
						"/tn " & strTaskName & " " & _
						"/sc " & strSchedule & " " & _
						"/st " & strStartTime & " " & _
						"/sd " & strStartDate & " " & _
						"/np"
				End if
			Next
			
			MsgBox (strTaskExecCommand)
			errorVal = shell.Run(strTaskExecCommand,1,true) 
			If errorVal <> 0 Then
				MsgBox( "Reported Error: " & errorVal )
			Else
				MsgBox( "Reboot successfully scheduled." )
			End If
			Set shell = Nothing
			
		case else
	end select
	loop

end function

function UpdateValue(strVarName, strCurrValue, strFormat)
	
	strInputBoxText = "Enter a new value for " & strVarName & vbNewLine & _
		"Currently set to: " & strCurrValue & vbNewLine & _
		"Format your input as: " & strFormat 

	
	UpdateValue = Trim( InputBox (strInputBoxText) )
end function

function ValidateFormat (strValue, numFormat)
	const SINGLEWORD = 1
	const MMDDYY = 2 'MM/DD/YYYY
	const SCHEDULED_LIST = 3
	const HHMMSS = 4 'HH:MM or HH:MM:SS

	Dim arrScheduleType
	
	arrScheduleType = array( "ONCE", "DAILY", "WEEKLY", "MONTHLY")

	Dim numIndexSpace

	ValidateFormat = 0

	select case numFormat
		case 1 'look for spaces
			numIndexSpace = InStr(strValue, " ")
			if numIndexSpace = 0 then ValidateFormat = 1
			
		case 2 'make sure it's ##/##/####
  		 	if Len(strValue) = 9 then 
				strValue = "0" & strValue
			else if Len(strValue) <> 10 then
				Exit Function
			   end if
			end if

		 	'(3) and (6) must be "/"
			if IsNumeric( Left(strValue, 2) ) then
			  if Mid(strValue, 3, 1) = "/" then
		 	    if IsNumeric( Mid(strValue, 4, 2) ) then
			      if Mid(strValue, 6, 1) = "/" then 
			        if IsNumeric( Mid(strValue,7,4) ) then 
			      	   ValidateFormat = 1
		                end if
		              end if
 			    end if
      			  end if
		        end if

		
		case 3 'make sure it's one of arrScheduledType
		  index = 0 
		  'MsgBox (Ubound(arrScheduleType))
		  do while index <= Ubound(arrScheduleType)
			  'MsgBox ("array: " & arrScheduleType(index) & "   string: " & strValue)
			if arrScheduleType(index) = strValue then 
				ValidateFormat = 1
				Exit Do
			end if
			index = index + 1
   		  loop

	  	case 4 'It's a time HH:MM or HH:MM:SS
  		  select case Len(strValue)
			 case 5 '(3) must be ":", all others must be num
			  if IsNumeric( Left(strValue, 2) ) then
  			   if Mid(strValue, 3, 1) = ":" then
		 	    if IsNumeric( Mid(strValue, 4, 2) ) then
			     ValidateFormat = 1
		            end if
      			   end if
		          end if
			
			 case 6 '(3) and (6) must be ":"
			  if IsNumeric( Left(strValue, 2) ) then
 			   if Mid(strValue, 3, 1) = ":" then
		 	    if IsNumeric( Mid(strValue, 4, 2) ) then
			     if Mid(strValue, 6, 1) = ":" then 
			      if IsNumeric( Mid(strValue,7,2) ) then 
			      	ValidateFormat = 1
		              end if
		             end if
 			    end if
      			   end if
		          end if
		  end select

	  case else
	  end select

end function
