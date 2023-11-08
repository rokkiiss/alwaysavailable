$scriptPath = $MyInvocation.MyCommand.Path
$scriptDirectory = Split-Path $scriptPath
$targetPath = Join-Path $scriptDirectory "alwaysavailable.ps1"
$shortcutPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "AlwaysAvailable Shortcut.lnk")
$iconPath = Join-Path $scriptDirectory "greencheck.ico"

$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$targetPath`""
$shortcut.IconLocation = $iconPath
$shortcut.Save()

Write-Host "Shortcut created on desktop: $shortcutPath"
