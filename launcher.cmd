@echo off
::: ============================================================
:::  Claude Code Portable - Context Menu Launcher
:::  This script is called by the right-click context menu.
:::  It resolves its own location and calls the main claude.cmd
::: ============================================================

set "PORTABLE_ROOT=%~dp0"
set "PORTABLE_ROOT=%PORTABLE_ROOT:~0,-1%"

::: Change to the directory that was right-clicked (passed as %1)
if not "%~1"=="" (
    cd /d "%~1"
) else (
    cd /d "%PORTABLE_ROOT%"
)

::: Call the main launcher
call "%PORTABLE_ROOT%\claude.cmd"
