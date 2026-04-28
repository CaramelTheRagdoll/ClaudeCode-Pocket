[English](README.md) | [中文](README_CN.md) | [日本語](README_JA.md)

# ClaudeCode-Pocket

**A truly portable Claude Code for Windows** — all dependencies bundled, runs from anywhere.

---

## Features

- **Truly Portable** — Node.js + Git for Windows all bundled, zero system dependencies
- **Flexible Switching** — portable / system / hybrid runtime modes
- **Ready to Go** — no environment variable setup, doesn't pollute system PATH
- **One-Click Launch** — double-click `claude.cmd` to start
- **Context Menu** — right-click any folder to launch Claude Code
- **One-Click Update** — run `update.cmd` to upgrade to the latest version
- **Config Follows You** — all Claude Code settings stored inside the portable directory, plug-and-go on USB
- **CC Switch Built-In** — portable CC Switch for managing Providers, MCP, and usage tracking

---

## Directory Structure

```
ClaudeCode-Pocket/
├── claude.cmd              ← 🚀 Double-click to launch Claude Code
├── switch-runtime.cmd      ← 🔄 Switch runtime mode (portable/system/hybrid)
├── update.cmd              ← 📦 Update to latest version
├── setup-context-menu.cmd  ← 🔗 Register right-click context menu
├── remove-context-menu.cmd ← ❌ Remove context menu
├── launcher.cmd            ← 📂 Context menu launcher (auto-passes folder path)
├── build.cmd               ← 🔧 Build from scratch (first use / repack)
├── portable.ini            ← ⚙️ Runtime mode config (portable/system/hybrid)
├── README.md               ← 📖 This file
├── runtime/
│   ├── node/               ← Node.js v22 runtime (~94 MB)
│   ├── npm/                ← Claude Code and npm dependencies (~483 MB)
│   └── git/                ← Git for Windows Portable (~391 MB)
├── config/                 ← npm global config (npmrc)
├── cc-switch/              ← CC Switch Portable (Provider/MCP/usage management)
│   ├── CC Switch.exe       ← Double-click to launch CC Switch
│   └── ...                 ← Supporting files
└── data/
    ├── home/               ← User home directory (.claude/ configs stored here)
    └── npm-cache/          ← npm cache directory
```

**Total size**: ~1 GB (including CC Switch)

---

## Quick Start

### Option 1: Pre-Built (Use Directly)

1. Download the latest release ZIP from [Releases](https://github.com/CaramelTheRagdoll/ClaudeCode-Pocket/releases)
2. Extract to any folder (or USB drive)
3. Double-click `claude.cmd` to start
4. On first run, log in:
   ```
   claude auth login
   ```
5. Start coding!

### Option 2: Build from Source

> **`build.cmd` is a destructive operation!** Please understand the following risks before running:
>
> | Risk | Description |
> |------|-------------|
> | **Overwrites Existing Runtime** | `runtime/node/` and `runtime/npm/` will be re-downloaded and replaced |
> | **Requires Internet** | Downloads ~110 MB from nodejs.org and npmjs.org |
> | **Requires Disk Space** | At least 1.5 GB free (download + extract + install) |
> | **Takes Time** | First build ~5-10 min, depending on network speed |
>
> **Safety Mechanisms**:
> 1. Existing installation detection — must type `YES` to confirm rebuild
> 2. Operation confirmation — must type `YES` again to start
> 3. Auto-backup + rollback — backs up current runtime before build, auto-restores on failure
>
> **`data/` directory (configs, auth credentials) is never touched by build.cmd.**

1. `git clone https://github.com/CaramelTheRagdoll/ClaudeCode-Pocket.git`
2. Double-click `build.cmd`
3. Read the prompts, type `YES` to confirm
4. Wait for build to complete
5. Double-click `claude.cmd` to start

---

## Context Menu Integration

### Register

Double-click `setup-context-menu.cmd`. After registration:

- **Right-click in folder background** → "Open Claude Code Here"
- **Right-click on a folder** → "Open Claude Code Here"

### Remove

Double-click `remove-context-menu.cmd` to clean up registry entries.

> Registry entries are written under `HKCU` (current user), no admin rights needed.
> After moving the folder, re-run `setup-context-menu.cmd` — the registry stores absolute paths.

---

## Updating Claude Code

Double-click `update.cmd` to auto-update Claude Code to the latest version via npm.

---

## Runtime Mode Switching

ClaudeCode-Pocket supports three runtime modes, switchable via `switch-runtime.cmd` or by editing `portable.ini`.

### Mode Comparison

| Mode | Node.js | Git | Use Case |
|------|---------|-----|----------|
| **portable** | ✅ Bundled | ✅ Bundled | Default. Zero system deps, runs from USB anywhere |
| **system** | 🔗 System | 🔗 System | Machine already has Node.js + Git installed |
| **hybrid** | ✅ Bundled | 🔗 System | Use bundled Claude Code + newer system Git |

### Switching

**Option 1: Interactive Script (Recommended)**

Double-click `switch-runtime.cmd`. It will:
1. Auto-detect installed Node.js / Git versions
2. Show portable vs. system comparison
3. Let you choose a mode
4. Write to `portable.ini`, restart `claude.cmd` to take effect

**Option 2: Manual Edit**

Open `portable.ini` and change `RUNTIME_MODE`:
```ini
RUNTIME_MODE=portable    ; or system, hybrid
```

### Startup Display

`claude.cmd` shows the current mode and runtime sources on launch:

```
 Starting Claude Code...
 ──────────────────────────────────────────
  Mode:  portable
  Node:  ...\runtime\node\node.exe [portable]
  Git:   ...\runtime\git [portable]
  Home:  ...\data\home
 ──────────────────────────────────────────
```

> After switching modes, **restart `claude.cmd`** for changes to take effect.
> `HOME` always points to the portable `data/home/`, regardless of mode.

---

## CC Switch — Provider Management

[CC Switch](https://github.com/farion1231/cc-switch) is a cross-platform desktop tool for unified AI coding CLI configuration management, bundled as a portable edition.

### Highlights

| Feature | Description |
|---------|-------------|
| **Provider Management** | 50+ presets (AWS Bedrock, NVIDIA NIM, etc.), one-click import/switch, drag-and-drop sorting, import/export |
| **Local Proxy & Failover** | Format conversion, auto failover, circuit breaker, provider health monitoring |
| **Unified MCP Management** | Manage MCP servers across Claude Code / Codex / Gemini CLI / OpenCode, bidirectional sync |
| **Prompts Management** | Markdown editor, cross-app sync (CLAUDE.md / AGENTS.md / GEMINI.md) |
| **Skills Management** | One-click install from GitHub repos or ZIP files, symlink support |
| **Usage & Cost Tracking** | Spend dashboard, request logs, token stats, trend charts, custom model pricing |
| **Session Management** | Browse, search, and restore conversation history across all apps |
| **Cloud Sync** | Dropbox, OneDrive, iCloud, NAS, and WebDAV support |
| **System Tray** | Switch providers without opening the main window, takes effect instantly |
| **Deep Links** | Import providers, MCP configs via `ccswitch://` URLs |

### Launching CC Switch

1. Open the `cc-switch/` folder
2. Double-click `CC Switch.exe` to launch
3. On first use, import your existing Claude Code config as the default provider

### Using with Claude Code

1. Launch `claude.cmd` (Claude Code)
2. Launch `CC Switch.exe`
3. Add/switch providers in CC Switch → **takes effect without restarting Claude Code**
4. To switch back to official login: add "Official Login" preset → restart Claude Code → follow login flow

> CC Switch data is stored in `data/home/.cc-switch/` (follows the HOME variable), travels with your USB drive.

### Updating CC Switch

1. Download the latest `CC-Switch-vX.X.X-Windows-Portable.zip` from [Releases](https://github.com/farion1231/cc-switch/releases/latest)
2. Extract and overwrite files in the `cc-switch/` folder

---

## Running from USB

1. Copy the entire `ClaudeCode-Pocket` folder to a USB drive
2. Double-click `claude.cmd` on any Windows PC to run
3. All configs stored in `data/home/.claude/`, follow your USB drive
4. For context menu on a new PC, run `setup-context-menu.cmd` once

---

## Technical Details

### Launch Process

`claude.cmd` performs the following on startup:

1. Reads `RUNTIME_MODE` from `portable.ini`
2. Selects Node.js and Git sources based on mode (bundled or system)
3. Builds `PATH`: bundled paths first (portable/hybrid), or system-only (system)
4. Sets `CLAUDE_CODE_GIT_BASH_PATH` to the appropriate Git Bash
5. Redirects `HOME` to `data/home/` — configs always go with the portable edition
6. Redirects `NPM_CONFIG_CACHE` to `data/npm-cache/`
7. Verifies required runtimes exist, errors if missing
8. Invokes Claude Code

### Key Environment Variables

| Variable | Purpose | Mode-Dependent |
|----------|---------|:---:|
| `CLAUDE_CODE_GIT_BASH_PATH` | Points to Git Bash — bundled in portable/hybrid, system Git in system mode | Yes |
| `DISABLE_INSTALLATION_CHECKS` | Set to 1, skips install checks | No |
| `HOME` | Redirected to `data/home/`, configs travel with portable edition | No |
| `NPM_CONFIG_CACHE` | npm cache inside portable directory | Yes (portable/hybrid only) |
| `PATH` | portable: bundled-first; system: system-only; hybrid: bundled Node + system Git | Yes |

### Why Git Bash?

Claude Code on Windows **requires** Git Bash to execute shell commands. Without system-level Git for Windows, you must tell Claude Code where the portable Git Bash is via `CLAUDE_CODE_GIT_BASH_PATH`. This is the core differentiator from other third-party portable editions — most don't solve this problem.

---

## Known Limitations

- **Windows-only** (no macOS / Linux support)
- **Internet required** for first-time Anthropic account login
- **Large footprint** (~1 GB) due to bundled Git for Windows Portable and CC Switch
- **Re-register context menu** after moving the folder (registry stores absolute paths)

---

## License

- **Claude Code**: © Anthropic — use subject to its [Terms of Service](https://www.anthropic.com/legal/commercial-terms)
- **Node.js**: MIT License
- **Git for Windows**: GPLv2
- **CC Switch**: MIT License — [github.com/farion1231/cc-switch](https://github.com/farion1231/cc-switch)
- **Build scripts in this repo**: MIT License
