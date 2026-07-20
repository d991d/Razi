<#
###############################################################################
  Razi  —  Private, Offline Document AI  —  Windows Setup
  by d991d  •  https://github.com/d991d/Razi  •  MIT License

  Named after Zakariya al-Razi (Rhazes), the Persian polymath.

  Installs everything needed to run Razi locally:
    1. Ollama            (runs the AI model locally)
    2. A language model  (default: llama3.1)
    3. AnythingLLM       (the app where you chat with your own documents)

  Nothing is sent anywhere — the whole thing runs on this computer.

  HOW TO RUN:
    - Double-click "Run-Windows.bat"  (it launches this script for you).
###############################################################################
#>

$ErrorActionPreference = "Stop"

# ============================= CONFIG ========================================
$ChatModel  = "llama3.1"                # main chat model (see README to change)
$EmbedModel = "nomic-embed-text"        # embedding model (multilingual)
$AllmPage   = "https://anythingllm.com/download"

# Direct installer URLs. VERIFY these are current before distributing widely.
$OllamaUrl  = "https://ollama.com/download/OllamaSetup.exe"
$AllmUrl    = "https://cdn.anythingllm.com/latest/AnythingLLMDesktop.exe"
# =============================================================================

Write-Host "=================================================="
Write-Host "   Razi  —  Private, Offline Document AI"
Write-Host "   by d991d"
Write-Host "=================================================="
Write-Host ""

# --- 1) Install Ollama -------------------------------------------------------
if (Get-Command ollama -ErrorAction SilentlyContinue) {
    Write-Host "==> Ollama already installed. Skipping."
} else {
    Write-Host "==> Downloading Ollama..."
    $o = Join-Path $env:TEMP "OllamaSetup.exe"
    Invoke-WebRequest -Uri $OllamaUrl -OutFile $o
    Write-Host "==> Installing Ollama (silent)..."
    Start-Process -FilePath $o -ArgumentList "/VERYSILENT","/SUPPRESSMSGBOXES" -Wait
    # Make ollama reachable in this session without restarting the terminal
    $env:Path += ";$env:LOCALAPPDATA\Programs\Ollama"
}

# Give the background service a moment to start
Start-Sleep -Seconds 6

# --- 2) Download the models --------------------------------------------------
Write-Host "==> Downloading model: $ChatModel  (this can take several minutes)..."
& ollama pull $ChatModel
Write-Host "==> Downloading embedding model: $EmbedModel ..."
try { & ollama pull $EmbedModel } catch { Write-Host "    (embedding model optional — continuing)" }

# --- 3) Install AnythingLLM (Razi's app engine) ------------------------------
$allmExe = "$env:LOCALAPPDATA\Programs\AnythingLLM\AnythingLLM.exe"
if (Test-Path $allmExe) {
    Write-Host "==> App already installed. Skipping."
} else {
    Write-Host "==> Downloading the Razi app engine (AnythingLLM)..."
    $a = Join-Path $env:TEMP "AnythingLLMDesktop.exe"
    try {
        Invoke-WebRequest -Uri $AllmUrl -OutFile $a
        Write-Host "==> Installing..."
        Start-Process -FilePath $a -ArgumentList "/S" -Wait
    } catch {
        Write-Host "    !! Could not auto-download the app. Opening the download page..."
        Start-Process $AllmPage
    }
}

# --- Done --------------------------------------------------------------------
Write-Host ""
Write-Host "=================================================="
Write-Host "   Razi setup complete!"
Write-Host "=================================================="
Write-Host ""
Write-Host "In the first-run wizard, choose:"
Write-Host "   - LLM Provider : Ollama"
Write-Host "   - Model        : $ChatModel"
Write-Host "   - Embedder     : built-in  (or Ollama -> $EmbedModel)"
Write-Host ""
Write-Host "Then create a workspace and upload your documents."
Write-Host "See README.md for how to add documents and keep them permanent."
Write-Host ""
if (Test-Path $allmExe) { Start-Process $allmExe }
