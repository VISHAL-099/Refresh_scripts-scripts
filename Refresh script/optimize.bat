@echo off
title System Optimizer
color 0A
echo Running System Optimization...
echo.

:: RAM Usage
for /f "tokens=2 delims==" %%a in ('"wmic OS get FreePhysicalMemory /Value"') do set FreeMem=%%a
for /f "tokens=2 delims==" %%a in ('"wmic OS get TotalVisibleMemorySize /Value"') do set TotalMem=%%a
set /a UsedMem=%TotalMem% - %FreeMem%
set /a UsedGB=%UsedMem% / 1024 / 1024
set /a TotalGB=%TotalMem% / 1024 / 1024
echo [RAM] Usage: %UsedGB% GB / %TotalGB% GB

:: Disk Cleanup
echo [DISK] Cleaning temp files...
del /f /s /q %TEMP%\* >nul 2>nul
rd /s /q %TEMP% >nul 2>nul
del /f /s /q C:\Windows\Temp\* >nul 2>nul
echo [DISK] Temp files cleaned.

:: Check hibernation and pagefile
powercfg /a | find /i "Hibernate" >nul
if %errorlevel%==0 (
    echo [HIBERNATE] Enabled
) else (
    echo [HIBERNATE] Disabled
)

:: Call PowerShell for advanced info
echo.
echo Gathering detailed info...
PowerShell -ExecutionPolicy Bypass -File "%~dp0status.ps1"

echo.
echo [✔] Optimization Complete!
echo [i] Executed at: %DATE% %TIME%
pause
