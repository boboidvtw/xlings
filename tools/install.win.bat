@echo off

set XLINGS_BIN_DIR=C:\Users\Public\.xlings_data\bin

set arg1=%1

echo [xlings]: start detect environment and try to auto config...

REM Check if xmake is installed
where xmake >nul 2>&1

IF %ERRORLEVEL% EQU 0 (
    echo [xlings]: xmake installed
) else (
    REM xmake is not installed, downloading and running install script using PowerShell
    echo [xlings]: start install xmake...
    powershell -Command "Invoke-Expression ((Invoke-WebRequest 'https://xmake.io/psget.text' -UseBasicParsing).Content)"
)

REM 2. set xlings to PATH
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Environment" /v PATH') do set UserPath=%%b
echo %UserPath% | findstr /i "xlings_data" >nul
if %errorlevel% neq 0 (
    echo [xlings]: set xlings to PATH
    setx PATH "%XLINGS_BIN_DIR%;%UserPath%"
) else (
    echo [xlings]: xlings is already in PATH.
)

if exist "%cd%/install.win.bat" (
    cd ..
)

set "PATH=%XLINGS_BIN_DIR%;%PATH%"

REM 3. install xlings
cd core
xmake xlings unused install xlings
REM 4. install xvm
xmake xlings unused install xvm -y
cd ..

REM 5. config xlings
xvm add xim 0.0.2 --alias "xlings install"
xvm add xinstall 0.0.2 --alias "xlings install"
xvm add xrun 0.0.2 --alias "xlings run"
xvm add xchecker 0.0.2 --alias "xlings checker"


REM 6. install info
echo [xlings]: xlings installed
echo.
echo     run xlings help get more information
echo.

REM 5. update env
REM if "%arg1%"=="disable_reopen" (
REM    echo [xlings]: cmd - disable reopen
REM ) else (
REM    REM update env by start cmd : TODO disable version info /Q?
REM    cmd
REM )