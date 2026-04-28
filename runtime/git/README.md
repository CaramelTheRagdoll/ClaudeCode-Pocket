# runtime/git/

Git for Windows Portable (~414 MB extracted).

Must be placed here **manually** before running `build.cmd`. Download the self-extracting archive from [git-for-windows/git/releases](https://github.com/git-for-windows/git/releases) (look for `PortableGit-*-bit.7z.exe`), extract it, and copy the contents here.

Expected structure after setup:
```
runtime/git/
├── bin/          ← bash.exe, sh.exe (CLAUDE_CODE_GIT_BASH_PATH points here)
├── cmd/          ← git.exe, git-bash.exe
├── mingw64/      ← MinGW-w64 toolchain
├── usr/          ← Unix utilities
└── etc/          ← Git configuration
```

> Claude Code on Windows requires Git Bash to execute shell commands. This is why `CLAUDE_CODE_GIT_BASH_PATH` is set — most portable editions miss this.
