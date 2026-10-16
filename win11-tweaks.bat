@echo off
setlocal EnableExtensions DisableDelayedExpansion

:: ===========================================================================
::  Windows 11 One-Click Tweaks
::  https://github.com/tahaexe/win11-one-click-tweaks
::
::  Start search  : no web results, no cloud content, no search highlights
::  Start menu    : no recommendations (tips, new apps)
::  Settings      : no suggestions and offers (Microsoft 365 ad),
::                  no account notifications
::  Notifications : no Windows tips and suggestions
::  File Explorer : no OneDrive and Microsoft 365 promotions,
::                  classic (Windows 10 style) right-click menu
::  Taskbar       : "End task" when you right-click an app
::  Keyboard      : no Sticky Keys prompt after pressing Shift 5 times
::  Power         : Ultimate Performance power plan
::
::  Usage : win11-tweaks.bat          apply everything (asks for admin rights)
::          win11-tweaks.bat /dry     only list what would change
::  Undo  : win11-tweaks-undo.bat
::
::  Messages are Turkish on Turkish Windows and English everywhere else.
::  Set TWEAKS_LANG=en or TWEAKS_LANG=tr to pick one yourself.
:: ===========================================================================

:: Remember the console code page so it can be restored, then switch to UTF-8.
for /f "tokens=2 delims=:." %%C in ('chcp') do set "OLDCP=%%C"
chcp 65001 >nul

:: /dry      only list the commands
:: /sid SID  account whose settings are changed (passed to the elevated copy)
set "DRYRUN="
set "USERSID="
:args
if "%~1"=="" goto :args_done
if /i "%~1"=="/dry" set "DRYRUN=1"
if /i "%~1"=="/sid" set "USERSID=%~2"& shift
shift
goto :args
:args_done

call :messages

:: The search policy and the power plan need administrator rights. The elevated
:: copy gets the SID of the account that started the script, so the settings
:: land in that account even when Windows elevates as another one
:: (Administrator protection, or an administrator approving the prompt).
if defined DRYRUN goto :main
fltmc >nul 2>&1 && goto :main
echo(%M_ELEVATE%
for /f "tokens=2 delims=," %%S in ('whoami /user /fo csv /nh') do set "USERSID=%%~S"
set "SELF=%~f0"
powershell -NoProfile -Command "Start-Process -FilePath '%SELF:'=''%' -ArgumentList '/sid %USERSID%' -Verb RunAs" >nul 2>&1 && goto :end
echo(%M_NEED_ADMIN%
pause
goto :end

:main
set "UREG=HKCU"
set "UCLASSES=HKCU\Software\Classes"
if defined USERSID set "UREG=HKU\%USERSID%"& set "UCLASSES=HKU\%USERSID%_Classes"
set "ADV=%UREG%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
set "SEARCH=%UREG%\Software\Microsoft\Windows\CurrentVersion\SearchSettings"
set "CDM=%UREG%\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
set "UP_TEMPLATE=e9a42b02-d5df-448d-aa00-03f14749eb61"
set "UP_OWN=6d3f2b8e-41c7-4f0a-9e5d-2b7c8a1f4e93"
set "TOTAL=12"
set "FAILS=0"

echo(
echo(==================================================
echo(  %M_TITLE%
echo(==================================================
echo(
if defined DRYRUN echo(%M_DRY%& echo(

call :step 1 "%M_S1%"
call :run reg add "%UREG%\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f
call :result

call :step 2 "%M_S2%"
call :run reg add "%SEARCH%" /v IsMSACloudSearchEnabled /t REG_DWORD /d 0 /f
call :run reg add "%SEARCH%" /v IsAADCloudSearchEnabled /t REG_DWORD /d 0 /f
call :result

call :step 3 "%M_S3%"
call :run reg add "%SEARCH%" /v IsDynamicSearchBoxEnabled /t REG_DWORD /d 0 /f
call :result

call :step 4 "%M_S4%"
call :run reg add "%ADV%" /v Start_IrisRecommendations /t REG_DWORD /d 0 /f
call :result

call :step 5 "%M_S5%"
call :run reg add "%CDM%" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f
call :run reg add "%CDM%" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f
call :run reg add "%CDM%" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f
call :result

call :step 6 "%M_S6%"
call :run reg add "%UREG%\Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications" /v EnableAccountNotifications /t REG_DWORD /d 0 /f
call :result

call :step 7 "%M_S7%"
call :run reg add "%CDM%" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f
call :run reg add "%CDM%" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f
call :run reg add "%UREG%\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f
call :result

call :step 8 "%M_S8%"
call :run reg add "%ADV%" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f
call :result

call :step 9 "%M_S9%"
call :run reg add "%UCLASSES%\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f
call :result

call :step 10 "%M_S10%"
call :run reg add "%ADV%\TaskbarDeveloperSettings" /v TaskbarEndTask /t REG_DWORD /d 1 /f
call :result

call :step 11 "%M_S11%"
call :stickykeys
call :result

call :step 12 "%M_S12%"
call :ultimate
call :result

echo(
if defined DRYRUN echo(%M_DRY_DONE%& goto :end
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
:: Sticky Keys: clear only the "shortcut on" bit (4) and keep everything else,
:: so Sticky Keys itself can still be turned on in Settings.
:stickykeys
set "SK=510"
for /f "tokens=3" %%F in ('reg query "%UREG%\Control Panel\Accessibility\StickyKeys" /v Flags 2^>nul ^| find "Flags"') do set "SK=%%F"
set /a "SK=SK & ~4"
call :run reg add "%UREG%\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d %SK% /f
exit /b

:: Ultimate Performance: reuse a plan that already exists, otherwise create one.
:: The plan name is read from powercfg, so this works in every language.
:ultimate
set "UP_NAME="
set "UP_GUID="
for /f "tokens=1* delims=:" %%A in ('powercfg /query %UP_TEMPLATE% 2^>nul') do if not defined UP_NAME call :scheme_name "%%B"
if defined UP_NAME for /f "tokens=1* delims=:" %%A in ('powercfg /list') do if not defined UP_GUID call :scheme_match "%%B"
if defined UP_GUID goto :ultimate_activate
set "UP_GUID=%UP_OWN%"
call :run powercfg /duplicatescheme %UP_TEMPLATE% %UP_GUID%
:ultimate_activate
call :run powercfg /setactive %UP_GUID%
exit /b

:: Takes " guid  (Name)" and keeps Name.
:scheme_name
for /f "tokens=2 delims=()" %%N in ("%~1") do set "UP_NAME=%%N"
exit /b

:: Takes " guid  (Name) *" and keeps guid when Name is the Ultimate Performance name.
:scheme_match
for /f "tokens=1,2 delims=()" %%X in ("%~1") do if "%%Y"=="%UP_NAME%" for /f %%G in ("%%X") do set "UP_GUID=%%G"
exit /b

:: ---------------------------------------------------------------------------
:step
set "STEP_FAILED="
set "STEP_NO=%~1"
if %~1 lss 10 set "STEP_NO= %~1"
if defined DRYRUN goto :step_dry
<nul set /p "=[%STEP_NO%/%TOTAL%] %~2 ... "
exit /b
:step_dry
echo([%STEP_NO%/%TOTAL%] %~2
exit /b

:: Runs a command quietly and remembers a failure. In dry-run mode it only
:: prints the command.
:run
if defined DRYRUN goto :run_dry
%* >nul 2>&1 || set "STEP_FAILED=1"
exit /b
:run_dry
echo(        %*
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
set "M_TITLE=Windows 11 One-Click Tweaks"
set "M_ELEVATE=Asking for administrator rights..."
set "M_NEED_ADMIN=Administrator rights are required. Run the file again and click Yes."
set "M_DRY=DRY RUN - nothing will change. Commands that would run:"
set "M_S1=Start search: turn off web results"
set "M_S2=Start search: turn off cloud content (Microsoft, work/school)"
set "M_S3=Start search: turn off search highlights"
set "M_S4=Start menu: turn off recommendations (tips, new apps)"
set "M_S5=Settings: turn off suggestions and offers (Microsoft 365 ad)"
set "M_S6=Settings: turn off account notifications"
set "M_S7=Notifications: turn off Windows tips and suggestions"
set "M_S8=File Explorer: turn off OneDrive and Microsoft 365 promotions"
set "M_S9=Bring back the classic right-click menu"
set "M_S10=Taskbar: add End task to the right-click menu"
set "M_S11=Turn off the Sticky Keys prompt (Shift 5 times)"
set "M_S12=Power plan: switch to Ultimate Performance"
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
set "M_TITLE=Windows 11 Tek Tıkla Ayarlar"
set "M_ELEVATE=Yönetici izni isteniyor..."
set "M_NEED_ADMIN=Yönetici izni gerekli. Dosyayı yeniden çalıştırıp Evet'e tıklayın."
set "M_DRY=DENEME MODU - hiçbir şey değişmeyecek. Çalışacak komutlar:"
set "M_S1=Başlat araması: internet sonuçlarını kapat"
set "M_S2=Başlat araması: hesap içeriklerini kapat (Microsoft, iş/okul)"
set "M_S3=Başlat araması: arama vurgularını kapat"
set "M_S4=Başlat menüsü: önerileri kapat (ipuçları, yeni uygulamalar)"
set "M_S5=Ayarlar: öneri ve teklifleri kapat (Microsoft 365 reklamı)"
set "M_S6=Ayarlar: hesap bildirimlerini kapat"
set "M_S7=Bildirimler: Windows ipuçlarını ve önerilerini kapat"
set "M_S8=Dosya Gezgini: OneDrive ve Microsoft 365 tanıtımlarını kapat"
set "M_S9=Klasik sağ tık menüsünü getir"
set "M_S10=Görev çubuğu: sağ tık menüsüne Görevi sonlandır ekle"
set "M_S11=Yapışkan Tuşlar uyarısını kapat (5 kez Shift)"
set "M_S12=Güç planı: Nihai Performans'a geç"
set "M_OK=TAMAM"
set "M_FAILED=HATA"
set "M_ALL_OK=Hepsi tamam."
set "M_SOME_FAILED=Başarısız adım sayısı:"
set "M_RESTART_NOTE=Değişikliklerin hepsinin geçerli olması için bilgisayarı yeniden başlatın."
set "M_RESTART_ASK=Şimdi yeniden başlatılsın mı? [E/H]"
set "M_KEYS=EH"
set "M_DRY_DONE=Deneme bitti. Hiçbir şey değişmedi."
exit /b
