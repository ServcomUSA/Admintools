strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2\power")
Set colItems = objWMIService.ExecQuery("SELECT ElementName,Description FROM Win32_PowerPlan WHERE IsActive = TRUE")
For Each objItem in colItems
Echo objItem.ElementName
Next