@echo off

set taskname="Update Wallpaper Info"
cd \
schtasks /query | find %taskname% > NUL
IF ERRORLEVEL 1 goto :quit
schtasks /change /tn %taskname% /tr "c:\admintools\bginfo.exe c:\admintools\bginfo.bgi /SILENT /NOLICPROMPT /TIMER:00"
IF ERRORLEVEL 1 goto :fail
echo Task updated.
goto :eof

:quit
echo Could not find the task. Please manually edit the task, if present.
goto :eof

:fail
echo Could not update the task. Please manually edit the task.
goto :EOF


