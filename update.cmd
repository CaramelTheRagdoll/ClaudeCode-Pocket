@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

::: ============================================================
:::  Claude Code Portable - Update Claude Code to Latest Version
::: ============================================================

::: --- Resolve portable root ---
set "PORTABLE_ROOT=%~dp0"
set "PORTABLE_ROOT=%PORTABLE_ROOT:~0,-1%"

set "NODE_DIR=%PORTABLE_ROOT%\runtime\node"
set "NPM_DIR=%PORTABLE_ROOT%\runtime\npm"
set "GIT_DIR=%PORTABLE_ROOT%\runtime\git"
set "GIT_CMD_DIR=%GIT_DIR%\cmd"
set "GIT_BIN_DIR=%GIT_DIR%\bin"
set "GIT_USR_BIN_DIR=%GIT_DIR%\usr\bin"
set "GIT_MINGW_BIN_DIR=%GIT_DIR%\mingw64\bin"

::: --- Config paths ---
set "NPM_CONFIG_CACHE=%PORTABLE_ROOT%\data\npm-cache"
if not exist "%NPM_CONFIG_CACHE%" mkdir "%NPM_CONFIG_CACHE%"

::: --- Set up isolated PATH ---
set "PATH=%NODE_DIR%;%NPM_DIR%;%GIT_CMD_DIR%;%GIT_BIN_DIR%;%GIT_USR_BIN_DIR%;%GIT_MINGW_BIN_DIR%;%SystemRoot%\system32;%SystemRoot%"

echo ============================================
echo  Claude Code Portable - Updater
echo ============================================
echo.

::: --- Verify Node.js ---
if not exist "%NODE_DIR%\node.exe" (
    echo [ERROR] Node.js not found. Cannot update.
    echo.
    pause
    exit /b 1
)

::: --- Show current version ---
echo Current version:
if exist "%NPM_DIR%\claude.cmd" (
    call "%NPM_DIR%\claude.cmd" --version 2>nul
) else (
    echo   (Claude Code not yet installed)
)
echo.

::: --- Update ---
echo Updating @anthropic-ai/claude-code to latest version...
echo This may take a few minutes...
echo.
call "%NODE_DIR%\npm.cmd" install -g @anthropic-ai/claude-code@latest --prefix "%NPM_DIR%"

if !ERRORLEVEL! neq 0 (
    echo.
    echo [ERROR] Update failed. Check your internet connection.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================
echo  Update complete! New version:
call "%NPM_DIR%\claude.cmd" --version 2>nul
echo ============================================
echo.
pause
endlocal
