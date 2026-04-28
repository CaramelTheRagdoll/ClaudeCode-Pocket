@echo off
chcp 65001 >nul 2>&1
setlocal

::: ============================================================
:::  Claude Code Portable - Remove Right-Click Context Menu
:::  Removes "Open Claude Code Here" from Windows Explorer
::: ============================================================

echo ============================================
echo  Claude Code Portable - Remove Context Menu
echo ============================================
echo.

set "REG_DIR=HKCU\Software\Classes\Directory\Background\shell\ClaudeCodePortable"
set "REG_DIR_FOLDER=HKCU\Software\Classes\Directory\shell\ClaudeCodePortable"

::: --- Remove: Folder background ---
reg delete "%REG_DIR%" /f >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   [OK] Folder background context menu removed.
) else (
    echo   [INFO] Folder background context menu not found (already removed).
)

::: --- Remove: Folder itself ---
reg delete "%REG_DIR_FOLDER%" /f >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   [OK] Folder context menu removed.
) else (
    echo   [INFO] Folder context menu not found (already removed).
)

echo.
echo Context menu entries removed successfully.
echo.
pause
endlocal
