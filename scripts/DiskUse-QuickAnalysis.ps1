cd C:\Admintools

Write-Host "Checking Program Files"
.\du.exe -l 1 'C:\Program Files'

Write-Host "Checking Program Files (x86)"
.\du.exe -l 1 'C:\Program Files (x86)'

Write-Host "Checking c:\users"
.\du.exe -l 1 'c:\users'

Write-Host "Checking Windows\Log files"
.\du.exe -l 1 C:\Windows\Logs

Write-Host "Checking Windows\Temp folder"
.\du.exe -l 1 C:\windows\Temp

Write-Host "Checking for cab files in Windows\Temp"
$files = Get-ChildItem -Path C:\Windows\Temp -Filter "cab_*"
$sum = $files | Measure-Object -Property Length -sum
$total = $sum.sum/1GB
Write-Host "c:\Windows\temp\Cab_ files: $total GBs"
