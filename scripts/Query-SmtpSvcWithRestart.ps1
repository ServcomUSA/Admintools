#debug info
$eventID = 1
$eventMessage = ""
$eventType = "Information"

try { 
    $svc = get-service -name SMTPSVC
    $initStatus = $svc.Status
    if ($svc.Status -ne 'Running') {
	#not running? start it
        start-service -Name $svc.Name
        $eventID = 2    
  
} catch [Exception] {
    $eventID = 1000
    $eventMessage = $_.Exception.Message
    $eventType = "Error"
    }
    
#Write output to event log for debugging
switch ($eventID)
{
    1 {
        $eventMessage = "The " + $svc.Name + " service was queried. The status of the service at the time of the query was: " + $initStatus + ".`n"
        $eventMessage += "No change was made to this service's state."
    }
    
    2 { 
        $eventMessage = "The " + $svc.Name + " service was queried. The status of the service at the time of the query was:  " + $initStatus + ".`n"
        $eventMessage += "An attempt was made to start this service."
        $eventType = "Warning"
    }  
    
    1000 { $eventMessage += " This error is sometimes caused by the named service not existing. Check to make sure " + $svc.Name + " is installed on this computer."
    }
    
    default {
        $eventMessage = "Uknown/invalid status was detected. Debug Information: " + "`n"
        $eventMessage += "EventID: " + $eventID + "`n"
        $eventMessage += "Service Status at time of query: " + $initStatus + "`n"
        $eventType = "Error"
        
    }
}

#determine that our EventLog source exists; if the following statement returns 'False', then we execute the command
# to generate the source
$eventSourceExists = [System.Diagnostics.EventLog]::SourceExists('Servcom USA Script')
if ($eventSourceExists -eq $false) { New-EventLog -LogName Application -Source "Servcom USA Script" }

Write-EventLog -LogName Application -Source "Servcom USA Script" -EntryType $eventType -EventID $eventID -Message $eventMessage