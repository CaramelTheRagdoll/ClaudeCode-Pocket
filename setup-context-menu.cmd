@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

::: ============================================================
:::  Claude Code Portable - Register Right-Click Context Menu
:::  Adds "Open Claude Code Here" to Windows Explorer context menu
:::  Uses HKCU (no UAC/elevation required)
:::  
:::  NOTE: Context menu uses absolute paths. If you move the
:::  portable folder, re-run this script to update the paths.
::: ============================================================

echo ============================================
echo  Claude Code Portable - Context Menu Setup
echo ============================================
echo.

::: --- Resolve portable root ---
set "PORTABLE_ROOT=%~dp0"
set "PORTABLE_ROOT=%PORTABLE_ROOT:~0,-1%"

::: --- Verify launcher.cmd exists ---
if not exist "%PORTABLE_ROOT%\launcher.cmd" (
    echo [ERROR] launcher.cmd not found at: %PORTABLE_ROOT%\launcher.cmd
    echo Please ensure this script is in the Claude Code Portable root directory.
    echo.
    pause
    exit /b 1
)

::: --- Define registry paths ---
set "REG_DIR=HKCU\Software\Classes\Directory\Background\shell\ClaudeCodePortable"
set "REG_DIR_FOLDER=HKCU\Software\Classes\Directory\shell\ClaudeCodePortable"

::: --- The commands ---
::: Use cmd.exe so the window stays open after Claude exits
set "CMD_BG=cmd.exe /k \"\"%PORTABLE_ROOT%\launcher.cmd\" \"%%V\"\""
set "CMD_FOLDER=cmd.exe /k \"\"%PORTABLE_ROOT%\launcher.cmd\" \"%%1\"\""

echo Registering context menu entries...
echo   Portable root: %PORTABLE_ROOT%
echo.

::: --- Register: Right-click on folder BACKGROUND ---
reg delete "%REG_DIR%" /f >nul 2>&1
reg add "%REG_DIR%" /ve /d "Open Claude Code Here" /f >nul 2>&1
reg add "%REG_DIR%" /v "Icon" /d "%PORTABLE_ROOT%\runtime\node\node.exe" /f >nul 2>&1
reg add "%REG_DIR%\command" /ve /d "%CMD_BG%" /f >nul 2>&1

if !ERRORLEVEL! equ 0 (
    echo   [OK] Folder background context menu registered.
) else (
    echo   [FAIL] Could not register folder background context menu.
)

::: --- Register: Right-click on a FOLDER ---
reg delete "%REG_DIR_FOLDER%" /f >nul 2>&1
reg add "%REG_DIR_FOLDER%" /ve /d "Open Claude Code Here" /f >nul 2>&1
reg add "%REG_DIR_FOLDER%" /v "Icon" /d "%PORTABLE_ROOT%\runtime\node\node.exe" /f >nul 2>&1
reg add "%REG_DIR_FOLDER%\command" /ve /d "%CMD_FOLDER%" /f >nul 2>&1

if !ERRORLEVEL! equ 0 (
    echo   [OK] Folder context menu registered.
) else (
    echo   [FAIL] Could not register folder context menu.
)

echo.
echo ============================================
echo  Context menu registration complete!
echo.
echo  You can now right-click in any folder and
echo  select "Open Claude Code Here" to launch.
echo.
echo  NOTE: If you move this portable folder,
echo  re-run this script to update the paths.
echo ============================================
echo.
pause
endlocal
