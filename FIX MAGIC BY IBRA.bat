@echo off
title FIX MAGIC BY IBRA
echo FIX MAGIC BY IBRA
timeout /t 2 >nul

echo 1. [Memulai eksekusi system]
powershell -ExecutionPolicy Bypass -Command "Remove-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies' -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies' -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path 'HKCU:\Software\Policies\Microsoft\Windows' -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path 'HKLM:\Software\Policies\Microsoft\Windows' -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path '%WinDir%\System32\GroupPolicy' -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path '%WinDir%\System32\GroupPolicyUsers' -Recurse -Force -ErrorAction SilentlyContinue; $LangList = Get-WinUserLanguageList; $LangList[0].InputMethodTips.Clear(); $LangList[0].InputMethodTips.Add('0409:00000409'); Set-WinUserLanguageList $LangList -Force -ErrorAction SilentlyContinue; Set-WinDefaultInputMethodOverride -InputTip '0409:00000409' -ErrorAction SilentlyContinue; Stop-Process -Name explorer -Force; Start-Process explorer;"

echo 2. [Membersihkan System] - Selesai
echo 3. [Refresh Desktop] - Selesai
echo.
echo PROSES SELESAI. KLIK TOMBOL APAPUN UNTUK KELUAR...
pause >nul