
<#
 .Synopsis
    Short description
 .DESCRIPTION
    Long description
 .EXAMPLE
    Example of how to use this cmdlet
 .EXAMPLE
    Another example of how to use this cmdlet
 #>
 function Schedule-SmtpRestartTask
 {
     [CmdletBinding()]
     [Alias()]
     [OutputType([int])]
     Param
     (
         # Param1 help description
         [string]
         $scriptPath="c:\admintools\scripts\Query-SmtpSvcWithRestart.ps1"
 
         
     )
 
     Begin
     {
      
            
     }
     Process
     {
        $action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" `
            -Argument "-NonInteractive -File $($scriptPath)"
        $trigger = New-ScheduledTaskTrigger -Daily -At '00:00'
        $settings = New-ScheduledTaskSettingsSet 
        $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        #$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings

        $task = Register-ScheduledTask -TaskName "Query and Restart SMTP Service" -Action $action -Trigger $trigger -Settings $settings -Description "Checks the status of the SMTP service on this server and restarts it, if needed." -Principal $principal
        $task.Triggers.Repetition.Duration = "P1D"
        $task.Triggers.Repetition.Interval = "PT1H"
        $task.Principal.RunLevel='Highest'
        $task | Set-ScheduledTask
     }
     End
     {
     }
 }