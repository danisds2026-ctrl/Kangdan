@echo off
:: 1. MEMASTIKAN HAK AKSES ADMINISTRATOR
echo Memeriksa hak akses Administrator...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [EROR] Klik kanan file ini lalu pilih 'Run as administrator'!
    echo.
    pause
    exit
)

echo ====================================================================
echo   PEMBERSIH TOTAL: RESET REGISTRY POLICIES ^& GROUP POLICY EDITOR
echo ====================================================================
echo.

:: 2. PROSES RESET GROUP POLICY EDITOR (GPEDIT)
echo [1/3] Menghapus database kebijakan Group Policy...
if exist "%WinDir%\System32\GroupPolicy" (
    RD /S /Q "%WinDir%\System32\GroupPolicy"
)
if exist "%WinDir%\System32\GroupPolicyUsers" (
    RD /S /Q "%WinDir%\System32\GroupPolicyUsers"
)
echo OK: Database Group Policy telah dibersihkan.
echo.

:: 3. PROSES PENGHAPUSAN BATASAN REGISTRY (REGEDIT)
echo [2/3] Menghapus folder kebijakan pembatasan di Registry...
reg delete "HKEY_CURRENT_USER\Software\Policies" /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies" /f >nul 2>&1

:: Memastikan fitur-fitur vital Windows langsung terbuka secara spesifik
echo Memulihkan akses fitur utama (CMD, Regedit, Task Manager)...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\LocalUser\Software\Policies\Microsoft\Windows\System" /v DisableCMD /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 0 /f >nul 2>&1
echo OK: Batasan Registry berhasil dipulihkan.
echo.

:: 4. MEMAKSA WINDOWS MENERAPKAN PERUBAHAN
echo [3/3] Menyegarkan sistem kebijakan Windows (Group Policy Update)...
gpupdate /force
echo.

echo ====================================================================
echo   PROSES BERHASIL SELESAI!
echo   Semua batasan Registry ^& Group Policy telah dinonaktifkan.
echo   Disarankan untuk me-restart PC Anda agar efeknya maksimal.
echo ====================================================================
echo.
pause
exit