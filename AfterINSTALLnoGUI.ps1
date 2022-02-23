param([switch]$Elevated)
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ( (Test-Admin) -eq $false ) {
    if ( $elevated ) {
        Write-Host "Please run script as administrator"
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

'version 0.0.8`n Script running with full privileges'

$ExecutionPolicy = Get-ExecutionPolicy
Set-ExecutionPolicy Unrestricted

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device" -Name "DevicePasswordLessBuildVersion" -Value 0
'Auto log in enable. Go to netplwiz `n'
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name ConsentPromptBehaviorAdmin -Value 0 #OR 5
'Change UAC settings to 0 `n'
cmd.exe /c 'powercfg.exe /hibernate off'
'Hibernate off `n'

'Checking Winget...'
if ( Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe ) {
    'Winget Already Installed' 
} else {
    'Winget not found, installing it now'
	Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
	$nid = (Get-Process AppInstaller).Id
	Wait-Process -Id $nid
	'Winget Installed `n'
}

'Checking Chocolatey...'
if ( Test-Path C:\ProgramData\chocolatey\choco.exe ) {
    'Chocolatey Already Installed'
} else {
    'Chocolatey not found, installing it now'
    $URLchocolatey = "https://community.chocolatey.org/install.ps1"
    $chocolatey = Invoke-WebRequest -Uri $urlChocolatey -UserAgent 'Trident' -UseBasicParsing
    New-Item -Path 'C:\' -Name 'Chocolatey_InstallScript.ps1' -ItemType File -Value $chocolatey.Content -Force
	& 'C:\Chocolatey_InstallScript.ps1'
	'Chocolatey Installed `n'
}


winget install --accept-source-agreements --accept-package-agreements 7zip.7zip | Out-Host
winget install --accept-source-agreements --accept-package-agreements AdGuard.AdGuard | Out-Host
winget install --accept-source-agreements --accept-package-agreements Audacity.Audacity | Out-Host
winget install --accept-source-agreements --accept-package-agreements Discord.Discord | Out-Host
winget install --accept-source-agreements --accept-package-agreements FlorianHoech.DisplayCAL | Out-Host
winget install --accept-source-agreements --accept-package-agreements Google.Chrome | Out-Host
winget install --accept-source-agreements --accept-package-agreements Implbits.HashTab | Out-Host
winget install --accept-source-agreements --accept-package-agreements DominikReichl.KeePass | Out-Host
winget install --accept-source-agreements --accept-package-agreements CodecGuide.K-LiteCodecPack.Full | Out-Host
winget install --accept-source-agreements --accept-package-agreements Logitech.GHUB | Out-Host
winget install --accept-source-agreements --accept-package-agreements MediaArea.MediaInfo.GUI | Out-Host
winget install --accept-source-agreements --accept-package-agreements Notepad++.Notepad++ | Out-Host
winget install --accept-source-agreements --accept-package-agreements OBSProject.OBSStudio | Out-Host
winget install --accept-source-agreements --accept-package-agreements PuTTY.PuTTY | Out-Host
winget install --accept-source-agreements --accept-package-agreements JonasJohn.RemoveEmptyDirectories | Out-Host
winget install --accept-source-agreements --accept-package-agreements Samsung.DeX | Out-Host
winget install --accept-source-agreements --accept-package-agreements AntoineAflalo.SoundSwitch | Out-Host
winget install --accept-source-agreements --accept-package-agreements SyncTrayzor.SyncTrayzor | Out-Host
winget install --accept-source-agreements --accept-package-agreements TeamSpeakSystems.TeamSpeakClient | Out-Host
winget install --accept-source-agreements --accept-package-agreements TeamViewer.TeamViewer | Out-Host
winget install --accept-source-agreements --accept-package-agreements Ghisler.TotalCommander | Out-Host
winget install --accept-source-agreements --accept-package-agreements VideoLAN.VLC | Out-Host
winget install --accept-source-agreements --accept-package-agreements WinSCP.WinSCP | Out-Host
winget install --accept-source-agreements --accept-package-agreements Rils.TouchPortal | Out-Host
winget install --accept-source-agreements --accept-package-agreements Corsair.iCUE.4 | Out-Host
winget install --accept-source-agreements --accept-package-agreements ShareX.ShareX | Out-Host
winget install --accept-source-agreements --accept-package-agreements Oracle.VirtualBox | Out-Host
choco install msiafterburner --accept-license --confirm | Out-Host
choco install adobe-creative-cloud --accept-license --confirm | Out-Host # --ignore-checksums
choco install spotify --accept-license --confirm | Out-Host


'Updating...'
winget upgrade --all | Out-Host
choco upgrade all | Out-Host

Set-ExecutionPolicy $ExecutionPolicy

Write-Host -NoNewLine '`nPress any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');