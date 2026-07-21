#!/bin/bash
###############################################################################
#  Razi  —  Private, Offline Document AI  —  macOS Setup
#  by d991d  •  https://github.com/d991d/Razi  •  MIT License
#
#  Named after Zakariya al-Razi (Rhazes), the Persian polymath.
#
#  Installs everything needed to run Razi locally:
#    1. Ollama            (runs the AI model locally)
#    2. A language model  (default: llama3.1)
#    3. AnythingLLM       (the app where you chat with your own documents)
#
#  Nothing is sent anywhere — the whole thing runs on this computer.
#
#  HOW TO RUN:
#    - Double-click "Setup-Mac.command".
#    - If macOS blocks it, right-click the file → Open → Open.
###############################################################################

set -u

# ============================= CONFIG ========================================
CHAT_MODEL="llama3.1"                 # main chat model (see README to change)
EMBED_MODEL="nomic-embed-text"        # embedding model (multilingual)
ANYTHINGLLM_PAGE="https://anythingllm.com/download"

# Direct installer URLs (verified from official AnythingLLM docs, 2026-07).
OLLAMA_DMG_URL="https://ollama.com/download/Ollama.dmg"
OLLAMA_ZIP_URL="https://ollama.com/download/Ollama-darwin.zip"
ALLM_SILICON_URL="https://cdn.anythingllm.com/latest/AnythingLLMDesktop-Silicon.dmg"
ALLM_INTEL_URL="https://cdn.anythingllm.com/latest/AnythingLLMDesktop.dmg"
# =============================================================================

echo "=================================================="
echo "   Razi  —  Private, Offline Document AI"
echo "   by d991d"
echo "=================================================="
echo ""

# --- 1) Install Ollama -------------------------------------------------------
if command -v ollama >/dev/null 2>&1 || [ -d "/Applications/Ollama.app" ]; then
  echo "==> Ollama already present. Skipping."
else
  echo "==> Installing Ollama..."
  TMPDIR_O="$(mktemp -d)"
  DMG="$TMPDIR_O/Ollama.dmg"
  if curl -fL "$OLLAMA_DMG_URL" -o "$DMG"; then
    MNT="$(mktemp -d)"
    hdiutil attach "$DMG" -nobrowse -mountpoint "$MNT" >/dev/null 2>&1
    cp -R "$MNT/Ollama.app" /Applications/ 2>/dev/null
    hdiutil detach "$MNT" >/dev/null 2>&1
    echo "    Ollama installed to /Applications."
  elif curl -fL "$OLLAMA_ZIP_URL" -o "$TMPDIR_O/Ollama.zip"; then
    unzip -oq "$TMPDIR_O/Ollama.zip" -d /Applications/
    echo "    Ollama installed to /Applications."
  else
    echo "    !! Could not download Ollama automatically."
    echo "    Please install it from https://ollama.com/download/mac, then re-run this script."
    open "https://ollama.com/download/mac"
    exit 1
  fi
fi

# --- 2) Start Ollama and wait for it to be ready -----------------------------
echo "==> Starting Ollama service..."
open -a Ollama 2>/dev/null || true
for i in $(seq 1 40); do
  if curl -fs http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then break; fi
  sleep 1
done

# Locate the ollama command (either on PATH or inside the app bundle)
OLLAMA_BIN="ollama"
if ! command -v ollama >/dev/null 2>&1; then
  if [ -x "/Applications/Ollama.app/Contents/Resources/ollama" ]; then
    OLLAMA_BIN="/Applications/Ollama.app/Contents/Resources/ollama"
  else
    echo "    !! Ollama command not found. Open the Ollama app once, then re-run this script."
    exit 1
  fi
fi

# --- 3) Download the models --------------------------------------------------
echo "==> Downloading model: $CHAT_MODEL  (this can take several minutes)..."
"$OLLAMA_BIN" pull "$CHAT_MODEL"
echo "==> Downloading embedding model: $EMBED_MODEL ..."
"$OLLAMA_BIN" pull "$EMBED_MODEL" || echo "    (embedding model optional — continuing)"

# --- 4) Install AnythingLLM (Razi's app engine) ------------------------------
if [ -d "/Applications/AnythingLLM.app" ]; then
  echo "==> App already installed. Skipping."
else
  echo "==> Installing the Razi app engine (AnythingLLM)..."
  ARCH="$(uname -m)"
  if [ "$ARCH" = "arm64" ]; then URL="$ALLM_SILICON_URL"; else URL="$ALLM_INTEL_URL"; fi
  TMPDIR_A="$(mktemp -d)"
  ADMG="$TMPDIR_A/App.dmg"
  if curl -fL "$URL" -o "$ADMG"; then
    MNT2="$(mktemp -d)"
    hdiutil attach "$ADMG" -nobrowse -mountpoint "$MNT2" >/dev/null 2>&1
    cp -R "$MNT2/"*.app /Applications/ 2>/dev/null
    hdiutil detach "$MNT2" >/dev/null 2>&1
    echo "    Installed."
  elif command -v brew >/dev/null 2>&1; then
    echo "    Direct download failed. Trying Homebrew..."
    if brew install --cask anythingllm; then
      echo "    Installed via Homebrew."
    else
      echo "    !! Could not install automatically. Opening the download page..."
      open "$ANYTHINGLLM_PAGE"
    fi
  else
    echo "    !! Could not auto-download the app. Opening the download page..."
    open "$ANYTHINGLLM_PAGE"
  fi
fi

# --- Done --------------------------------------------------------------------
echo ""
echo "=================================================="
echo "   Razi setup complete!"
echo "=================================================="
echo ""
echo "In the first-run wizard, choose:"
echo "   • LLM Provider : Ollama"
echo "   • Model        : $CHAT_MODEL"
echo "   • Embedder     : built-in  (or Ollama -> $EMBED_MODEL)"
echo ""
echo "Then create a workspace and upload your documents."
echo "See README.md for how to add documents and keep them permanent."
echo ""
open -a AnythingLLM 2>/dev/null || open "$ANYTHINGLLM_PAGE"
