@echo off

REM This creates a new universal environment variable: OLD_PATH that you can restore the path from
REM This also edites the universal path variable on this computer and adds the admintools
REM    base directory and vim exectuable directory to the path.

REM UPDATE_TYPE is a control mechanism that selects the level of additions to be 
REM Quick list of options and rules for updating
REM ==============================================
REM VALUE	**	UPDATE DETAILS		**
REM ----------------------------------------------
REM 0		**	(Default) - do not change path
REM 1		**	append "c:\admintools\" to path
REM 2		**	append "c:\admintools\vim\vim72\" to path *removed (v.2.10)
REM 3		**	append (1) and (2) to path in sequence *removed (v.2.10)
REM 4		**	_add new commands from here_
REM ----------------------------------------------
REM

set UPDATE_TYPE=0
set PATH_FINAL_CHAR=""
set PATH_EXTENSION=""

REM Echo "Created var UPDATE_TYPE"
if not exist c:\admintools\installers goto NOTOOLS

cd c:\admintools\installers\
setx /m OLD_PATH "%PATH%"
REM Echo "Saved OLD_PATH"

REM Echo %PATH:~-1%
REM set PATH_FINAL_CHAR="1"
set PATH_FINAL_CHAR=%PATH:~-1%
REM Echo PATH_FINAL_CHAR = %PATH_FINAL_CHAR%
REM @echo on
REM if "%PATH_FINAL_CHAR%"==";" ( Echo "TRUE" ) ELSE ( Echo False )
REM goto EOF

PATH > %TEMP%.\path.txt

REM This will fail if the path is sort-of correctly set...
FIND /c /i "c:\admintools\;" %TEMP%.\path.txt
If not %ERRORLEVEL%==0 set UPDATE_TYPE=1

REM Note: If \vim\vim72 is in path, this will not add new version to path
REM FIND /c /i "\vim\vim72" %TEMP%.\path.
REM If not %ERRORLEVEL%==0 set /a UPDATE_TYPE=%UPDATE_TYPE%+2
REM Echo "Update_Type = %UPDATE_TYPE%"


REM PUT YOUR CASE STATEMENTS HERE TO SELECT THE PROPER PATH BUILDER
IF %UPDATE_TYPE%==0 goto NOPATHCHANGE
IF %UPDATE_TYPE%==1 goto ADD_ADMINTOOLS
IF %UPDATE_TYPE% GEQ 4 Echo Error parsing Path env variable. This script will exit.
goto :EOF

:NOPATHCHANGE
Echo No change will be made to PATH variable.
goto :EOF

:ADD_ADMINTOOLS
if "%PATH_FINAL_CHAR%"==";" set PATH_EXTENSION=%path%c:\admintools\; 
if not "%PATH_FINAL_CHAR%"==";" set PATH_EXTENSION=%path%;c:\admintools\;
goto :EXTENDPATH



:EXTENDPATH
@echo on
%WINDIR%\system32\setx.exe /m path "%PATH_EXTENSION%"
@echo off
REM END OF EXECUTABLE
goto EOF



REM BEGINNING OF ERROR CODES

:NOTOOLS
Echo Could not find C:\admintools\installers. Please check if dir exists.
goto EOF

:EOF
