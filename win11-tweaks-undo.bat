@echo off
setlocal EnableExtensions DisableDelayedExpansion

:: ===========================================================================
::  Windows 11 One-Click Tweaks - Undo
::  https://github.com/tahaexe/win11-one-click-tweaks
::
::  Puts every setting changed by win11-tweaks.bat back to the Windows
::  default and switches the power plan back to Balanced.
::
::  Usage : win11-tweaks-undo.bat         undo everything (asks for admin rights)
::          win11-tweaks-undo.bat /dry    only list what would change
::
::  Messages are Turkish on Turkish Windows and English everywhere else.
::  Set TWEAKS_LANG=en or TWEAKS_LANG=tr to pick one yourself.
:: ===========================================================================

:: Remember the console code page so it can be restored, then switch to UTF-8.
for /f "tokens=2 delims=:." %%C in ('chcp') do set "OLDCP=%%C"
chcp 65001 >nul

set "DRYRUN="
if /i "%~1"=="/dry" set "DRYRUN=1"

call :messages

:: The search policy and the power plan need administrator rights.
if defined DRYRUN goto :main
fltmc >nul 2>&1 && goto :main
echo(%M_ELEVATE%
set "SELF=%~f0"
powershell -NoProfile -Command "Start-Process -FilePath '%SELF:'=''%' -Verb RunAs" >nul 2>&1 && goto :end
echo(%M_NEED_ADMIN%
pause
goto :end

:main
set "FAILS=0"
set "SEARCH=HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings"
set "CDM=HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
set "UP_OWN=6d3f2b8e-41c7-4f0a-9e5d-2b7c8a1f4e93"
set "BALANCED=381b4222-f694-41f0-9685-ff5bb260df2e"

echo(
echo(==================================================
echo(  %M_TITLE%
echo(==================================================
echo(
if defined DRYRUN echo(%M_DRY%& echo(

call :step 1 "%M_S1%"
call :delvalue "HKCU\Software\Policies\Microsoft\Windows\Explorer" DisableSearchBoxSuggestions
call :result

call :step 2 "%M_S2%"
call :run reg add "%SEARCH%" /v IsMSACloudSearchEnabled /t REG_DWORD /d 1 /f
call :run reg add "%SEARCH%" /v IsAADCloudSearchEnabled /t REG_DWORD /d 1 /f
call :result

call :step 3 "%M_S3%"
call :run reg add "%SEARCH%" /v IsDynamicSearchBoxEnabled /t REG_DWORD /d 1 /f
call :result

call :step 4 "%M_S4%"
call :run reg add "%CDM%" /v SubscribedContent-338393Enabled /t REG_DWORD /d 1 /f
call :run reg add "%CDM%" /v SubscribedContent-353694Enabled /t REG_DWORD /d 1 /f
call :run reg add "%CDM%" /v SubscribedContent-353696Enabled /t REG_DWORD /d 1 /f
call :result

call :step 5 "%M_S5%"
call :delvalue "HKCU\Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications" EnableAccountNotifications
call :result

call :step 6 "%M_S6%"
call :delkey "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
call :result

call :step 7 "%M_S7%"
call :run powercfg /setactive %BALANCED%
call :delscheme %UP_OWN%
call :result

if defined DRYRUN echo(%M_DRY_DONE%& goto :end
echo(
if %FAILS% neq 0 goto :some_failed
echo(%M_ALL_OK%
goto :restart
:some_failed
echo(%M_SOME_FAILED% %FAILS%
:restart
echo(%M_RESTART_NOTE%
echo(
choice /c %M_KEYS% /n /m "%M_RESTART_ASK% "
if errorlevel 2 goto :end
shutdown /r /t 5
goto :end

:end
if defined OLDCP chcp %OLDCP% >nul
endlocal
exit /b

:: ---------------------------------------------------------------------------
:: Deletes a registry value, a registry key or a power plan only if it exists.
:delvalue
reg query "%~1" /v %~2 >nul 2>&1 || goto :nothing
call :run reg delete "%~1" /v %~2 /f
exit /b

:delkey
reg query "%~1" >nul 2>&1 || goto :nothing
call :run reg delete "%~1" /f
exit /b

:: Only the plan win11-tweaks.bat created is deleted; a plan you made stays.
:delscheme
powercfg /query %~1 >nul 2>&1 || exit /b
call :run powercfg /delete %~1
exit /b

:nothing
if defined DRYRUN echo(      %M_NOTHING%
exit /b

:: ---------------------------------------------------------------------------
:step
set "STEP_FAILED="
if defined DRYRUN goto :step_dry
<nul set /p "=[%~1/7] %~2 ... "
exit /b
:step_dry
echo([%~1/7] %~2
exit /b

:: Runs a command quietly and remembers a failure. In dry-run mode it only
:: prints the command.
:run
if defined DRYRUN goto :run_dry
%* >nul 2>&1 || set "STEP_FAILED=1"
exit /b
:run_dry
echo(      %*
exit /b

:result
if defined DRYRUN echo(& exit /b
if defined STEP_FAILED goto :result_failed
echo(%M_OK%
exit /b
:result_failed
echo(%M_FAILED%
set /a FAILS+=1
exit /b

:: ---------------------------------------------------------------------------
:messages
set "UILANG=en"
for /f %%L in ('powershell -NoProfile -Command "[Globalization.CultureInfo]::CurrentUICulture.TwoLetterISOLanguageName" 2^>nul') do set "UILANG=%%L"
if defined TWEAKS_LANG set "UILANG=%TWEAKS_LANG%"
if /i "%UILANG%"=="tr" goto :messages_tr
set "M_TITLE=Windows 11 One-Click Tweaks - Undo"
set "M_ELEVATE=Asking for administrator rights..."
set "M_NEED_ADMIN=Administrator rights are required. Run the file again and click Yes."
set "M_DRY=DRY RUN - nothing will change. Commands that would run:"
set "M_S1=Start search: turn web results back on"
set "M_S2=Start search: turn cloud content back on"
set "M_S3=Start search: turn search highlights back on"
set "M_S4=Settings: turn suggestions and offers back on"
set "M_S5=Settings: turn account notifications back on"
set "M_S6=Bring back the Windows 11 right-click menu"
set "M_S7=Power plan: switch back to Balanced"
set "M_NOTHING=already the Windows default, nothing to change"
set "M_OK=OK"
set "M_FAILED=FAILED"
set "M_ALL_OK=All done."
set "M_SOME_FAILED=Steps that failed:"
set "M_RESTART_NOTE=Restart the PC so that every change takes effect."
set "M_RESTART_ASK=Restart now? [Y/N]"
set "M_KEYS=YN"
set "M_DRY_DONE=Dry run finished. Nothing was changed."
exit /b

:messages_tr
set "M_TITLE=Windows 11 Tek Tıkla Ayarlar - Geri Al"
set "M_ELEVATE=Yönetici izni isteniyor..."
set "M_NEED_ADMIN=Yönetici izni gerekli. Dosyayı yeniden çalıştırıp Evet'e tıklayın."
set "M_DRY=DENEME MODU - hiçbir şey değişmeyecek. Çalışacak komutlar:"
set "M_S1=Başlat araması: internet sonuçlarını geri aç"
set "M_S2=Başlat araması: hesap içeriklerini geri aç"
set "M_S3=Başlat araması: arama vurgularını geri aç"
set "M_S4=Ayarlar: öneri ve teklifleri geri aç"
set "M_S5=Ayarlar: hesap bildirimlerini geri aç"
set "M_S6=Windows 11 sağ tık menüsünü geri getir"
set "M_S7=Güç planı: Dengeli'ye geri dön"
set "M_NOTHING=zaten Windows varsayılanı, değişecek bir şey yok"
set "M_OK=TAMAM"
set "M_FAILED=HATA"
set "M_ALL_OK=Hepsi tamam."
set "M_SOME_FAILED=Başarısız adım sayısı:"
set "M_RESTART_NOTE=Değişikliklerin hepsinin geçerli olması için bilgisayarı yeniden başlatın."
set "M_RESTART_ASK=Şimdi yeniden başlatılsın mı? [E/H]"
set "M_KEYS=EH"
set "M_DRY_DONE=Deneme bitti. Hiçbir şey değişmedi."
exit /b
