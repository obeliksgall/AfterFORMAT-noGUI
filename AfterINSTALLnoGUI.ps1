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

'version 0.0.7`n Script running with full privileges'

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










Set-ExecutionPolicy $ExecutionPolicy

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');