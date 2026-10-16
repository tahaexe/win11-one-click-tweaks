<div align="center">

# Windows 11 One-Click Tweaks

**Double-click once: Start search only looks at your PC, ads and tips leave Start, Settings and File Explorer, the classic right-click menu comes back and the Ultimate Performance power plan turns on.**

[![Windows 11](https://img.shields.io/badge/Windows-11-0078D4?logo=windows11&logoColor=white)](#requirements)
[![Batch script](https://img.shields.io/badge/script-.bat-4D4D4D?logo=windowsterminal&logoColor=white)](win11-tweaks.bat)
[![License: MIT](https://img.shields.io/badge/license-MIT-2EA44F)](LICENSE)

**English** · [Türkçe](README.tr.md)

</div>

## What it changes

| # | Tweak | Before | After |
|:-:|---|---|---|
| 1 | Web results in Start search | Typing in Start shows Bing results and websites | Only apps, files and settings on this PC |
| 2 | Cloud content in search | Search also goes through your Microsoft and work/school accounts | Off |
| 3 | Search highlights | Trending topics and illustrations in the search box | Off |
| 4 | Start menu recommendations | Tips, new apps and app promotions in Start | Off |
| 5 | Suggestions and offers in Settings | Big "Get Microsoft 365" card on the Settings home page | Gone |
| 6 | Account notifications in Settings | Account reminders and promotions in Settings | Off (required notices still show) |
| 7 | Windows tips notifications | "Tips and suggestions" notifications, the welcome screen after updates and "finish setting up your device" reminders | Off |
| 8 | OneDrive promotions in File Explorer | OneDrive and Microsoft 365 promotions at the top of File Explorer | Off |
| 9 | Right-click menu | Windows 11 menu that hides items behind "Show more options" | Full classic menu right away |
| 10 | End task on the taskbar | Closing a frozen app means opening Task Manager | Right-click the app on the taskbar → **End task** |
| 11 | Sticky Keys prompt | Pressing Shift 5 times (easy to do in games) pops up the Sticky Keys dialog | No prompt; Sticky Keys still works from Settings |
| 12 | Power plan | Ultimate Performance is hidden | Added and active |

Everything is a per-user registry setting, plus one power plan. Nothing is downloaded and no apps are removed. Messages appear in Turkish on Turkish Windows and in English everywhere else.

## Usage

1. Download [`win11-tweaks.bat`](win11-tweaks.bat): open it and click **Download raw file**, or use **Code → Download ZIP**.
2. Double-click it and click **Yes** on the administrator prompt.
3. When it finishes, press **Y** to restart.

> [!TIP]
> To see the exact commands first, run `win11-tweaks.bat /dry` in a terminal. It lists them and changes nothing.

> [!NOTE]
> Because the file comes from the internet, Windows may show "Windows protected your PC". Click **More info → Run anyway**.

## Undo

Double-click [`win11-tweaks-undo.bat`](win11-tweaks-undo.bat). It puts every setting back to the Windows default and switches the power plan to **Balanced**. **End task** on the taskbar is turned off again too, because that's the Windows default. The undo script deletes the Ultimate Performance plan the script created, but leaves a plan you created yourself alone.

## Good to know

- After the script runs, the Search page in Settings says "Some of these settings are managed by your organization" and the **Show search highlights** switch is greyed out. That's how Windows shows a policy-based setting; it's expected.
- Step 11 only turns off the Shift ×5 shortcut. You can still turn Sticky Keys on in **Settings → Accessibility → Keyboard**.
- Ultimate Performance stops the processor from slowing down when idle. That suits a desktop, but on a laptop the battery drains faster. If you don't want it, pick another plan in **Power Options** or run the undo script.
- Some laptops with Modern Standby don't allow extra power plans. On those, step 12 may show **FAILED**; the other steps still apply.
- On a standard account, an administrator can approve the prompt and the settings still go to the account that started the script. The same holds when Windows Administrator protection is on.

## Requirements

- Windows 11 (developed on Windows 11 Pro 25H2, build 26200)
- Administrator rights: your own, or an administrator who approves the prompt

## How it works

| # | Change |
|:-:|---|
| 1 | `HKCU\Software\Policies\Microsoft\Windows\Explorer` → `DisableSearchBoxSuggestions` = `1` |
| 2 | `HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings` → `IsMSACloudSearchEnabled` = `0`, `IsAADCloudSearchEnabled` = `0` |
| 3 | Same key → `IsDynamicSearchBoxEnabled` = `0` |
| 4 | `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced` → `Start_IrisRecommendations` = `0` |
| 5 | `HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager` → `SubscribedContent-338393Enabled`, `SubscribedContent-353694Enabled`, `SubscribedContent-353696Enabled` = `0` |
| 6 | `HKCU\Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications` → `EnableAccountNotifications` = `0` |
| 7 | `ContentDeliveryManager` key from step 5 → `SubscribedContent-338389Enabled`, `SubscribedContent-310093Enabled` = `0`; `HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement` → `ScoobeSystemSettingEnabled` = `0` |
| 8 | `Explorer\Advanced` key from step 4 → `ShowSyncProviderNotifications` = `0` |
| 9 | `HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32` → empty default value |
| 10 | `Explorer\Advanced\TaskbarDeveloperSettings` → `TaskbarEndTask` = `1` |
| 11 | `HKCU\Control Panel\Accessibility\StickyKeys` → `Flags`: only the shortcut bit is cleared (`510` becomes `506` on a default setup) |
| 12 | `powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61`, then `powercfg /setactive`. An Ultimate Performance plan that already exists is reused. |

`HKCU` here means the account that started the script. The elevated copy writes straight to that account's hive (`HKEY_USERS\<SID>`), even if Windows elevates it as another account.

## License

[MIT](LICENSE)
