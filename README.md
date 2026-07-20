# Razi — Your Private, Offline Document AI

> Named after **Zakariya al-Razi (Rhazes)**, the Persian polymath and pioneer of evidence-based inquiry.

**Razi** is a ready-to-run setup for a private AI that answers questions from **your own documents** — books, PDFs, notes — and runs **entirely on your computer**. No internet needed after setup, and nothing is ever sent to anyone.

Made by **[d991d](https://github.com/d991d)**.

---

## What Razi does

- 📚 **Learns from your documents** — drop in PDFs, Word docs, text, and more.
- 🔒 **Fully private & offline** — your files and questions never leave your machine.
- 🖥️ **Runs on Mac & Windows** — one-click installers for both.
- 🧠 **Builds its own knowledge** — each user grows their own library over time.
- 💬 **Cites its sources** — answers point back to the documents they came from.

Razi is a branded, one-click setup built on two excellent open-source tools:
[**Ollama**](https://ollama.com) (runs the AI model locally) and
[**AnythingLLM**](https://anythingllm.com) (the document-chat app).

---

## What's in this repo

| File | Platform | What it does |
|---|---|---|
| `Setup-Mac.command` | **Mac** | One-click installer for macOS |
| `Run-Windows.bat` | **Windows** | One-click installer for Windows (pure batch — no PowerShell) |
| `README.md` | Everyone | This guide |
| `LICENSE` | — | MIT License |

> **Windows note:** The Windows installer is a plain batch file, so it is **not** affected by PowerShell "execution policy" or *"script is not digitally signed"* errors that appear on locked-down/corporate PCs.

---

## Requirements

- **macOS 14 (Sonoma)+** or **Windows 10/11**
- RAM guide: **8 GB** → use a small model (`llama3.2:3b`); **16 GB** → `llama3.1` (default); **24 GB+** → `llama3.1` or larger (`qwen2.5:14b`)
- ~6 GB free disk for the app + default model

---

## Install

### Mac
1. Download this repo (green **Code → Download ZIP**) and unzip it.
2. Double-click **`Setup-Mac.command`**.
3. If macOS blocks it: **right-click** the file → **Open** → **Open** (once only).
4. Leave it running — the model download takes a few minutes. Razi opens when done.

### Windows
1. Download this repo (green **Code → Download ZIP**) and unzip it.
2. Double-click **`Run-Windows.bat`**.
3. If SmartScreen warns: **More info** → **Run anyway**.
4. Leave it running — the model download takes a few minutes. Razi opens when done.

---

## First-run setup

The first time the app opens, a short wizard appears. Choose:

- **LLM Provider** → **Ollama**
- **Model** → **`llama3.1`**
- **Embedder** → **built-in** (or **Ollama → `nomic-embed-text`** for non-English documents)

---

## Add your own documents (the important part)

Razi only knows what you give it. To add documents so they **stay permanently**:

1. Create a **workspace** (e.g. "My Library").
2. Click the **upload icon** next to the workspace name.
3. **Drag in your PDFs / docs**, or browse to select them.
4. Tick your file(s) under **My Documents**, then click **Move to Workspace**.
5. Click **Save and Embed**. ⭐ **This step is essential** — it's what teaches Razi your documents.
6. Ask questions in the chat.

> ⚠️ Just attaching a file to a single chat is **not** enough — it won't persist. Always use **Move to Workspace → Save and Embed**.

Supported: **PDF, Word (.docx), .txt, Markdown, HTML, CSV, Excel, PowerPoint**. Add more anytime — they stack on top.

---

## Chat vs Query mode

Workspace **gear → Chat Settings → Chat mode**:

- **Chat** — blends your documents with the model's general knowledge.
- **Query** — answers **only** from your documents (most faithful/private).
- **Agent** — ⚠️ leave OFF for normal use; it diverts messages into a tool loop.

---

## Change the model (optional)

1. In a terminal / PowerShell: `ollama pull llama3.2:3b` (smaller) or `ollama pull qwen2.5:14b` (bigger).
2. In the app: **Settings → AI Providers → LLM**, pick the model, **Save**.

To change what the installer downloads by default, edit `CHAT_MODEL` (Mac) / `$ChatModel` (Windows) at the top of the setup script.

---

## Privacy

Everything runs locally. As long as the **LLM Provider** stays **Ollama** (not a cloud option), no document text or questions ever leave the machine. Disconnect from the internet after setup and Razi still works.

---

## Troubleshooting

- **No response / Ollama error** → make sure the **Ollama** app is running (menu bar / system tray).
- **First answer slow** → the model loads into memory on first use; later answers are faster.
- **"No relevant information"** → the document wasn't embedded; redo **Move to Workspace → Save and Embed**.
- **Answers from outside your docs** → switch Chat mode to **Query**.
- **Installer couldn't download an app** → it opens the official page; install manually, then re-run.
- **Windows: "script is not digitally signed" / execution policy error** → you ran the PowerShell version on a locked-down PC. Use **`Run-Windows.bat`** instead — it's plain batch and isn't affected by that policy.

---

## Credits & License

- Named in honor of **Zakariya al-Razi**.
- Built on the open-source [Ollama](https://github.com/ollama/ollama) and [AnythingLLM](https://github.com/Mintplex-Labs/anything-llm) projects — Razi automates their official installers and does not modify them.
- Author: **[d991d](https://github.com/d991d)**
- Licensed under the **MIT License** — see [`LICENSE`](./LICENSE).
