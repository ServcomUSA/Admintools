#returns a simplified uptime in Days/Hours/Minutes/Seconds columns
#takes no parameters
(Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime | Select Days, Hours, Minutes, Seconds