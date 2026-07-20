@echo off
REM =====================================================================
REM  Razi - Private, Offline Document AI - Windows launcher
REM  by d991d  -  https://github.com/d991d/Razi
REM  Double-click this file to install and run Razi.
REM =====================================================================
echo Starting Razi setup...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Setup-Windows.ps1"
echo.
echo Done. You can close this window.
pause
