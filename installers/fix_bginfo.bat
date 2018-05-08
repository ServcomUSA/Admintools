@echo off

set taskname="Update Wallpaper Info"
set OS=""


cd \
schtasks /query | find %taskname% > NUL
IF ERRORLEVEL 1 goto :quit

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

if %OS%==32BIT (
	schtasks /change /tn %taskname% /tr "c:\admintools\bginfo.exe c:\admintools\bginfo.bgi /SILENT /NOLICPROMPT /TIMER:00"
)
if %OS%==64BIT (
	schtasks /change /tn %taskname% /tr "c:\admintools\bginfo64.exe c:\admintools\bginfo.bgi /SILENT /NOLICPROMPT /TIMER:00"
)

IF ERRORLEVEL 1 goto :fail
echo Task updated.
goto :eof

:quit
echo Could not find the task. Please manually edit the task, if present.
goto :eof

:fail
echo Could not update the task. Please manually edit the task.
goto :EOF


