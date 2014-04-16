REM "Name: 		Check Server Stats"
REM "Author: 	drag00n"
REM "Purpose:	This bat script asks the user what type of server that they are validating and
				then checks the selected server system information 
				It also checks for: SPN settings for a user account, UAC, and roles installed. 
				The roles installed command only works on Windows 2008 boxes and newer."

@echo off
:Select
cls
set /p Selection=Enter 1 = DATA, 2 = WEB^>
if "%Selection%"=="1" goto :DATA
if "%Selection%"=="2" goto :WEB

:DATA

REM Check OS,Version, BitInfo, Processor Count, and Total Memory Installed
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Processor(s):" /C:"Total Physical Memory"

REM Check SQL Edition
REM "This command queries the registry files and outputs the SQL server edition"
echo "SQL Server Edition"
reg query "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10.MSSQLSERVER\Setup" |findstr Edition

REM Check SQL Version
REM "This command queries the registry files and outputs the SQL server version"
echo "SQL Server Version"
reg query "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10.MSSQLSERVER\Setup" |findstr Version

REM Check SQL Collation
REM "This command queries the registry files and outputs the SQL server collation"
echo "SQL Server Collation"
reg query "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10.MSSQLSERVER\Setup" |findstr Collation

REM Check Server Roles
REM "This command with query all roles on the local machine and will mark all installed roles with an X"
servermanagercmd.exe -query roles


REM Disable UAC
C:\Windows\System32\cmd.exe /k %windir%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

pause
goto :eof

:WEB/APP
REM Check OS,Version, BitInfo, Processor Count, and Total Memory Installed
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Processor(s):" /C:"Total Physical Memory"

REM Check SPN
REM "Enter in the service account name. Look for the HOST on the web box to prove that SPN has been set."
REM set /P servname= Enter the name of the service account
REM setspn -L %servname%

REM IIS Version
REM "This command checks to see if the IIS service is installed and outputs the version."
echo "IIS Version"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" |findstr "VersionString"

REM Java Version
echo "Java Version"
REM "This command with check the version of Java installed"
java -version

REM Check Server Roles
REM "This command with query all roles on the local machine and will mark all installed roles with an X"
servermanagercmd.exe -query roles

REM Disable UAC
C:\Windows\System32\cmd.exe /k %windir%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
pause
goto :eof