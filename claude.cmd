@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

::: ============================================================
:::  Claude Code Portable - Launch Script
:::  Supports portable / system / hybrid runtime modes
::: ============================================================

::: --- Resolve portable root (where this script lives) ---
set "PORTABLE_ROOT=%~dp0"
set "PORTABLE_ROOT=%PORTABLE_ROOT:~0,-1%"

::: --- Save original system PATH for system/hybrid modes ---
set "ORIG_PATH=%PATH%"

::: --- Read runtime mode from portable.ini ---
set "RUNTIME_MODE=portable"
if exist "%PORTABLE_ROOT%\portable.ini" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%PORTABLE_ROOT%\portable.ini") do (
        set "LINE=%%a"
        if "!LINE:~0,1!" neq ";" if "!LINE:~0,1!" neq " " (
            if /i "%%a"=="RUNTIME_MODE" set "RUNTIME_MODE=%%b"
        )
    )
)
set "RUNTIME_MODE=%RUNTIME_MODE: =%"

::: ============================================================
:::  Set up paths based on runtime mode
::: ============================================================
set "USE_PORTABLE_NODE=0"
set "USE_PORTABLE_GIT=0"

if /i "%RUNTIME_MODE%"=="portable" (
    set "USE_PORTABLE_NODE=1"
    set "USE_PORTABLE_GIT=1"
) else if /i "%RUNTIME_MODE%"=="system" (
    set "USE_PORTABLE_NODE=0"
    set "USE_PORTABLE_GIT=0"
) else if /i "%RUNTIME_MODE%"=="hybrid" (
    set "USE_PORTABLE_NODE=1"
    set "USE_PORTABLE_GIT=0"
) else (
    echo [WARNING] Unknown RUNTIME_MODE='%RUNTIME_MODE%' in portable.ini
    echo           Falling back to 'portable' mode.
    echo.
    set "RUNTIME_MODE=portable"
    set "USE_PORTABLE_NODE=1"
    set "USE_PORTABLE_GIT=1"
)

::: ============================================================
:::  Resolve Node.js path
::: ============================================================
if "%USE_PORTABLE_NODE%"=="1" (
    set "NODE_DIR=!PORTABLE_ROOT!\runtime\node"
    set "NPM_DIR=!PORTABLE_ROOT!\runtime\npm"
    set "NPM_CONFIG_USERCONFIG=!PORTABLE_ROOT!\config\npmrc"
    set "NPM_CONFIG_CACHE=!PORTABLE_ROOT!\data\npm-cache"
    set "NPM_CONFIG_PREFIX=!NPM_DIR!"
    set "NODE_LABEL="
    set "CLAUDE_CMD=!NPM_DIR!\claude.cmd"
)

if "%USE_PORTABLE_NODE%"=="0" (
    set "SYS_NODE_PATH="
    for /f "delims=" %%p in ('where node 2^>nul') do (
        set "SYS_NODE_PATH=%%p"
        goto :node_found
    )
    :node_found
    if not defined SYS_NODE_PATH (
        echo.
        echo  [ERROR] RUNTIME_MODE=system but Node.js is not found on PATH!
        echo         Install Node.js, or switch back to portable mode.
        echo.
        echo         Quick fix:  run  switch-runtime.cmd
        echo.
        pause
        exit /b 1
    )
    for %%d in ("!SYS_NODE_PATH!") do set "SYS_NODE_DIR=%%~dpD"
    set "SYS_NODE_DIR=!SYS_NODE_DIR:~0,-1!"
    for /f "delims=" %%p in ('npm prefix -g 2^>nul') do set "NPM_DIR=%%p"
    if not defined NPM_DIR set "NPM_DIR=!SYS_NODE_DIR!"
    set "SYS_CLAUDE_PATH="
    for /f "delims=" %%p in ('where claude.cmd 2^>nul') do (
        echo %%p | findstr /i /c:"Claude-Code-Portable" >nul 2>&1
        if errorlevel 1 (
            set "SYS_CLAUDE_PATH=%%p"
            goto :claude_found
        )
    )
    :claude_found
    if not defined SYS_CLAUDE_PATH (
        echo.
        echo  [ERROR] Claude Code CLI not found on system PATH!
        echo         Install it via:  npm install -g @anthropic-ai/claude-code
        echo         Or switch back to portable mode.
        echo.
        echo         Quick fix:  run  switch-runtime.cmd
        echo.
        pause
        exit /b 1
    )
    set "CLAUDE_CMD=!SYS_CLAUDE_PATH!"
    set "NODE_LABEL=[system] !SYS_NODE_PATH!"
)

::: ============================================================
:::  Resolve Git path
::: ============================================================
if "%USE_PORTABLE_GIT%"=="1" (
    set "GIT_DIR=!PORTABLE_ROOT!\runtime\git"
    set "GIT_CMD_DIR=!GIT_DIR!\cmd"
    set "GIT_BIN_DIR=!GIT_DIR!\bin"
    set "GIT_USR_BIN_DIR=!GIT_DIR!\usr\bin"
    set "GIT_MINGW_BIN_DIR=!GIT_DIR!\mingw64\bin"
    set "CLAUDE_CODE_GIT_BASH_PATH=!GIT_DIR!\bin\bash.exe"
    set "GIT_LABEL="
)

if "%USE_PORTABLE_GIT%"=="0" (
    set "SYS_GIT_PATH="
    for /f "delims=" %%p in ('where git 2^>nul') do (
        set "SYS_GIT_PATH=%%p"
        goto :git_found
    )
    :git_found
    if not defined SYS_GIT_PATH (
        echo.
        echo  [ERROR] RUNTIME_MODE=%RUNTIME_MODE% but Git is not found on PATH!
        echo         Install Git for Windows, or switch back to portable mode.
        echo.
        echo         Quick fix:  run  switch-runtime.cmd
        echo.
        pause
        exit /b 1
    )
    set "CLAUDE_CODE_GIT_BASH_PATH="
    if exist "C:\Program Files\Git\bin\bash.exe" (
        set "CLAUDE_CODE_GIT_BASH_PATH=C:\Program Files\Git\bin\bash.exe"
    ) else if exist "C:\Program Files (x86)\Git\bin\bash.exe" (
        set "CLAUDE_CODE_GIT_BASH_PATH=C:\Program Files (x86)\Git\bin\bash.exe"
    ) else (
        for %%d in ("!SYS_GIT_PATH!") do set "SYS_GIT_DIR=%%~dpD"
        set "SYS_GIT_DIR=!SYS_GIT_DIR:~0,-1!"
        if exist "!SYS_GIT_DIR!\..\bin\bash.exe" (
            for %%d in ("!SYS_GIT_DIR!\..") do set "GIT_ROOT=%%~fpD"
            set "CLAUDE_CODE_GIT_BASH_PATH=!GIT_ROOT!\bin\bash.exe"
        )
    )
    set "GIT_LABEL=[system] !SYS_GIT_PATH!"
)

::: ============================================================
:::  Set up common environment
::: ============================================================
set "DISABLE_INSTALLATION_CHECKS=1"
set "HOME=!PORTABLE_ROOT!\data\home"
if not exist "!HOME!" mkdir "!HOME!"
if not exist "!PORTABLE_ROOT!\data\npm-cache" mkdir "!PORTABLE_ROOT!\data\npm-cache"

::: ============================================================
:::  Build PATH
::: ============================================================
set "SYS_MIN_PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0"

if "!USE_PORTABLE_NODE!"=="1" if "!USE_PORTABLE_GIT!"=="1" (
    set "PATH=!NODE_DIR!;!NPM_DIR!;!GIT_CMD_DIR!;!GIT_BIN_DIR!;!GIT_USR_BIN_DIR!;!GIT_MINGW_BIN_DIR!;!SYS_MIN_PATH!"
) else if "!USE_PORTABLE_NODE!"=="1" if "!USE_PORTABLE_GIT!"=="0" (
    set "PATH=!NODE_DIR!;!NPM_DIR!;!ORIG_PATH!"
) else if "!USE_PORTABLE_NODE!"=="0" if "!USE_PORTABLE_GIT!"=="1" (
    set "PATH=!GIT_CMD_DIR!;!GIT_BIN_DIR!;!GIT_USR_BIN_DIR!;!GIT_MINGW_BIN_DIR!;!ORIG_PATH!"
) else (
    set "PATH=!ORIG_PATH!"
)

::: ============================================================
:::  Verify runtime components (portable only)
::: ============================================================
set "HAS_ERROR=0"

if "!USE_PORTABLE_NODE!"=="1" (
    if not exist "!NODE_DIR!\node.exe" (
        echo [ERROR] Portable Node.js not found at: !NODE_DIR!\node.exe
        echo         Run build.cmd or switch to system mode.
        set "HAS_ERROR=1"
    )
    if not exist "!NPM_DIR!\claude.cmd" (
        echo [ERROR] Portable Claude Code not found at: !NPM_DIR!\claude.cmd
        echo         Run update.cmd or build.cmd first.
        set "HAS_ERROR=1"
    )
)

if "!USE_PORTABLE_GIT!"=="1" (
    if not exist "!GIT_BIN_DIR!\bash.exe" (
        echo [ERROR] Portable Git Bash not found at: !GIT_BIN_DIR!\bash.exe
        echo         Ensure PortableGit is in runtime\git\
        set "HAS_ERROR=1"
    )
)

if "!HAS_ERROR!"=="1" (
    echo.
    echo  One or more errors detected. Cannot start Claude Code.
    echo.
    echo  Quick fix:  run  switch-runtime.cmd  to change runtime mode.
    echo.
    pause
    exit /b 1
)

::: ============================================================
:::  Launch Claude Code
::: ============================================================
echo.
echo  Starting Claude Code...
echo  ------------------------------------------
echo   Mode:  !RUNTIME_MODE!
if "!USE_PORTABLE_NODE!"=="1" (
    echo   Node:  !NODE_DIR!\node.exe [portable]
) else (
    echo   Node:  !NODE_LABEL!
)
if "!USE_PORTABLE_GIT!"=="1" (
    echo   Git:   !GIT_DIR! [portable]
) else (
    echo   Git:   !GIT_LABEL!
)
echo   Home:  !HOME!
echo  ------------------------------------------
echo.

"!CLAUDE_CMD!" %*
set "CLAUDE_EXIT=!ERRORLEVEL!"

if not "!CLAUDE_EXIT!"=="0" (
    echo.
    echo  [!] Claude Code exited with error code: !CLAUDE_EXIT!
    echo.
    pause
) else (
    echo.
    echo  Claude Code has exited.
)

endlocal
