@echo off

REM 
setlocal ENABLEEXTENSIONS
set REG_NAME="HKLM\Software\Wow6432Node\Servcom USA\Admintools"
set KEY_NAME="bginfo_path"
set bginfo_path=""
set OS=""

FOR /F "usebackq skip=2 tokens=1-3" %%A IN (`REG QUERY %REG_NAME% /v %KEY_NAME% 2^>nul`) DO SET bginfo_path=%%C

if "%bginfo_path%"=="" (
	ECHO "no path; quit"
	GOTO :EOF
)

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==32BIT (
	schtasks /create /tn "Update Wallpaper Info" /tr "%bginfo_path%\bginfo.exe %bginfo_path%\bginfo.bgi /silent /nolicprompt /timer:0" /sc ONLOGON /F  
)
if %OS%==64BIT (
	schtasks /create /tn "Update Wallpaper Info" /tr "%bginfo_path%\bginfo64.exe %bginfo_path%\bginfo.bgi /silent /nolicprompt /timer:0" /sc ONLOGON /F  	
)
schtasks /run /tn "Update Wallpaper Info" /I

endlocal