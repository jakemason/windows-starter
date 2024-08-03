# Set execution policy to bypass for this process and set the security protocol
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# Install Chocolatey
#Start-Process -FilePath PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" -Wait

# Install Python 3 using Chocolatey
#choco install python3 -y

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
    EntryName = "ShowSuperHidden"
    EntryValue = 0
    Message = "Enabled show protected operating system files."
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
    RegistryPath = "HKCU:\Control Panel\Colors"
    EntryName = "Background"
    EntryValue = "0 0 0"
    Message = "Setting background to solid black."
  }
)

foreach ($entry in $registryEntriesToSet) {
  Set-RegistryEntry -RegistryPath $entry.RegistryPath -EntryName $entry.EntryName -EntryValue $entry.EntryValue -Message $entry.Message
}

# Check and install PowerToys if not already installed
winget install Microsoft.PowerToys --source winget

# Refresh the desktop to apply the changes
Write-Output "Restarting explorer to apply new settings."
Stop-Process -Name explorer -Force
Start-Process explorer

Write-Output "Done."
Write-Warning "You must either restart your machine or sign-out and back in for some of these changes to take effect."
