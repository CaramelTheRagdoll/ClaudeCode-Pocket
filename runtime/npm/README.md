# runtime/npm/

npm global install prefix (~483 MB after install).

Populated by `build.cmd` — runs `npm install -g @anthropic-ai/claude-code --prefix <here>`.

Key files after build:
- `claude.cmd` — Claude Code launcher
- `node_modules/` — all npm dependencies

> This directory contains proprietary Anthropic software. It is excluded from Git and must be installed from npm via `build.cmd` or `update.cmd`.
