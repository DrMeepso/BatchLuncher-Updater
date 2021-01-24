@echo off
:: =========================================
:: This is the config for the luncher
:: =========================================
:: Whats The Name Of The Game?
set gamename=<GameName>
:: EXE file WITH .exe
set gameexe=<EXEName>.exe
:: URL of the website that hosts GameVer.txt & .zip
set url=<Website>/<Page>
:: Zip file name WITHOUT .zip
set zipname=<Zipname>
:: =========================================

:: Do not change any of this code
:FileStart
set dependincyURL=https://raw.githubusercontent.com/DrMeepso/GameLuncherDependincys/main/
color 0f
set OGDIR=%cd%
title %gamename% Luncher

echo Downloading dependencies
if not exist batbot.exe Curl -L "%dependincyURL%batbox.exe" --output "batbox.exe" --progress-bar
if not exist GetInput.exe Curl -L "%dependincyURL%GetInput.exe" --output "GetInput.exe" --progress-bar
if not exist Button.bat Curl -L "%dependincyURL%Button.bat" --output "Button.bat" --progress-bar
Batbox /c 7
Batbox /h 0

@Mode 48,15
if not exist CurGameVer.txt @echo 0 >> CurGameVer.txt

powershell -Command "(New-Object Net.WebClient).DownloadFile('%url%/GameVer.txt', 'GameVer.txt')"
Echo Checking Game Version
:CheckGameVer
set /p OnlineGameVer=<GameVer.txt
set /p DownloadedGameVer=<CurGameVer.txt
del GameVer.txt
if %OnlineGameVer%==%DownloadedGameVer% goto :UpToDate
if exist %zipname% (goto :loop) else (goto :loop1)
:loop+
cls
echo %gamename% Is Not Up To Date!
echo Would you like to update the game?
Call Button  12 4 " Yes " 26 4 " No " # Press
Getinput /m %Press% /h 70 
if %errorlevel%==1 (goto :yes)
if %errorlevel%==2 (goto :UpToDate)
goto Loop

:loop1
echo Would you like to install %gamename%?
Call Button  12 4 " Yes " 26 4 " No " # Press
Getinput /m %Press% /h 70 
if %errorlevel%==1 (goto :yes)
if %errorlevel%==2 (exit)
goto Loop1

:yes
color 0f
Batbox /c 7
cls
if exist %zipname% (echo Your Game Will Update In 5 Seconds) else (echo Your Game Will Install In 5 Seconds)
echo Or Press Any Key To Continue!
timeout 5 > nul
cls
if exist %zipname% (echo Updating) else (echo Installing)
timeout /T 1 /NOBREAK > nul
Batbox /c 240
echo Downloading Game Files
echo This May Take A Minute!
Batbox /c 7
if exist %zipname% rmdir %zipname% /S /Q
Curl "%url%/%zipname%.zip" --output "%zipname%.zip" --progress-bar
cls
echo Dont Worry About The Blue
echo Its Just Expanding The Games Archive
powershell Expand-Archive %zipname%.zip -Force
goto :bubble
:Retrun
del CurGameVer.txt
del %zipname%.zip
@echo %OnlineGameVer% >> CurGameVer.txt
Batbox /c 10
echo Done!
Batbox /c 7
timeout /T 1 /NOBREAK > nul
goto :CheckGameVer

:UpToDate
cls
if %OnlineGameVer%==%DownloadedGameVer% Batbox /c 10
if %OnlineGameVer%==%DownloadedGameVer% echo %gamename% Is Up To Date
if %OnlineGameVer%==%DownloadedGameVer% echo And Ready To Play!
if not %OnlineGameVer%==%DownloadedGameVer% echo %gamename% Is Not Up To Date!
if not %OnlineGameVer%==%DownloadedGameVer% echo But Ready To Play!
Batbox /c 7
:loop2
if not %OnlineGameVer%==%DownloadedGameVer% (Call Button  11 4 " Play " 26 4 " Exit " 32 12 " Uninstall "  0 12 " Update " # Press) else (Call Button  11 4 " Play " 26 4 " Exit " 32 12 " Uninstall " # Press)
Getinput /m %Press% /h 70 
if %errorlevel%==1 (goto :start)
if %errorlevel%==2 (exit)
if %errorlevel%==3 (goto :uninstall)
if %errorlevel%==4 (goto :loop)
goto Loop2
:start
cd ./%zipname%
start %gameexe%
exit

:uninstall
cls
:loop3
Batbox /c 240
echo Are you sure you want to
echo uninstall %gamename%?
Batbox /c 7
Call Button  12 4 " No " 26 4 " Yes " # Press
Getinput /m %Press% /h 70 
if %errorlevel%==1 (goto :UpToDate)
if %errorlevel%==2 (goto :uninstall2)
goto Loop3
:uninstall2
echo.
echo.
rmdir %zipname% /S /Q
del CurGameVer.txt
timeout /T 1 /NOBREAK > nul
echo %gamename% has been uninstalled
timeout /T 3 /NOBREAK > nul
exit


:bubble
Curl -L "%dependincyURL%Icon.ico" --output "Icon.ico" > nul
@echo [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") >> Bubble.ps1
@echo $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon >> Bubble.ps1
@echo $objNotifyIcon.Icon = "Icon.ico" >> Bubble.ps1
@echo $objNotifyIcon.BalloonTipIcon = "None" >> Bubble.ps1
@echo $objNotifyIcon.BalloonTipText = "%gamename% Has Finished Downloading!" >> Bubble.ps1
@echo $objNotifyIcon.BalloonTipTitle = "%gamename% Updater" >> Bubble.ps1
@echo $objNotifyIcon.Visible = $True >> Bubble.ps1
@echo $objNotifyIcon.ShowBalloonTip(400) >> Bubble.ps1
powershell -executionpolicy bypass -file Bubble.ps1
del Bubble.ps1
del Icon.ico
goto :Retrun
