# data/

User data directory — stores all personal configuration, authentication tokens, and caches. This entire directory is excluded from Git for security.

| Subdirectory | Purpose |
|---|---|
| `home/` | `HOME` redirected here — contains `.claude/` (Claude Code configs, credentials, session history) and `.cc-switch/` (CC Switch data) |
| `npm-cache/` | npm package cache, speeds up reinstalls |

> Never commit this directory. It contains OAuth tokens and API keys.
