@echo off
setlocal
cd /d "%~dp0"

echo Memeriksa komponen Microsoft Visual C++ Runtime (x64)...
set "NEED_INSTALL=0"

if not exist "%SystemRoot%\System32\vcruntime140.dll" set "NEED_INSTALL=1"
if not exist "%SystemRoot%\System32\msvcp140.dll" set "NEED_INSTALL=1"

if "%NEED_INSTALL%"=="1" (
    echo Komponen vcruntime140.dll / msvcp140.dll tidak ditemukan.
    if exist "%~dp0redist\vc_redist.x64.exe" (
        echo Menginstall vc_redist.x64.exe secara otomatis...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~dp0redist\vc_redist.x64.exe' -ArgumentList '/install /passive /norestart' -Verb RunAs -Wait"
    ) else if exist "%~dp0vc_redist.x64.exe" (
        echo Menginstall vc_redist.x64.exe secara otomatis...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~dp0vc_redist.x64.exe' -ArgumentList '/install /passive /norestart' -Verb RunAs -Wait"
    ) else (
        echo Mengunduh dan menginstall vc_redist.x64.exe...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Join-Path $env:TEMP 'vc_redist.x64.exe'; Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x64.exe' -OutFile $p; Start-Process -FilePath $p -ArgumentList '/install /passive /norestart' -Verb RunAs -Wait"
    )
) else (
    echo Komponen Visual C++ Runtime sudah terpasang.
)

if exist "%~dp0depoma.exe" (
    echo Menjalankan BILYET DEPO APP...
    start "" "%~dp0depoma.exe"
) else (
    echo File depoma.exe tidak ditemukan di folder ini.
    pause
)
endlocal
