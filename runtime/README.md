# runtime/

Bundled runtimes that make ClaudeCode-Pocket fully self-contained. This entire directory is excluded from Git — run `build.cmd` to populate it.

| Subdirectory | Contents | Source | License |
|---|---|---|---|
| `node/` | Node.js v22 executable and core modules | [nodejs.org](https://nodejs.org/) | MIT |
| `npm/` | npm global prefix — contains `@anthropic-ai/claude-code` and its dependencies | [npmjs.com](https://www.npmjs.com/) | Various |
| `git/` | Git for Windows Portable (bash, git, mingw64, usr) | [git-scm.com](https://git-scm.com/) | GPLv2 |

> When switching to `system` or `hybrid` mode in `portable.ini`, the corresponding subdirectory here is bypassed in favor of the system-installed version.
