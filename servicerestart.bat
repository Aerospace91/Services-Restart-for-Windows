@echo off
setlocal ENABLEEXTENSIONS

REM === Configurable Variables ===
set "SERVICE=spooler"
set "LOGFILE=%~dp0service_restart.log"
set "INITIAL_WAIT_SEC=300"
set "WAIT_INTERVAL_SEC=5"
set "MAX_WAIT_ITER=36"   

REM 36*5=180 seconds max wait for stop

REM === Log Script Start ===
echo [%date% %time%] Script started. Waiting %INITIAL_WAIT_SEC% seconds before restart. >> "%LOGFILE%"

REM === Initial Wait ===
timeout /t %INITIAL_WAIT_SEC% /nobreak >nul

REM === Stop Service ===
echo [%date% %time%] Attempting to stop service "%SERVICE%"... >> "%LOGFILE%"
net stop "%SERVICE%" >> "%LOGFILE%" 2>&1
if errorlevel 1 (
    echo [%date% %time%] WARNING: Service "%SERVICE%" may not have stopped on first attempt. >> "%LOGFILE%"
)

REM === Wait for Service to Stop (with timeout) ===
set /a "iter=0"
:WAIT_STOP
sc query "%SERVICE%" | find "STATE" | find "STOPPED" >nul
if errorlevel 1 (
    set /a "iter+=1"
    if %iter% geq %MAX_WAIT_ITER% (
        echo [%date% %time%] ERROR: Timeout waiting for service "%SERVICE%" to stop. >> "%LOGFILE%"
        exit /b 2
    )
    timeout /t %WAIT_INTERVAL_SEC% /nobreak >nul
    goto WAIT_STOP
)
echo [%date% %time%] Service "%SERVICE%" stopped. >> "%LOGFILE%"

REM === Start Service ===
echo [%date% %time%] Starting service "%SERVICE%"... >> "%LOGFILE%"
net start "%SERVICE%" >> "%LOGFILE%" 2>&1
if errorlevel 1 (
    echo [%date% %time%] ERROR: Failed to start service "%SERVICE%". >> "%LOGFILE%"
    exit /b 3
)

REM === Confirm Service Running ===
sc query "%SERVICE%" | find "STATE" | find "RUNNING" >nul
if errorlevel 1 (
    echo [%date% %time%] ERROR: Service "%SERVICE%" failed to start properly. >> "%LOGFILE%"
    exit /b 4
) else (
    echo [%date% %time%] Service "%SERVICE%" started successfully. >> "%LOGFILE%"
)

REM === Script Complete ===
echo [%date% %time%] Script completed successfully. >> "%LOGFILE%"
exit /b 0
