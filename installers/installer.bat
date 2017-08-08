@echo off
REM **
REM This file should only be run once, after the admintools.exe file
REM is installed. Please be aware that this batch file assumes
REM the admintools.exe file was installed to c:\admintools\. It will
REM terminate if the path is different.
REM **

setx /m SC_ADMINTOOLS_VERSION "2.13"

if exist c:\admintools\installers cd c:\admintools\installers
echo. 
echo.
echo Select an installation mode:
echo - [F]ull - runs the Sysinternals EULA and changes desktop background for the logged in user; sets the path variable
echo - [Q]uick - sets the path variable and clears out old installers
:input
set INPUT=F
echo. 
set /P INPUT=[Q]uick or [F]ull? (default is [F]ull): %=%

if "%INPUT%"=="" goto full_install
if "%INPUT%"=="f" goto full_install
if "%INPUT%"=="F" goto full_install
if "%INPUT%"=="Q" goto quick_install
if "%INPUT%"=="q" goto quick_install

REM else -> no acceptable input detected - go back to 'input'
echo Please enter one of the following characters: Q/F/q/f
goto input

:full_install
if exist AcceptEULA.hta call AcceptEULA.hta
if exist set_bginfo.bat call set_bginfo.bat
:quick_install
if exist extend_path.bat call extend_path.bat
REM if exist clear_installers.bat call clear_installers.bat

REM echo Verify the PATH variable:
REM echo %PATH%
REM echo .
REM echo .
REM pause

REM echo .
REM echo Complete. Verify the contents of this 'dir' output
REM dir %WINDIR%\Tasks
REM echo .
REM echo .
REM echo .
REM pause



