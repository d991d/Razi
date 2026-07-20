@echo off
REM =====================================================================
REM  Razi - Private, Offline Document AI - Windows Setup (pure batch)
REM  by d991d  -  https://github.com/d991d/Razi  -  MIT License
REM
REM  This is a plain .bat installer. It does NOT use PowerShell, so it is
REM  not affected by PowerShell execution-policy / "script not digitally
REM  signed" errors on locked-down or corporate machines.
REM
REM  Installs:  1) Ollama   2) a local model (llama3.1)   3) AnythingLLM
REM  Everything runs locally. Nothing is sent anywhere.
REM
REM  HOW TO RUN:  double-click this file. If SmartScreen warns,
REM               click "More info" -> "Run anyway".
REM =====================================================================
setlocal enableextensions enabledelayedexpansion

REM ============================ CONFIG =================================
set "CHAT_MODEL=llama3.1"
set "EMBED_MODEL=nomic-embed-text"
set "OLLAMA_URL=https://ollama.com/download/OllamaSetup.exe"
set "ALLM_URL=https://cdn.anythingllm.com/latest/AnythingLLMDesktop.exe"
set "ALLM_PAGE=https://anythingllm.com/download"
set "WORK=%TEMP%\razi-setup"
REM ====================================================================

echo ==================================================
echo    Razi  -  Private, Offline Document AI
echo    by d991d
echo ==================================================
echo.

if not exist "%WORK%" mkdir "%WORK%"

REM --- Make sure curl is available (built into Windows 10 1803+ / Win11) ---
where curl >nul 2>&1
if errorlevel 1 (
  echo [!] This installer needs "curl", which is missing on this system.
  echo     Please update Windows, or install Ollama and AnythingLLM manually:
  echo       - https://ollama.com/download/windows
  echo       - %ALLM_PAGE%
  echo.
  pause
  exit /b 1
)

REM --- 1) Install Ollama -----------------------------------------------
where ollama >nul 2>&1
if %errorlevel%==0 (
  echo ==^> Ollama already installed. Skipping.
) else (
  echo ==^> Downloading Ollama...
  curl -L -o "%WORK%\OllamaSetup.exe" "%OLLAMA_URL%"
  if exist "%WORK%\OllamaSetup.exe" (
    echo ==^> Installing Ollama...
    "%WORK%\OllamaSetup.exe" /VERYSILENT /SUPPRESSMSGBOXES
  ) else (
    echo [!] Could not download Ollama. Opening the download page...
    start "" "https://ollama.com/download/windows"
  )
)

REM Add Ollama to PATH for this window
set "PATH=%PATH%;%LOCALAPPDATA%\Programs\Ollama"

REM Give the background service a moment to start
timeout /t 6 /nobreak >nul

REM --- 2) Download the models ------------------------------------------
echo.
echo ==^> Downloading model: %CHAT_MODEL%  (this can take several minutes)...
ollama pull %CHAT_MODEL%
echo ==^> Downloading embedding model: %EMBED_MODEL% ...
ollama pull %EMBED_MODEL%

REM --- 3) Install AnythingLLM (Razi's app engine) ---------------------
set "ALLM_EXE=%LOCALAPPDATA%\Programs\AnythingLLM\AnythingLLM.exe"
if exist "%ALLM_EXE%" (
  echo ==^> App already installed. Skipping.
) else (
  echo.
  echo ==^> Downloading the Razi app engine ^(AnythingLLM^)...
  curl -L -o "%WORK%\AnythingLLMDesktop.exe" "%ALLM_URL%"
  if exist "%WORK%\AnythingLLMDesktop.exe" (
    echo ==^> Installing...
    "%WORK%\AnythingLLMDesktop.exe" /S
  ) else (
    echo [!] Could not auto-download the app. Opening the download page...
    start "" "%ALLM_PAGE%"
  )
)

echo.
echo ==================================================
echo    Razi setup complete!
echo ==================================================
echo.
echo In the first-run wizard, choose:
echo    - LLM Provider : Ollama
echo    - Model        : %CHAT_MODEL%
echo    - Embedder     : built-in  ^(or Ollama -^> %EMBED_MODEL%^)
echo.
echo Then create a workspace and upload your documents.
echo See README.md for how to add documents and keep them permanent.
echo.
if exist "%ALLM_EXE%" start "" "%ALLM_EXE%"
pause
