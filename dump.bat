:: MIT License

:: Copyright (c) 2017 AvinashSingh

:: Permission is hereby granted, free of charge, to any person obtaining a copy
:: of this software and associated documentation files (the "Software"), to deal
:: in the Software without restriction, including without limitation the rights
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
:: copies of the Software, and to permit persons to whom the Software is
:: furnished to do so, subject to the following conditions:

:: The above copyright notice and this permission notice shall be included in all
:: copies or substantial portions of the Software.

:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
:: SOFTWARE.

::   _______                        ______                                 __                     
::  |       \                      /      \                               |  \                    
::  | $$$$$$$\  ______    ______  |  $$$$$$\  _______   ______   __    __  \$$  ______    ______  
::  | $$__| $$ /      \  /      \ | $$__| $$ /       \ /      \ |  \  |  \|  \ /      \  /      \ 
::  | $$    $$|  $$$$$$\|  $$$$$$\| $$    $$|  $$$$$$$|  $$$$$$\| $$  | $$| $$|  $$$$$$\|  $$$$$$\
::  | $$$$$$$\| $$    $$| $$  | $$| $$$$$$$$| $$      | $$  | $$| $$  | $$| $$| $$   \$$| $$    $$
::  | $$  | $$| $$$$$$$$| $$__| $$| $$  | $$| $$_____ | $$__| $$| $$__/ $$| $$| $$      | $$$$$$$$
::  | $$  | $$ \$$     \ \$$    $$| $$  | $$ \$$     \ \$$    $$ \$$    $$| $$| $$       \$$     \
::   \$$   \$$  \$$$$$$$ _\$$$$$$$ \$$   \$$  \$$$$$$$  \$$$$$$$  \$$$$$$  \$$ \$$        \$$$$$$$
::                      |  \__| $$                          | $$                                  
::                       \$$    $$                          | $$                                  
::                        \$$$$$$                            \$$          
::																				BY Avinash Singh	


@echo off
cls
title RegAcquire
::mode con:cols=114 lines=40


setlocal enableDelayedExpansion

echo Detecting system setup ...
set /A STD_OUTPUT_HANDLE=-11
set /A ENABLE_PROCESSED_OUTPUT=1, ENABLE_WRAP_AT_EOL_OUTPUT=2, ENABLE_VIRTUAL_TERMINAL_PROCESSING=4

PowerShell  ^
   $GetStdHandle = Add-Type 'A' -PassThru -MemberDefinition '  ^
      [DllImport(\"Kernel32.dll\")]  ^
      public static extern IntPtr GetStdHandle(int nStdHandle);  ^
   ';  ^
   $GetConsoleMode = Add-Type 'B' -PassThru -MemberDefinition '  ^
      [DllImport(\"Kernel32.dll\")]  ^
      public static extern bool GetConsoleMode(IntPtr hWnd, ref UInt32 lpMode);  ^
   ';  ^
   $StdoutHandle = $GetStdHandle::GetStdHandle(%STD_OUTPUT_HANDLE%);  ^
   $ConsoleMode = New-Object -TypeName UInt32;  ^
   $null = $GetConsoleMode::GetConsoleMode($StdoutHandle,[ref]$ConsoleMode);  ^
   Set-Content ConsoleMode.txt $ConsoleMode  ^
%End PowerShell%

set /P "ConsoleMode=" < ConsoleMode.txt"
set /A "AnsiCompatible=ConsoleMode & ENABLE_VIRTUAL_TERMINAL_PROCESSING"
if %AnsiCompatible% neq 0 (
   echo The console is Ansi-compatible!
   set RED=[41m
   set RESET=[0m
   set GREEN=[32m
   set YELLOW=[33m
   set CYAN=[36m
   set MAGENTA=[35m
   set UNDERLINE=[4m
   set BOLD=[1m
) else (
   echo Ansi codes not supported...
)

REM set MYFILES=%cd%

set tabln=			
set STATUS=0

For /f "tokens=1,2,3,4,5 delims=/. " %%a in ('date/T') do set d=%%a-%%b-%%c%%d
REM For /f "tokens=1,2,3 delims=:" %%f in ('time /t') do set t=%%f:%%g:%%h
set t=%TIME:~0,6%
for /f "skip=1 delims=" %%A in (
   'wmic computersystem get name'
) do for /f "delims=" %%B in ("%%A") do set compName=%%A

call:log >> evidence.log
echo =^> [START] -- Program was initiated >> evidence.log

set folder=%USERNAME%_%compName%_%d%\original
set folderSession=%USERNAME%_%compName%_%d%
set folderSession=%folderSession: =%
set folder=%folder: =%

echo ==============================================================================================================
echo    _______                        ______                                 __                     
echo   ^|       ^\                      ^/      ^\                               ^|  ^\                    
echo   ^| $$$$$$$^\  ______    ______  ^|  $$$$$$^\  _______   ______   __    __  ^\$$  ______    ______  
echo   ^| $$__^| $$ ^/      ^\  ^/      ^\ ^| $$__^| $$ ^/       ^\ ^/      ^\ ^|  ^\  ^|  ^\^|  ^\ ^/      ^\  ^/      \ 
echo   ^| $$    $$^|  $$$$$$^\^|  $$$$$$^\^| $$    $$^|  $$$$$$$^|  $$$$$$^\^| $$  ^| $$^| $$^|  $$$$$$^\^|  $$$$$$^\
echo   ^| $$$$$$$^\^| $$    $$^| $$  ^| $$^| $$$$$$$$^| $$      ^| $$  ^| $$^| $$  ^| $$^| $$^| $$   ^\$$^| $$    $$
echo   ^| $$  ^| $$^| $$$$$$$$^| $$__^| $$^| $$  ^| $$^| $$_____ ^| $$__^| $$^| $$__^/ $$^| $$^| $$      ^| $$$$$$$$
echo   ^| $$  ^| $$ ^\$$     ^\ ^\$$    $$^| $$  ^| $$ ^\$$     ^\ ^\$$    $$ ^\$$    $$^| $$^| $$       ^\$$     ^\
echo    ^\$$   ^\$$  ^\$$$$$$$ _^\$$$$$$$ ^\$$   ^\$$  ^\$$$$$$$  ^\$$$$$$$  ^\$$$$$$  ^\$$ ^\$$        ^\$$$$$$$
echo                       ^|  ^\__^| $$                          ^| $$                                  
echo                        ^\$$    $$                          ^| $$                                  
echo                         ^\$$$$$$                            ^\$$          
echo				 																							-- BY %CYAN%%BOLD%Avinash Singh%RESET%
echo ===============================================================================================================

echo.
echo.
echo.
echo 			%YELLOW%%UNDERLINE%%BOLD%Welcome to the Windows Registry Acqusition Tool, RegAcquire %RESET%
echo.
echo.
echo.
echo -- Please be patient as this may take a while
echo.
echo.
echo -- Session started at: %YELLOW%%BOLD%%d% %t%%RESET%
echo. 

set deltime= %TIME:~0,8%
set deltime=%deltime::=_%


IF exist "dumps\%folder%" (
	call:log >> evidence.log
	echo =^> [INFO] -- Found dumps for machine requesting overwrite >> evidence.log
	echo Found Dumps for this machine for today already
	set OVERWRITE="y"
	set /p OVERWRITE= "Overwrite (Y/N)? "
	echo !OVERWRITE!


	IF /I "!OVERWRITE!" EQU "n" (
		call:log >> evidence.log
		echo =^> [INFO] -- User chose to ^not overwrite dumps, exiting >> evidence.log
		echo.
		echo.
		echo.
		echo ==========================================
		echo -- Session ended at: 
		call:log
		echo.
		echo ==========================================
		echo.
		echo.


		call:log >> evidence.log
		echo =^> [END] -- Successfully ended session >> evidence.log
		pause
		EXIT /B 0
		)

	IF /I "!OVERWRITE!" EQU "y" (
		call:log >> evidence.log
		echo =^> [INFO] -- User chose to overwrite dumps, deleting dumps >> evidence.log
	
		set fulltime=%DATE%%TIME:~0,8%
	
		mkdir "Deleted\%d%%deltime%"
		echo In case you didn't want to delete, it will be stored in the [Deleted/%d%%deltime%] folder
		echo.
		move /Y "dumps/%folderSession%" "Deleted\%d%%deltime%"
		
		call:log >> evidence.log
		echo =^> [INFO] -- Backup made of deleted files in Deleted\%d%%deltime%  >> evidence.log
		
		)
	)













IF not exist "dumps\%folder%" mkdir "dumps\%folder%"


echo Dumps for this session will be saved in the %YELLOW%'dumps\%folder%' folder%RESET%
echo.
echo.
call:log >> evidence.log
echo =^> [INFO] -- Folder for dumps: 'dumps\%folder%'  >> evidence.log
 

echo *Acquiring Hive [HKEY_CLASSES_ROOT]
reg export HKEY_CLASSES_ROOT "dumps\%folder%\HKEY_CLASSES_ROOT.regacquire"  
IF errorlevel 1 (
	echo|set /p="%tabln%[%RED%Failed%RESET%] to retrieve HKEY_CLASSES_ROOT"
	call:log >> evidence.log
	echo =^> [ERROR] -- Failed to retrieve HKEY_CLASSES_ROOT  >> evidence.log
	set STATUS=1
	)
IF errorlevel 0 ( 
	echo|set /p=" %tabln%[%GREEN%SUCCESS%RESET%] retrieved HKEY_CLASSES_ROOT"
	call:log >> evidence.log
	echo =^> [SUCCESS] -- Successfully retrieved HKEY_CLASSES_ROOT  >> evidence.log
	)
call:log > "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\HKEY_CLASSES_ROOT.regacquire" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\HKEY_CLASSES_ROOT.regacquire" | findstr /B /R [a-f0-9] >> hash.hash
echo %tabln%[%GREEN%SUCCESS%RESET%] Generated hash for HKEY_CLASSES_ROOT
call:log >> evidence.log
echo =^> [SUCCESS] -- Generated hash for HKEY_CLASSES_ROOT  >> evidence.log


echo.
echo.
echo *Acquiring Hive [HKEY_CURRENT_USER]
reg export HKEY_CURRENT_USER "dumps\%folder%\HKEY_CURRENT_USER.regacquire"  
IF errorlevel 1 ( 
	echo %tabln%[%RED%Failed%RESET%] to retrieve HKEY_CURRENT_USER
	call:log >> evidence.log
	echo =^> [ERROR] -- Failed to retrieve HKEY_CURRENT_USER  >> evidence.log
	set STATUS=1
	)
IF errorlevel 0 ( 
	echo|set /p="%tabln%[%GREEN%SUCCESS%RESET%] retrieved HKEY_CURRENT_USER"
	call:log >> evidence.log
	echo =^> [SUCCESS] -- Successfully retrieved HKEY_CURRENT_USER  >> evidence.log
	)
call:log >> "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\HKEY_CURRENT_USER.regacquire" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\HKEY_CURRENT_USER.regacquire" | findstr /B /R [a-f0-9] >> hash.hash
echo %tabln%[%GREEN%SUCCESS%RESET%] Generated hash for HKEY_CURRENT_USER
call:log >> evidence.log
echo =^> [SUCCESS] -- Generated hash for HKEY_CURRENT_USER  >> evidence.log


echo.
echo.
echo *Acquiring Hive [HKEY_LOCAL_MACHINE]
reg export HKEY_LOCAL_MACHINE "dumps\%folder%\HKEY_LOCAL_MACHINE.regacquire"  
IF errorlevel 1 (
	echo %tabln%[%RED%Failed%RESET%] to retrieve HKEY_LOCAL_MACHINE
	call:log >> evidence.log
	echo =^> [ERROR] -- Failed to retrieve HKEY_LOCAL_MACHINE  >> evidence.log
	set STATUS=1
	)
IF errorlevel 0 (
	echo|set /p="%tabln%[%GREEN%SUCCESS%RESET%] retrieved HKEY_LOCAL_MACHINE"
	call:log >> evidence.log
	echo =^> [SUCCESS] -- Successfully retrieved HKEY_LOCAL_MACHINE  >> evidence.log
	)
call:log >> "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\HKEY_LOCAL_MACHINE.regacquire" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\HKEY_LOCAL_MACHINE.regacquire" | findstr /B /R [a-f0-9] >> hash.hash
echo %tabln%[%GREEN%SUCCESS%RESET%] Generated hash for HKEY_LOCAL_MACHINE
call:log >> evidence.log
echo =^> [SUCCESS] -- Generated hash for HKEY_LOCAL_MACHINE  >> evidence.log


echo.
echo.
echo *Acquiring Hive [HKEY_USERS]
reg export HKEY_USERS "dumps\%folder%\HKEY_USERS.regacquire"  
IF errorlevel 1 ( 
	echo %tabln%[%RED%Failed%RESET%] to retrieve HKEY_USERS
	call:log >> evidence.log
	echo =^> [ERROR] -- Failed to retrieve HKEY_USERS  >> evidence.log
	set STATUS=1
	)
IF errorlevel 0 ( 
	echo|set /p="%tabln%%tabln%[%GREEN%SUCCESS%RESET%] retrieved HKEY_USERS"
	call:log >> evidence.log
	echo =^> [SUCCESS] -- Successfully retrieved HKEY_USERS  >> evidence.log
	)
call:log >> "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\HKEY_USERS.regacquire" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\HKEY_USERS.regacquire" | findstr /B /R [a-f0-9] >> hash.hash
echo %tabln%        [%GREEN%SUCCESS%RESET%] Generated hash for HKEY_USERS
call:log >> evidence.log
echo =^> [SUCCESS] -- Generated hash for HKEY_USERS  >> evidence.log


echo.
echo.
echo *Acquiring Hive [HKEY_CURRENT_CONFIG]
reg export HKEY_CURRENT_CONFIG "dumps\%folder%\HKEY_CURRENT_CONFIG.regacquire"  
IF errorlevel 1 (
	echo %tabln%[%RED%Failed%RESET%] to retrieve HKEY_CURRENT_CONFIG
	call:log >> evidence.log
	echo =^> [ERROR] -- Failed to retrieve HKEY_CURRENT_CONFIG  >> evidence.log
	set STATUS=1
	)
IF errorlevel 0 ( 
	echo |set /p="%tabln%[%GREEN%SUCCESS%RESET%] retrieved HKEY_CURRENT_CONFIG"
	call:log >> evidence.log
	echo =^> [SUCCESS] -- Successfully retrieved HKEY_CURRENT_CONFIG  >> evidence.log
	)
call:log >> "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\HKEY_CURRENT_CONFIG.regacquire" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\HKEY_CURRENT_CONFIG.regacquire" | findstr /B /R [a-f0-9] >> hash.hash
echo %tabln%[%GREEN%SUCCESS%RESET%] Generated hash for HKEY_CURRENT_CONFIG
call:log >> evidence.log
echo =^> [SUCCESS] -- Generated hash for HKEY_CURRENT_CONFIG  >> evidence.log



echo.
echo.
echo *Acquiring Hive files
RawCopy.exe /FileNamePath:"%SystemRoot%\System32\config\SYSTEM" /OutputPath:"dumps\%folder%\" 
call:log >> "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\SYSTEM" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\SYSTEM" | findstr /B /R [a-f0-9] >> hash.hash


RawCopy.exe /FileNamePath:"%userprofile%\NTUSER.DAT" /OutputPath:"dumps\%folder%\"
call:log >> "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\NTUSER.DAT" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\NTUSER.DAT" | findstr /B /R [a-f0-9] >>  hash.hash 


RawCopy.exe /FileNamePath:"%SystemRoot%\System32\config\SAM" /OutputPath:"dumps\%folder%\" 
call:log >> "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\SAM" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\SAM" | findstr /B /R [a-f0-9] >> hash.hash


RawCopy.exe /FileNamePath:"%SystemRoot%\System32\config\SECURITY" /OutputPath:"dumps\%folder%\" 
call:log >> "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\SECURITY" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\SECURITY" | findstr /B /R [a-f0-9] >> hash.hash


RawCopy.exe /FileNamePath:"%SystemRoot%\System32\config\SOFTWARE" /OutputPath:"dumps\%folder%\" 
call:log >> "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\SOFTWARE" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\SOFTWARE" | findstr /B /R [a-f0-9] >> hash.hash


RawCopy.exe /FileNamePath:"%SystemRoot%\System32\config\DEFAULT" /OutputPath:"dumps\%folder%\" 
call:log >> "dumps\%folder%\hash.hash"
call:log >> hash.hash
fciv.exe -md5 "dumps\%folder%\DEFAULT" | findstr /B /R [a-f0-9] >> "dumps\%folder%\hash.hash"
fciv.exe -md5 "dumps\%folder%\DEFAULT" | findstr /B /R [a-f0-9] >> hash.hash
 
call:log >> evidence.log
echo =^> [SUCCESS] -- Generated hash for Hive Files  >> evidence.log

echo.
echo. 
echo %MAGENTA%[*] Making forensic copy%RESET%
echo.
cd "dumps\%folder%"
xcopy /y * ..
 
REM icacls hash.hash /inheritance:r /grant everyone:RX
cd ..\..\.. 
call:log >> evidence.log
echo =^> [SUCCESS] -- Created forensic sound copy  >> evidence.log
echo.
echo [%GREEN%SUCCESS%RESET%] Successfully created forensic copy
echo.
echo.



echo %MAGENTA%[*] Veryfying forensic copy%RESET%
echo.
set /A i=0
FOR /f "usebackq tokens=1,2,3 delims= " %%a in ("dumps\%folder%\hash.hash") do (
	call set /A i+=1
	call set orig[!i!]=%%c
	call set n=%%i%%
	)

set verify[0]=False
set verify[1]=False
set verify[2]=False
set verify[3]=False
set verify[4]=False

set verify[5]=False
set verify[6]=False
set verify[7]=False
set verify[8]=False
set verify[9]=False
set verify[10]=False

::for /L %%i in (1,1,!n!) do echo !orig[%%i]!
for /L %%i in (1,1,!n!) do (

	if %%i EQU 1 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\HKEY_CLASSES_ROOT.regacquire" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified HKEY_CLASSES_ROOT
			set verify[0]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy HKEY_CLASSES_ROOT%RESET%
			)
		echo.
	)
 
	if %%i EQU 2 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\HKEY_CURRENT_USER.regacquire" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified HKEY_CURRENT_USER
			set verify[1]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy HKEY_CURRENT_USER%RESET%
			)
		echo.
	)

	if %%i EQU 3 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\HKEY_LOCAL_MACHINE.regacquire" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified HKEY_LOCAL_MACHINE
			set verify[2]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy HKEY_LOCAL_MACHINE%RESET%
			)
		echo.
		)

	if %%i EQU 4 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\HKEY_USERS.regacquire" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified HKEY_USERS
			set verify[3]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy HKEY_USERS%RESET%
			)
		echo.
	)

	if %%i EQU 5 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\HKEY_CURRENT_CONFIG.regacquire" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified HKEY_CURRENT_CONFIG
			set verify[4]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy HKEY_CURRENT_CONFIG%RESET%
			)
		echo.
	)




	if %%i EQU 6 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\SYSTEM" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified SYSTEM
			set verify[0]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy SYSTEM%RESET%
			)
		echo.
	)

	if %%i EQU 7 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\NTUSER.DAT" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified NTUSER.DAT
			set verify[0]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy NTUSER.DAT
			)
		echo.
	)

	if %%i EQU 8 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\SAM" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified SAM
			set verify[0]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy SAM%RESET%
			)
		echo.
	)

	if %%i EQU 9 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\SECURITY" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified SECURITY
			set verify[0]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy SECURITY%RESET%
			)
		echo.
	)

	if %%i EQU 10 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\SOFTWARE" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified SOFTWARE
			set verify[0]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy SOFTWARE%RESET%
			)
		echo.
	)

	if %%i EQU 11 (
		for /f %%x in ('fciv.exe -md5 "dumps\%folderSession%\DEFAULT" ^| findstr /B /R [a-f0-9]') do set copy=%%x
		echo !copy!
		echo !orig[%%i]!
		if !copy! EQU !orig[%%i]! (
			echo %GREEN%[+]%RESET% Verified DEFAULT
			set verify[0]=True
			)
		if !copy! NEQ !orig[%%i]! (
			echo %RED%[X]%RESET% Failed to verifiy DEFAULT%RESET%
			)
		echo.
	)


)

 for /L %%i in (0,1,4) do (
 	if !verify[%%i]! EQU False (
 		set STATUS=1
 		echo.
 		echo %RED%Failed to verify the forensic copy, Please run the program again and overwrite%RESET%
 		echo.
 		call:log >> evidence.log
		echo =^> [ERROR] -- Failed to verify forensic copy  >> evidence.log
		pause
	 	goto :eof
 		)
 	)




IF %STATUS%==1 (
	echo Completed with ERRORS please run the Tool again.
	)

 IF %STATUS%==0 (
	echo %GREEN%
	echo  ___ _   _  ___ ___ ___  ___ ___ 
	echo ^/ __^| ^| ^| ^|^/ __^/ __^/ _ ^\^/ __^/ __^|
	echo ^\__ ^\ ^|_^| ^| (_^| (_^|  __^/^\__ ^\__ ^\
	echo ^|___^/^\__,_^|^\___^\___^\___^|^|___^/___^/
	echo %RESET%	
	)

if exist icon.ico xcopy icon.ico "dumps\%folderSession%" /h /r /y 1>nul
if exist desktop.ini xcopy desktop.ini "dumps\%folderSession%" /h /r /y 1>nul
cd "dumps\%folderSession%"

:: ECHO [.ShellClassInfo] > desktop.ini
:: ECHO ConfirmFileOp=0 >> desktop.ini
:: ECHO NoSharing=1 >> desktop.ini
:: ECHO IconFile=icon.ico >> desktop.ini
:: ECHO IconIndex=0 >> desktop.ini
:: ECHO InfoTip="RegAcquire folder" >> desktop.ini
:: ECHO IconResource=icon.ico,0 >> desktop.ini
:: echo [ViewState] >> desktop.ini
:: echo Mode= >> desktop.ini
:: echo Vid= >> desktop.ini
:: echo FolderType=Documents >> desktop.ini
attrib +r * /s
attrib +h desktop.ini
attrib +h icon.ico
cd ..
attrib +r %folderSession%
cd ..


echo.
echo.
echo.
echo ==========================================
echo -- Session ended at: %BOLD%
call:log
echo.	
echo %RESET%==========================================
echo.
echo.
echo.

call:log >> evidence.log
echo =^> [END] -- Successfully ended session >> evidence.log

pause
:: functions
:log
For /f "tokens=1,2,3,4,5 delims=/. " %%a in ('date/T') do set d=%%a-%%b-%%c%%d
set t=%TIME:~0,8%
echo|set /p=%d% %t% 
EXIT /B 0


endlocal
pause
