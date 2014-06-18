:: 
:: chotu222's Grand Tool
:: File: chotutool.bat
:: Galaxy grand modification tool
::
@echo off
TITLE Grand Tool
java -version
chotu\adb version 
:skip
set proj=None
set heapy=512 
set /A count=0
FOR %%F IN (grand/*.apk) DO (
set /A count+=1
set tmpstore=%%~nF%%~xF
)
if %count%==1 (set proj=%tmpstore%)
cls 
if errorlevel 1 goto errjava
if errorlevel 1 goto erradb
set ignore=0
if %ignore% == 0 (set tmpv=Off) else (set tmpv=On) 
echo -------------------------------------
echo ^| Compression-Level: %usrc% ^| Ignore:%tmpv% ^|
echo -------------------------------------
cls
cls
mode con:cols=80 lines=50
setLocal EnableDelayedExpansion
:restart
COLOR 1F
echo ********************************************************************************
echo 			      Galaxy Grand Tool                                                
echo                               -by chotu222,                                     
echo ********************************************************************************
echo.
echo   THEMING OPTIONS:
echo.
echo    1  Set your current project
echo    2  Install touchwiz framework
echo    3  Decompile apk
echo    4  Compile apk
echo    5  Sign apk/zip
echo    6  Set heap size
echo.
echo   MODDING OPTIONS:
echo.
echo    7  Decompile classes.dex
echo    8  Compile classout to classes.dex
echo.
echo   CM11 OPTIONS:
echo.
echo    e  Enable Dual sim
echo    d  Disable Dual sim
echo.
echo   DEVELOPER OPTIONS:
echo.
echo    9  Create a signed ROM.zip
echo   10  Create a flashable Zip
echo   11  Build Options
echo.
echo   OTHER OPTIONS:
echo.
echo   12  Set up Working folders
echo   13  Clean Up! folders
echo   14  Go to xda page for updates
echo.
echo   ADB OPTIONS:
echo.
echo   21   adb pull apk
echo   22   adb push apk
echo   23   adb logcat
echo.
echo   HELP:
echo.

echo   98   Display How-To
echo   99   Exit  
echo -------------------------------------------------------------------------------
SET menunr=
SET /P menunr=ENTER TASK: 
if '%menunr%'=='' (
cls
goto :restart
)
IF %menunr%==1 (goto curr)
IF %menunr%==2 (goto xframe)
IF %menunr%==3 (goto de)
IF %menunr%==4 (goto comp)
IF %menunr%==5 (goto sign)
IF %menunr%==6 (goto heap)
IF %menunr%==7 (goto dex)
IF %menunr%==8 (goto compdex)
IF %menunr%==9 (goto rom)
IF %menunr%==10 (goto fzip)
IF %menunr%==11 (goto build)
IF %menunr%==12 (goto setup)
IF %menunr%==13 (goto clean)
IF %menunr%==14 (goto xda)
IF %menunr%==21 (goto pull)
IF %menunr%==22 (goto push)
IF %menunr%==23 (goto log) 
IF %menunr%==98 (goto help)
IF %menunr%==99 (goto quit)
IF %menunr%==e  (goto emsim)
IF %menunr%==d  (goto dmsim)
:nope
echo ERROR: Not part of the MENU
PAUSE
cls
goto restart
:setup
echo Setting up folders ...
mkdir fzb
mkdir grand
mkdir database
mkdir signer
mkdir dex
mkdir log
echo Rechecking ....
cd "%~dp0"
echo.
echo.
echo Done ..you are ready to use this tool at will
pause
cls
goto restart
:xda
start http://forum.xda-developers.com/showthread.php?p=42526991
cls
goto restart
:pull
cd chotu
echo Where do you want adb to pull the apk from? 
echo Example of input : /system/app/superuser.apk
set /P INPUT=Type input: %=%
echo Connect your device
adb devices
echo Pulling apk
adb pull %INPUT% "%~dp0adb_workshop\pulled_apks\something.apk"
if errorlevel 1 (
echo "An Error Occured"
PAUSE
goto restart
)
cd ..
cls
goto restart
:push
cd chotu
echo Place the apk you want to push in adb_workshop folder
echo If done press enter!
PAUSE
set /P INPUT=Type name of apk: %=%
echo pushing apk
adb devices
adb push "%~dp0adb_workshop\%INPUT%.apk" /system/app/
if errorlevel 1 (
echo "An Error Occured"
PAUSE
goto restart
)
cd ..
cls
goto restart
:log
cd chotu
echo Connect your device
echo.
echo.
adb devices
adb logcat > "%~dp0log\logcat.txt"
echo.
echo.
echo Wait for 5 seconds! then unpug your device
echo.
echo.
cd ..
PAUSE
goto resrart
:dex
cd chotu
echo NOTE: The before classout/new-classes.dex files will be deleted!
echo Abiding by your decision
echo.
echo y  -Yes,Iam in a whole new project.Delete it!
echo n  -No,wait,let me backup first.
set /P INPUT=Decision: %=%
IF %INPUT%==y (goto ydex)
IF %INPUT%==n (goto ndex)
:ydex
IF EXIST "../database/dex" (rmdir /S /Q "../database/dex%")
ECHO Decompiling dex file
java -jar baksmali.jar -x ../dex/classes.dex -o ../database/dex/classout
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
)
cd ..
cls
goto restart
:ndex
cd ..
cls
goto restart
:compdex
cd chotu
ECHO Compiling dex file
java -Xmx512M -jar smali.jar -x ../database/dex/classout -o ../database/dex/new-classes.dex
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
)
cd ..
cls
goto restart
:curr
cls
set /A count=0
FOR %%F IN (grand/*.apk) DO (
set /A count+=1
set a!count!=%%F
if /I !count! LEQ 9 (echo ^--* !count!  - %%F )
if /I !count! GTR 10 (echo ^--* !count! - %%F )
)
echo.
echo Choose your current project :
set /P INPUT=Enter It's Number: %=%
if /I %INPUT% GTR !count! (goto ash)
if /I %INPUT% LSS 1 (goto ash)
set proj=!a%INPUT%!
goto restart
:ash
set proj=None
goto restart
rem :bins
rem echo Waiting for device
rem adb wait-for-device
rem echo Installing Apks
rem FOR %%F IN ("%~dp0grand\*.apk") DO adb install -r "%%F"
rem goto restart
:de
cd chotu
IF EXIST "../database/%proj%" (rmdir /S /Q "../database/%proj%")
echo Decompiling Apk
java -Xmx512m -jar apktool.jar d "../grand/%proj%" "../database/%proj%"
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
cls
goto restart
:comp
IF NOT EXIST "%~dp0database\%proj%" goto donut
cd chotu
echo.
echo.
echo Is it a system app or installable/normal app
echo.
echo.
echo  1  -System app
echo  2  -Normal app
echo.
SET /P APP=Your Decision: %=%
IF %APP%==1 (goto syscomp)
IF %APP%==2 (goto normcomp)
:syscomp
echo Building Apk
IF EXIST "%~dp0database\OUT\%proj%\unsigned%proj%" (del /Q "%~dp0database\OUT\%proj%\unsigned%proj%")
java -Xmx512m -jar apktool.jar b "../database/%proj%" "%~dp0database\OUT\%proj%\%proj%"
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
echo Done!
cd ..
cls
goto restart
:normcomp
echo building apk
IF EXIST "%~dp0database\OUT\%proj%" (del /Q "%~dp0database\OUT\%proj%")
java -Xmx512m -jar apktool.jar b "../database/%proj%" "%~dp0database\OUT\%proj%\%proj%"
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
echo Done!
echo signing apk
java -Xmx512m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ../database/OUT/%proj%/%proj% ../database/OUT/%proj%/signed_%proj%
cd ..
cls
echo Do you want to delete the previous unsigned zip/apk?
echo.
echo 1 --Yes,delete it!
echo 2 --No,let the both be there.
SET /P OPT=Your decision: %=%
IF %OPT%==1 (goto aopt)
IF %OPT%==2 (goto bopt)
cd ..
cls
goto restart
:aopt
DEL /Q "../database/OUT/%proj%/%proj%"
:bopt
cd ..
cls
goto restart
:xframe
cd chotu
set /P INPUT=Drag and drop framework-res: %=%
ECHO Installing framework
java -jar apktool.jar if %INPUT%
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
)
echo Done!
cd ..
cls
echo Does your ROM have twframework-res.apk?
SET /P menunr=Please make your decision (y/n): 
IF %menunr%==y (goto tw)
IF %menunr%==n (goto none)
:tw
cd chotu
set /P SEMC=Drag and drop twframework-res: %=%
ECHO Installing TW framework
java -jar apktool.jar if %SEMC%
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
)
echo Done!
PAUSE
cd ..
cls
goto restart
:clean
cls
echo Choose which directories you want to clean?
echo.
echo.
echo  1- fzb
echo  2- grand
echo  3- signer
echo  4- All (including database)
:sign
cls
echo Do you want to sign an app or zip file ?
echo.
echo.
echo 1 --App
echo 2 --Zip
SET /P INPUT=Your Decision: %=%
IF %INPUT%==1 (goto sproj)
IF %INPUT%==2 (goto zproj)
:sproj
cls
set /A count=0
FOR %%S IN (signer/*.apk) DO (
set /A count+=1
set a!count!=%%S
if /I !count! LEQ 9 (echo ^--* !count!  - %%S )
if /I !count! GTR 10 (echo ^--* !count! - %%S )
)
echo.
echo Choose app to be signed :
set /P INPUT=Enter It's Number: %=%
if /I %INPUT% GTR !count! (goto ash)
if /I %INPUT% LSS 1 (goto ash)
set flux=!a%INPUT%!
cd chotu
ECHO Signing Apk
java -Xmx512m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ../signer/%flux% ../signer/signed_%flux%
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
)
cd ..
cls
goto signopt
:zproj
cls
set /A count=0
FOR %%Z IN (signer/*.zip) DO (
set /A count+=1
set a!count!=%%Z
if /I !count! LEQ 9 (echo ^--* !count!  - %%Z )
if /I !count! GTR 10 (echo ^--* !count! - %%Z )
)
echo.
echo Choose zip to be signed :
set /P INPUT=Enter It's Number: %=%
if /I %INPUT% GTR !count! (goto ash)
if /I %INPUT% LSS 1 (goto ash)
set flux=!a%INPUT%!
cd chotu
ECHO Signing Zip
java -Xmx1024m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ../signer/%flux% ../signer/signed_%flux%
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
cd ..
cls
goto restart
)
cd ..
cls
echo Do you want to delete the previous unsigned zip/apk?
echo.
echo 1 --Yes,delete it!
echo 2 --No,let the both be there.
SET /P OPT=Your decision: %=%
IF %OPT%==1 (goto copt)
IF %OPT%==2 (goto dopt)

:copt
cd signer
DEL /Q %flux%
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
cd ..
cls
goto restart
)
cd ..
cls
goto  restart
:dopt
cd ..
cls
goto restart
:none
cd chotu
ECHO Then you are ready to go!Theme and mod your Grand at will without any issues :)
cd ..
cls
goto restart
:heap
set /P INPUT=Enter max size for java heap space in megabytes (eg 512) : %=%
set heapy=%INPUT%
cls
goto restart
:prev
cd ..
cls
goto restart
:donut
cls
echo.
echo.
echo.
echo.
echo.
echo The apk does not exist please make sure it is there!
PAUSE
cd ..
cls
goto restart
:rom
cd chotu
cls
echo Place your ROM files in the rom folder (META-INF etc etc)
echo.
echo If already placed
PAUSE
echo Creating ROM.zip file.....
7za a -tzip "../rom/ROM.zip" "../rom/*" -mx5
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
cd ..
cls
goto restart
)
echo Zipping.....
echo Done!
cls
echo Give a name to your ROM zip :
echo.
echo.
SET /P ZIP=Type the name of your rom here: %=%
ren "../rom/ROM.zip" "../rom/%ZIP%.zip
echo rename done!
echo signing zip..
java -Xmx1024m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ../rom/%ZIP%.zip ../database/SIGNED/%ZIP%_signed.zip
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
)
echo removing files...
cd ..
rmdir /S /Q rom > nul
mkdir rom
echo.
echo.
echo Everything was done perfectly ! Your ROM is ready to be flashed.
PAUSE
cls
goto restart
:fzip
mkdir database\Flashable
mkdir fzb\META-INF
mkdir fzb\system
cd chotu
cls
echo WELCOME TO GRAND FLASHABLE ZIP BUILDER
echo --------------------------------------------------------------------------------
echo.
echo.
echo Are your files present in fzb folder,just to confirm!
PAUSE
echo.
echo Alright,generating META-INF...
xcopy META-INF "../fzb/META-INF" /E
7za a -tzip "../fzb/FLASH.zip" "../fzb/*" -mx5
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
cd ..
cls
goto restart
)
echo Zipping.....
echo Done!
cls
echo Give a name to your flashable zip :
echo.
echo.
SET /P FZIP=Type the name of your rom here: %=%
ren "../fzb/FLASH.zip" "../fzb/%FZIP%.zip
echo rename done!
echo signing zip..
java -Xmx1024m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ../fzb/%FZIP%.zip ../database/Flashable/%FZIP%_signed.zip
IF errorlevel 1 (
ECHO "An Error Occured"
PAUSE
)
echo removing files...
cd ..
rmdir /S /Q fzb > nul
mkdir fzb
echo.
echo.
echo Everything was done perfectly ! Your zip is ready to be flashed.
echo.
echo.
echo You can find your zip in your database/Flashable folder.
PAUSE
cls
goto restart
:build
cls
COLOR F0
echo ********************************************************************************
echo 		       This option is under construction
echo                           and will be available soon                                              
echo.                                                                    
echo ********************************************************************************
echo.
echo.
echo   1  Set up a Project folder
echo   2  Later
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo. 
echo --------------------
echo   x   Previous menu
echo   99  Exit
echo --------------------
echo -------------------------------------------------------------------------------
SET menunr=
SET /P menunr=ENTER TASK: 
if '%menunr%'=='' (
cls
goto build
)
IF %menunr%==1 (goto pf)
IF %menunr%==x (goto bres)
IF %menunr%==99 (goto quit)
:bres
cd ..
cls
goto restart
:help
cls
echo.
echo HOW TO USE:
echo --* Double click grandtool.bat
echo.
echo.
echo HELP:
echo --* To sign apk or ROM.zip files,place apk/zip files in signer folder.
echo --* Database folder is your project home :)
echo --* For more info. read guide.txt
echo.
echo CREDITS:
echo --* AUTHOR : chotu222
echo --* XDA for the knowledge I gained
pause
cls
goto restart
:emsim
cls
cd chotu
echo Connect your device
echo Ensure that adb debugging is enabled in your device
echo If not enable it and Allow your pc to use adb
PAUSE
echo Connecting..
adb devices
echo Taking superuser rights from your device ..
su
setprop persist.radio.multisim.config dsds
echo Done
PAUSE
goto resrart
:errjava
cls
echo Java was not found, you will not be able to sign apks or use apktool
PAUSE
goto restart
:quit
exit