@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

::: ============================================================
:::  Claude Code Portable - One-Click Build Script
:::  Downloads and sets up everything from scratch
::: ============================================================

echo.
echo  +======================================================+
echo  ^|   Claude Code Portable - Build Script               ^|
echo  +======================================================+
echo.

::: --- Resolve portable root ---
set "PORTABLE_ROOT=%~dp0"
set "PORTABLE_ROOT=%PORTABLE_ROOT:~0,-1%"

set "NODE_DIR=%PORTABLE_ROOT%\runtime\node"
set "NPM_DIR=%PORTABLE_ROOT%\runtime\npm"
set "GIT_DIR=%PORTABLE_ROOT%\runtime\git"
set "DOWNLOAD_DIR=%PORTABLE_ROOT%\downloads"
set "BACKUP_DIR=%PORTABLE_ROOT%\runtime\backup"

::: ============================================================
:::  SAFETY CHECK 1: Detect existing installation
::: ============================================================
set "HAS_EXISTING=0"
if exist "%NODE_DIR%\node.exe" set "HAS_EXISTING=1"
if exist "%NPM_DIR%\claude.cmd" set "HAS_EXISTING=1"
if exist "%GIT_DIR%\cmd\git.exe" set "HAS_EXISTING=1"

if "%HAS_EXISTING%"=="1" (
    echo  +------------------------------------------------------+
    echo  ^|  [!] WARNING: Existing installation detected!       ^|
    echo  ^|                                                      ^|
    echo  ^|  This script will REBUILD the runtime directory.     ^|
    echo  ^|  Your current Node.js, Git, and Claude Code will    ^|
    echo  ^|  be replaced with fresh downloads.                   ^|
    echo  ^|                                                      ^|
    echo  ^|  Your data/ directory (configs, auth) is SAFE.       ^|
    echo  +------------------------------------------------------+
    echo.
    echo  Found:
    if exist "%NODE_DIR%\node.exe" (
        <nul set /p="   - Node.js: "
        "%NODE_DIR%\node.exe" --version 2>nul
    )
    if exist "%NPM_DIR%\claude.cmd" (
        <nul set /p="   - Claude Code: "
        "%NPM_DIR%\claude.cmd" --version 2>nul
    )
    if exist "%GIT_DIR%\cmd\git.exe" (
        <nul set /p="   - Git: "
        "%GIT_DIR%\cmd\git.exe" --version 2>nul
    )
    echo.
    echo  Type YES to proceed with rebuild, or anything else to cancel:
    set /p "CONFIRM_REBUILD="
    if /i "!CONFIRM_REBUILD!" neq "YES" (
        echo.
        echo  Build cancelled. Your existing installation is untouched.
        pause
        exit /b 0
    )
    echo.
)

::: ============================================================
:::  SAFETY CHECK 2: Confirm download and network
::: ============================================================
echo  This script will:
echo    1. Download Node.js v22.16.0 (~30 MB) from nodejs.org
echo    2. Check for PortableGit (manual step if missing)
echo    3. Install @anthropic-ai/claude-code via npm (~80 MB)
echo.
echo  Internet connection is required.
echo.
echo  Type YES to start, or anything else to cancel:
set /p "CONFIRM_START="
if /i "!CONFIRM_START!" neq "YES" (
    echo.
    echo  Build cancelled.
    pause
    exit /b 0
)
echo.

::: ============================================================
:::  SAFETY CHECK 3: Disk space check (minimum 1.5 GB free)
::: ============================================================
echo  Checking disk space...
for /f "tokens=3" %%a in ('dir "%PORTABLE_ROOT%\.." /-c ^| findstr /c:"bytes free"') do set "FREE_SPACE=%%a"
if defined FREE_SPACE (
    if %FREE_SPACE% lss 1500000000 (
        echo.
        echo  [ERROR] Insufficient disk space! At least 1.5 GB free is required.
        echo  Current free space on this drive: %FREE_SPACE% bytes
        pause
        exit /b 1
    )
    <nul set /p="  Free space: "
    echo %FREE_SPACE% bytes - OK
)
echo.

::: ============================================================
:::  BACKUP existing runtime before rebuild
::: ============================================================
if "%HAS_EXISTING%"=="1" (
    echo  [0/5] Backing up existing runtime...
    if exist "%BACKUP_DIR%" rd /s /q "%BACKUP_DIR%" 2>nul
    mkdir "%BACKUP_DIR%" 2>nul

    if exist "%NODE_DIR%" (
        echo    Backing up Node.js...
        move "%NODE_DIR%" "%BACKUP_DIR%\node" >nul 2>&1
    )
    if exist "%NPM_DIR%" (
        echo    Backing up npm/Claude Code...
        move "%NPM_DIR%" "%BACKUP_DIR%\npm" >nul 2>&1
    )
    if exist "%GIT_DIR%\cmd\git.exe" (
        echo    Keeping existing Git (no backup needed - will not redownload)
    )
    echo  Backup stored in: %BACKUP_DIR%
    echo.
)

::: --- Create directory structure ---
echo  [1/5] Creating directory structure...
mkdir "%NODE_DIR%" 2>nul
mkdir "%NPM_DIR%" 2>nul
mkdir "%PORTABLE_ROOT%\config" 2>nul
mkdir "%PORTABLE_ROOT%\data\home" 2>nul
mkdir "%PORTABLE_ROOT%\data\npm-cache" 2>nul
mkdir "%DOWNLOAD_DIR%" 2>nul
echo    Done.
echo.

::: --- Download Node.js ---
echo  [2/5] Downloading Node.js v22.16.0...
set "NODE_ZIP=%DOWNLOAD_DIR%\node-v22.16.0-win-x64.zip"
if exist "%NODE_ZIP%" (
    echo    Already downloaded, skipping.
) else (
    echo    Downloading from nodejs.org...
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v22.16.0/node-v22.16.0-win-x64.zip' -OutFile '%DOWNLOAD_DIR%\node-v22.16.0-win-x64.zip'"
    if !ERRORLEVEL! neq 0 (
        echo    [ERROR] Failed to download Node.js.
        echo    Check your internet connection and try again.
        goto :rollback
    )
    echo    Downloaded.
)

::: --- Extract Node.js ---
echo    Extracting Node.js...
if exist "%NODE_DIR%\node.exe" (
    echo    Already extracted, skipping.
) else (
    powershell -Command "Expand-Archive -Path '%NODE_ZIP%' -DestinationPath '%DOWNLOAD_DIR%\node-temp' -Force"
    if !ERRORLEVEL! neq 0 (
        echo    [ERROR] Failed to extract Node.js.
        goto :rollback
    )
    move "%DOWNLOAD_DIR%\node-temp\node-v22.16.0-win-x64\*" "%NODE_DIR%\" >nul
    rd /s /q "%DOWNLOAD_DIR%\node-temp" 2>nul
    echo    Extracted.
)
echo.

::: --- Check for Git ---
echo  [3/5] Checking for PortableGit...
if exist "%GIT_DIR%\cmd\git.exe" (
    echo    PortableGit already in place.
    "%GIT_DIR%\cmd\git.exe" --version
) else (
    echo.
    echo  +------------------------------------------------------+
    echo  ^|  [ACTION REQUIRED] PortableGit not found!           ^|
    echo  ^|                                                      ^|
    echo  ^|  Please download Git for Windows Portable from:      ^|
    echo  ^|    https://github.com/git-for-windows/git/releases   ^|
    echo  ^|                                                      ^|
    echo  ^|  Download the "PortableGit-XX-bit.7z.exe" file,     ^|
    echo  ^|  extract it, and copy the contents to:               ^|
    echo  ^|    %GIT_DIR%\                                        ^|
    echo  ^|                                                      ^|
    echo  ^|  The directory should contain:                       ^|
    echo  ^|    bin/, cmd/, mingw64/, usr/, etc.                  ^|
    echo  ^|                                                      ^|
    echo  ^|  After copying, run this script again.               ^|
    echo  +------------------------------------------------------+
    echo.
    pause
    exit /b 1
)
echo.

::: --- Install Claude Code ---
echo  [4/5] Installing Claude Code via npm...
if exist "%NPM_DIR%\claude.cmd" (
    echo    Claude Code already installed. Current version:
    "%NPM_DIR%\claude.cmd" --version 2>nul
    echo    To update, run update.cmd instead.
) else (
    set "PATH=%NODE_DIR%;%GIT_DIR%\cmd;%GIT_DIR%\bin;%GIT_DIR%\usr\bin;%GIT_DIR%\mingw64\bin;%SystemRoot%\system32;%SystemRoot%"
    set "NPM_CONFIG_CACHE=%PORTABLE_ROOT%\data\npm-cache"

    echo    Installing @anthropic-ai/claude-code...
    "%NODE_DIR%\npm.cmd" install -g @anthropic-ai/claude-code --prefix "%NPM_DIR%"
    if !ERRORLEVEL! neq 0 (
        echo    [ERROR] Failed to install Claude Code.
        goto :rollback
    )
    echo    Installed successfully.
)
echo.

::: --- Verify ---
echo  [5/5] Verifying installation...
echo.
set "VERIFY_PATH=%NODE_DIR%;%NPM_DIR%;%GIT_DIR%\cmd;%SystemRoot%\system32;%SystemRoot%"
setlocal
set "PATH=%VERIFY_PATH%"

<nul set /p="   Node.js:      "
"%NODE_DIR%\node.exe" --version

<nul set /p="   Git:          "
"%GIT_DIR%\cmd\git.exe" --version

<nul set /p="   Claude Code:  "
"%NPM_DIR%\claude.cmd" --version 2>nul

endlocal
echo.

::: --- Cleanup backup on success ---
if exist "%BACKUP_DIR%" (
    echo  Cleaning up backup...
    rd /s /q "%BACKUP_DIR%" 2>nul
)

::: --- Cleanup downloads ---
if exist "%DOWNLOAD_DIR%" (
    echo  Cleaning up downloaded archives...
    rd /s /q "%DOWNLOAD_DIR%" 2>nul
)

echo.
echo  +======================================================+
echo  ^|   [OK] Build complete!                               ^|
echo  ^|                                                      ^|
echo  ^|   Next steps:                                        ^|
echo  ^|     1. Double-click claude.cmd to start              ^|
echo  ^|     2. Run setup-context-menu.cmd for right-click    ^|
echo  ^|     3. First run: claude auth login                  ^|
echo  +======================================================+
echo.
pause
endlocal
exit /b 0

::: ============================================================
:::  ROLLBACK - Restore backup if build failed
::: ============================================================
:rollback
echo.
echo  +------------------------------------------------------+
echo  ^|  [ERROR] Build failed! Attempting rollback...        ^|
echo  +------------------------------------------------------+
echo.

if exist "%BACKUP_DIR%" (
    echo  Restoring from backup...
    if exist "%BACKUP_DIR%\node" (
        if exist "%NODE_DIR%" rd /s /q "%NODE_DIR%" 2>nul
        move "%BACKUP_DIR%\node" "%NODE_DIR%" >nul 2>&1
        echo    Restored Node.js
    )
    if exist "%BACKUP_DIR%\npm" (
        if exist "%NPM_DIR%" rd /s /q "%NPM_DIR%" 2>nul
        move "%BACKUP_DIR%\npm" "%NPM_DIR%" >nul 2>&1
        echo    Restored Claude Code/npm
    )
    rd /s /q "%BACKUP_DIR%" 2>nul
    echo  Rollback complete. Previous installation restored.
) else (
    echo  No backup available. You may need to re-run build.cmd.
)
echo.
pause
endlocal
exit /b 1
