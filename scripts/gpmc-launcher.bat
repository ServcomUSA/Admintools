@ECHO OFF
cd c:\windows\system32

runas /netonly /user:%1 "mmc.exe gpmc.msc"
cd c:\dev\admintools\scripts\

