@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

::: ============================================================
:::  Claude Code Portable - Runtime Mode Switcher
::: ============================================================

set "PORTABLE_ROOT=%~dp0"
set "PORTABLE_ROOT=%PORTABLE_ROOT:~0,-1%"
set "INI_FILE=%PORTABLE_ROOT%\portable.ini"

::: --- Read current mode ---
set "CURRENT_MODE=portable"
if exist "%INI_FILE%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%INI_FILE%") do (
        set "LINE=%%a"
        if "!LINE:~0,1!" neq ";" if "!LINE:~0,1!" neq " " (
            if /i "%%a"=="RUNTIME_MODE" set "CURRENT_MODE=%%b"
        )
    )
)
set "CURRENT_MODE=%CURRENT_MODE: =%"

::: --- Detect system runtimes ---
set "SYS_NODE_VER=not installed"
set "SYS_GIT_VER=not installed"

for /f "delims=" %%v in ('node --version 2^>nul') do set "SYS_NODE_VER=%%v"
for /f "tokens=2 delims= " %%v in ('git --version 2^>nul') do set "SYS_GIT_VER=%%v"

::: --- Detect portable runtimes ---
set "PORT_NODE_VER=not installed"
set "PORT_GIT_VER=not installed"

if exist "%PORTABLE_ROOT%\runtime\node\node.exe" (
    for /f "delims=" %%v in ('"%PORTABLE_ROOT%\runtime\node\node.exe" --version 2^>nul') do set "PORT_NODE_VER=%%v"
)
if exist "%PORTABLE_ROOT%\runtime\git\cmd\git.exe" (
    for /f "tokens=2 delims= " %%v in ('"%PORTABLE_ROOT%\runtime\git\cmd\git.exe" --version 2^>nul') do set "PORT_GIT_VER=%%v"
)

::: --- Display status ---
echo.
echo  +======================================================+
echo  ^|   Runtime Mode Switcher                              ^|
echo  +======================================================+
echo.
echo  Current mode: %CURRENT_MODE%
echo.
echo  +------------------------------------------------------+
echo  ^|  Available Runtimes                                  ^|
echo  +------------------------------------------------------+
echo  ^|                                                      ^|
echo  ^|  Portable:                                           ^|
echo  ^|    Node.js  %PORT_NODE_VER%                                 ^|
echo  ^|    Git      %PORT_GIT_VER%                          ^|
echo  ^|                                                      ^|
echo  ^|  System:                                             ^|
echo  ^|    Node.js  %SYS_NODE_VER%                                 ^|
echo  ^|    Git      %SYS_GIT_VER%                          ^|
echo  ^|                                                      ^|
echo  +------------------------------------------------------+
echo.
echo  Select runtime mode:
echo.
echo    [1]  portable   -- Portable Node.js + Portable Git (default)
echo                      Zero system dependency, U-disk friendly
echo.
echo    [2]  system     -- System Node.js + System Git
echo                      Uses whatever is installed on this machine
echo.
echo    [3]  hybrid     -- Portable Node.js + System Git
echo                      Use portable Claude Code but system Git
echo.
echo    [0]  Cancel
echo.

set /p "CHOICE=Enter choice [0-3]: "

if "%CHOICE%"=="1" set "NEW_MODE=portable"
if "%CHOICE%"=="2" set "NEW_MODE=system"
if "%CHOICE%"=="3" set "NEW_MODE=hybrid"
if "%CHOICE%"=="0" (
    echo.
    echo  Cancelled.
    pause
    exit /b 0
)

if not defined NEW_MODE (
    echo.
    echo  Invalid choice.
    pause
    exit /b 1
)

::: --- Validate system runtimes when needed ---
if "%NEW_MODE%"=="system" (
    if "%SYS_NODE_VER%"=="not installed" (
        echo.
        echo  [ERROR] Cannot use system mode: Node.js not found on PATH!
        echo          Install Node.js first, or choose a different mode.
        pause
        exit /b 1
    )
    if "%SYS_GIT_VER%"=="not installed" (
        echo.
        echo  [ERROR] Cannot use system mode: Git not found on PATH!
        echo          Install Git for Windows first, or choose a different mode.
        pause
        exit /b 1
    )
)

if "%NEW_MODE%"=="hybrid" (
    if "%PORT_NODE_VER%"=="not installed" (
        echo.
        echo  [ERROR] Cannot use hybrid mode: Portable Node.js not found!
        echo          Run build.cmd first, or choose a different mode.
        pause
        exit /b 1
    )
    if "%SYS_GIT_VER%"=="not installed" (
        echo.
        echo  [ERROR] Cannot use hybrid mode: System Git not found on PATH!
        echo          Install Git for Windows first, or choose a different mode.
        pause
        exit /b 1
    )
)

::: --- Write to portable.ini ---
(
echo ; Claude Code Portable - Runtime Configuration
echo ; 
echo ; RUNTIME_MODE controls which Node.js and Git are used:
echo ;
echo ;   portable  = Use bundled Node.js + Git ^(default, zero system dependency^)
echo ;   system    = Use system-installed Node.js + Git ^(must be on PATH^)
echo ;   hybrid    = Use portable Node.js + system Git
echo ;               ^(useful when system Git is newer/different^)
echo ;
echo ; Change this value manually, or run switch-runtime.cmd to toggle.
echo.
echo RUNTIME_MODE=%NEW_MODE%
) > "%INI_FILE%"

echo.
echo  +------------------------------------------------------+
echo  ^|  [OK] Runtime mode changed: %CURRENT_MODE% -^> %NEW_MODE%
echo  ^|                                                      ^|
if "%NEW_MODE%"=="portable" (
    echo  ^|  Now using: Portable Node.js + Portable Git        ^|
    echo  ^|  No system dependencies required.                   ^|
)
if "%NEW_MODE%"=="system" (
    echo  ^|  Now using: System Node.js + System Git             ^|
    echo  ^|  Make sure both remain on PATH.                     ^|
)
if "%NEW_MODE%"=="hybrid" (
    echo  ^|  Now using: Portable Node.js + System Git           ^|
    echo  ^|  Claude Code from portable, Git from system.        ^|
)
echo  ^|                                                      ^|
echo  ^|  Restart claude.cmd for the change to take effect.   ^|
echo  +------------------------------------------------------+
echo.
pause
endlocal
