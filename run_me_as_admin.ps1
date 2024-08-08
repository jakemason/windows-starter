# Set execution policy to bypass for this process and set the security protocol
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# Install Chocolatey
Start-Process -FilePath PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" -Wait

# Install scoop
irm get.scoop.sh -outfile 'install_scoop.ps1'
.\install_scoop.ps1 -RunAsAdmin -ScoopDir 'C:\scoop' -ScoopGlobalDir 'C:\tools' -NoProxy

scoop install python

# List of pre-installed apps to remove
$appsToRemove = @(
    "Microsoft.3DBuilder",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    # "Microsoft.MicrosoftStickyNotes",
    # "Microsoft.MSPaint",
    "Microsoft.OneNote",
    "Microsoft.People",
    "Microsoft.SkypeApp",
    "Microsoft.StorePurchaseApp",
    "Microsoft.Wallet",
    "Microsoft.Windows.Photos",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo"
)

function Remove-App {
    param (
        [string]$appName
    )
    $appPackage = Get-AppxPackage -Name $appName -ErrorAction SilentlyContinue
    if ($appPackage) {
        Remove-AppxPackage -Package $appPackage.PackageFullName
        Write-Output "Removed $appName."
    } else {
        Write-Output "$appName not found."
    }
}

foreach ($app in $appsToRemove) {
    Remove-App -appName $app
}

function Set-RegistryEntry {
  param (
    [string]$RegistryPath,
    [string]$EntryName,
    [object]$EntryValue,
    [string]$Message = ""
  )

  # Check if the registry path exists; if not, create it
  if (-not (Test-Path $RegistryPath)) {
    Write-Output "creating"
    New-Item -Path $RegistryPath -Force | Out-Null
  }

  #$logMessage = "Set-ItemProperty -Path $RegistryPath -Name $EntryName -Value $EntryValue"
  #Write-Output $logMessage

  # Set the registry entry value
  Set-ItemProperty -Path $RegistryPath -Name $EntryName -Value $EntryValue -Force

  if ($Message) {
    Write-Output $Message
  }
}

$registryEntriesToSet = @(
  @{
    RegistryPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
    EntryName = "DisableSearchBoxSuggestions"
    EntryValue = 1
    Message = "Disabled Bing-based search suggestions."
  },
  @{
    RegistryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    EntryName = "BingSearchEnabled"
    EntryValue = 0
    Message = "Disabled Bing search."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    EntryName = "Hidden"
    EntryValue = 1
    Message = "Enabled show hidden files and folders."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    EntryName = "Start_Recommend"
    EntryValue = 0
    Message = "Turned off Recommended section in Start Menu."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    EntryName = "SystemPaneSuggestionsEnabled"
    EntryValue = 0
    Message = "Turned off suggested apps in Start area."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    EntryName = "CortanaEnabled"
    EntryValue = 0
    Message = "Disabled Cortana."
  },
  @{
    RegistryPath = "HKCU:\Control Panel\Desktop"
    EntryName = "MenuShowDelay"
    EntryValue = 0
    Message = "Set MenuShowDelay to 0 for instant menu display."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    EntryName = "AppsUseLightTheme"
    EntryValue = 0
    Message = "Enabled dark mode for apps."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    EntryName = "SystemUsesLightTheme"
    EntryValue = 0
    Message = "Enabled dark mode for the system."
  },
  @{
    RegistryPath = "HKCU:\Control Panel\Desktop"
    EntryName = "WallPaper"
    EntryValue = ""
    Message = "Setting background to solid black." 
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers"
    EntryName = "BackgroundType"
    EntryValue = 1
    Message = "Set background type to be solid color." 
  },
  @{
    RegistryPath = "HKCU:\Control Panel\Colors"
    EntryName = "Background"
    EntryValue = "0 0 0"
    Message = "Setting background to solid black." 
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice"
    EntryName = "ProgId"
    EntryValue = "ChromeHTML"
    Message = "Set Chrome as the default browser for HTTP."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice"
    EntryName = "ProgId"
    EntryValue = "ChromeHTML"
    Message = "Set Chrome as the default browser for HTTPS."
  }
  @{
    RegistryPath = "HKCU:\Software\Policies\Microsoft\Windows\Windows Copilot"
    EntryName = "EnableWindowsCopilot"
    EntryValue = 0
    Message = "Disabled Windows Copilot."
  },
  @{
    RegistryPath = "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"
    EntryName = "TurnOffWindowsCopilot"
    EntryValue = 1
    Message = "Disabled Windows Copilot."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    EntryName = "TaskbarCopilot"
    EntryValue = 0
    Message = "Removed Copilot from the taskbar."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    EntryName = "TaskbarDa"
    EntryValue = 0
    Message = "Disabled Widgets in the taskbar."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    EntryName = "ShowTaskViewButton"
    EntryValue = 0
    Message = "Disabled TaskView in the taskbar."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    EntryName = "TaskbarAl"
    EntryValue = 0
    Message = "Set Taskbar alignment to the left."
  },
  @{
    RegistryPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
    EntryName = ""
    EntryValue = ""
    Message = "Enabled classic context menu in Windows 11."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    EntryName = "SubscribedContent-338388Enabled"
    EntryValue = 0
    Message = "Disabled Windows Tips."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
    EntryName = "LetAppsAccessLocation"
    EntryValue = 0
    Message = "Disabled location tracking."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    EntryName = "Enabled"
    EntryValue = 0
    Message = "Disabled Advertising ID."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\OneDrive"
    EntryName = "DisableFileSyncNGSC"
    EntryValue = 1
    Message = "Disabled OneDrive."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    EntryName = "SubscribedContent-338388Enabled"
    EntryValue = 0
    Message = "Disabled Windows Tips."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"
    EntryName = "PeopleBand"
    EntryValue = 0
    Message = "Disabled People icon on the taskbar."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\PenWorkspace"
    EntryName = "PenWorkspaceButtonDesiredVisibility"
    EntryValue = 0
    Message = "Disabled Windows Ink Workspace."
  },
  @{
    RegistryPath = "HKLM:\Software\Policies\Microsoft\Windows\DataCollection"
    EntryName = "AllowTelemetry"
    EntryValue = 0
    Message = "Disabled Windows telemetry."
  },
  @{
    RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    EntryName = "TaskbarMn"
    EntryValue = 0
    Message = "Removed Chat from the taskbar."
  }
)

foreach ($entry in $registryEntriesToSet) {
  Set-RegistryEntry -RegistryPath $entry.RegistryPath -EntryName $entry.EntryName -EntryValue $entry.EntryValue -Message $entry.Message
}

# Check and install PowerToys if not already installed
winget install Microsoft.PowerToys --source winget

# Clean everything off of the desktop
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$desktopItems = Get-ChildItem -Path $desktopPath
foreach ($item in $desktopItems) {
    try {
        Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction Stop
        Write-Output "Deleted: $($item.FullName)"
    } catch {
        Write-Output "Failed to delete: $($item.FullName). Error: $_"
    }
}

# Refresh the desktop to apply the changes
Write-Output "Restarting explorer to apply new settings."
Stop-Process -Name explorer -Force
Start-Process explorer

Write-Output "Done."
Write-Warning "You must either restart your machine or sign-out and back in for some of these changes to take effect. This is a requirement by Windows, there's no way around it."

python install_apps.py
