# Windows 11 One-Click Tweaks - quick undo
# https://github.com/tahaexe/win11-one-click-tweaks
#
#   irm https://raw.githubusercontent.com/tahaexe/win11-one-click-tweaks/main/undo.ps1 | iex
#
# Downloads win11-tweaks-undo.bat to the temp folder and runs it. The batch
# file asks for administrator rights itself.
& {
    $ErrorActionPreference = 'Stop'
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    $file = Join-Path $env:TEMP 'win11-tweaks-undo.bat'
    Invoke-WebRequest 'https://raw.githubusercontent.com/tahaexe/win11-one-click-tweaks/main/win11-tweaks-undo.bat' -OutFile $file -UseBasicParsing
    & $file
}
