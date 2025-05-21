@echo off
title System Optimization
color 0A
echo Running Optimization Script...
echo.

:: RAM Check
for /f "tokens=2 delims==" %%a in ('"wmic OS get FreePhysicalMemory /Value"') do set FreeMem=%%a
for /f "tokens=2 delims==" %%a in ('"wmic OS get TotalVisibleMemorySize /Value"') do set TotalMem=%%a
set /a UsedMem=%TotalMem% - %FreeMem%
set /a UsedGB=%UsedMem% / 1024
set /a TotalGB=%TotalMem% / 1024
echo [RAM] Usage: %UsedGB% GB / %TotalGB% GB

:: Disk Cleanup temp folders
echo [DISK] Cleaning temporary files...
del /s /f /q %TEMP%\* > nul
del /s /f /q C:\Windows\Temp\* > nul
echo [DISK] Temporary files cleaned.

:: Optional: CPU TEMP (via PowerShell + OpenHardwareMonitor or custom tool) – Limited without third party
echo [INFO] CPU Temperature: Not available (Windows CMD doesn’t support directly)

:: Basic Error Check
echo [CHECK] Recent System Errors:
wevtutil qe System /q:"*[System[(Level=2)]]" /c:1 /f:text >nul 2>nul
if %errorlevel%==0 (
    echo [ERROR] Something was logged in event viewer.
) else (
    echo [OK] No critical system errors found.
)

:: Final Status
echo.
echo [✔] System cleaned and ready to use!
echo [i] Script executed on: %DATE% %TIME%
pause
