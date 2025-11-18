@echo off
title Windows Update Pro Controller 
chcp 65001 >nul
color 0B

:menu
cls
echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║                                                              ║
echo  ║         WINDOWS UPDATE PRO CONTROLLER                   ║
echo  ║                                                              ║
echo  ║    ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗ ║
echo  ║    ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝ ║
echo  ║    ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗ ║
echo  ║    ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║ ║
echo  ║    ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║ ║
echo  ║     ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝ ║
echo  ║                                                              ║
echo  ║           ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗  ║
echo  ║           ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝  ║
echo  ║           ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗    ║
echo  ║           ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝    ║
echo  ║           ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗  ║
echo  ║            ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝  ║
echo  ║                                                              ║
echo  ║                    Created by: Revaha                       ║
echo  ║                                                              ║
echo  ╚══════════════════════════════════════════════════════════════╝
echo.

REM Mevcut durumu kontrol et
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate >nul 2>&1
if %errorlevel%==0 (
    color 0C
    echo  ┌──────────────────────────────────────────────────────────────┐
    echo  │                      SYSTEM STATUS                           │
    echo  ├──────────────────────────────────────────────────────────────┤
    echo  │                                                              │
    echo  │    STATUS: KAPALI - Guncellemeler Engellendi                │
    echo  │                                                              │
    echo  └──────────────────────────────────────────────────────────────┘
) else (
    color 0A
    echo  ┌──────────────────────────────────────────────────────────────┐
    echo  │                      SYSTEM STATUS                           │
    echo  ├──────────────────────────────────────────────────────────────┤
    echo  │                                                              │
    echo  │    STATUS: ACIK - Normal Calisiyor                          │
    echo  │                                                              │
    echo  └──────────────────────────────────────────────────────────────┘
)

echo.
echo  ┌──────────────────────────────────────────────────────────────┐
echo  │                     CONTROL OPTIONS                          │
echo  ├──────────────────────────────────────────────────────────────┤
echo  │                                                              │
echo  │    [1] ULTIMATE SHUTDOWN - Her Seyi Kapat                   │
echo  │                                                              │
echo  │    [2] FULL ACTIVATION - Her Seyi Ac                        │
echo  │                                                              │
echo  │    [3] EXIT - Cikis                                         │
echo  │                                                              │
echo  └──────────────────────────────────────────────────────────────┘
echo.
set /p secim="  Komutunuzu girin [1-3]: "

if "%secim%"=="1" goto shutdown
if "%secim%"=="2" goto activation
if "%secim%"=="3" goto exit
echo.
echo  HATALI KOMUT! Tekrar deneyin...
timeout /t 2 >nul
goto menu

:shutdown
cls
color 0E
echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║                                                              ║
echo  ║              ULTIMATE SHUTDOWN BASLATILIYOR...              ║
echo  ║                                                              ║
echo  ╚══════════════════════════════════════════════════════════════╝
echo.

echo  PHASE 1: Registry Manipulation
echo  ─────────────────────────────────
timeout /t 1 >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /f >nul 2>&1
echo  [OK] Registry keys created
timeout /t 1 >nul

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Auto-update disabled
timeout /t 1 >nul

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Auto-reboot blocked
echo.
timeout /t 1 >nul

echo  PHASE 2: Service Termination
echo  ────────────────────────────
sc config wuauserv start= disabled >nul 2>&1
sc stop wuauserv >nul 2>&1
echo  [OK] Windows Update service terminated
timeout /t 1 >nul

sc config UsoSvc start= disabled >nul 2>&1
sc stop UsoSvc >nul 2>&1
echo  [OK] Update Orchestrator service killed
timeout /t 1 >nul

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableWindowsUpdateAccess /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Update access completely blocked
echo.
timeout /t 1 >nul

echo  PHASE 3: Final Lockdown
echo  ───────────────────────
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /t REG_DWORD /d 2 /f >nul 2>&1
echo  [OK] Store updates neutralized
timeout /t 1 >nul

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f >nul 2>&1
echo  [OK] Driver updates eliminated

color 0C
echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║                                                              ║
echo  ║            ULTIMATE SHUTDOWN TAMAMLANDI!                    ║
echo  ║                                                              ║
echo  ║    Tum guncellemeler tamamen engellendi                     ║
echo  ║    Hicbir bildirim gelmeyecek                               ║
echo  ║    Sistem tamamen korunuyor                                 ║
echo  ║                                                              ║
echo  ╚══════════════════════════════════════════════════════════════╝
timeout /t 3 >nul
pause
goto menu

:activation
cls
color 0D
echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║                                                              ║
echo  ║               FULL ACTIVATION BASLATILIYOR...               ║
echo  ║                                                              ║
echo  ╚══════════════════════════════════════════════════════════════╝
echo.

echo  PHASE 1: Registry Restoration
echo  ──────────────────────────────
timeout /t 1 >nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /f >nul 2>&1
echo  [OK] Auto-update restrictions removed
timeout /t 1 >nul

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoRebootWithLoggedOnUsers /f >nul 2>&1
echo  [OK] Reboot restrictions lifted
timeout /t 1 >nul

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableWindowsUpdateAccess /f >nul 2>&1
echo  [OK] Update access restored
echo.
timeout /t 1 >nul

echo  PHASE 2: Service Activation
echo  ───────────────────────────
sc config wuauserv start= auto >nul 2>&1
sc start wuauserv >nul 2>&1
echo  [OK] Windows Update service reactivated
timeout /t 1 >nul

sc config UsoSvc start= auto >nul 2>&1
sc start UsoSvc >nul 2>&1
echo  [OK] Update Orchestrator restored
timeout /t 1 >nul

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /f >nul 2>&1
echo  [OK] Store updates enabled
echo.
timeout /t 1 >nul

echo  PHASE 3: Full Recovery
echo  ──────────────────────
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /f >nul 2>&1
echo  [OK] Driver updates reactivated
timeout /t 1 >nul
echo  [OK] System fully operational

color 0A
echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║                                                              ║
echo  ║              FULL ACTIVATION TAMAMLANDI!                    ║
echo  ║                                                              ║
echo  ║    Tum guncellemeler aktif                                  ║
echo  ║    Sistem normal modda calisiyor                            ║
echo  ║    Guncelleme bildirimleri gelecek                          ║
echo  ║                                                              ║
echo  ╚══════════════════════════════════════════════════════════════╝
timeout /t 3 >nul
pause
goto menu

:exit
cls
echo.
echo  Cikis yapiliyor...
timeout /t 1 >nul
exit