# Configure Windows Server 2022 Optimizations
# Performance tuning and configuration for cloud deployments

$ErrorActionPreference = "Stop"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] $Message"
}

Write-Log "Configuring Windows Server optimizations..."

# Set timezone to UTC (standard for cloud instances)
Write-Log "Setting timezone to UTC..."
Set-TimeZone -Id "UTC"

# Configure power plan for high performance
Write-Log "Setting power plan to High Performance..."
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Disable hibernation to save disk space
Write-Log "Disabling hibernation..."
powercfg /hibernate off

# Configure page file (let Windows manage it automatically)
Write-Log "Configuring page file..."
$computersys = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$computersys.AutomaticManagedPagefile = $true
$computersys.Put()

# Disable unnecessary scheduled tasks
Write-Log "Disabling unnecessary scheduled tasks..."
$tasksToDisable = @(
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Autochk\Proxy",
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
    "\Microsoft\Windows\Maintenance\WinSAT",
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
)

foreach ($task in $tasksToDisable) {
    try {
        Disable-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue | Out-Null
        Write-Log "Disabled task: $task"
    }
    catch {
        Write-Log "Task not found or already disabled: $task"
    }
}

# Configure Windows Update to not auto-reboot
Write-Log "Configuring Windows Update settings..."
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 3 -Type DWord -Force  # Download and notify

# Disable Windows Error Reporting
Write-Log "Disabling Windows Error Reporting..."
Disable-WindowsErrorReporting

# Configure Event Log sizes
Write-Log "Configuring Event Log sizes..."
$eventLogs = @{
    "Application" = 100MB
    "System" = 100MB
    "Security" = 200MB
}

foreach ($log in $eventLogs.Keys) {
    $logObj = Get-WinEvent -ListLog $log
    $logObj.MaximumSizeInBytes = $eventLogs[$log]
    $logObj.SaveChanges()
    Write-Log "Set $log log size to $($eventLogs[$log] / 1MB) MB"
}

# Configure DNS client cache
Write-Log "Configuring DNS client..."
Set-DnsClientServerAddress -InterfaceAlias "Ethernet*" -ResetServerAddresses

# Disable IPv6 if not needed (optional - comment out if IPv6 is required)
Write-Log "Disabling IPv6 on all adapters..."
Get-NetAdapterBinding -ComponentID ms_tcpip6 | ForEach-Object {
    Disable-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6 -Confirm:$false
}

# Configure RDP settings for better performance
Write-Log "Configuring RDP settings..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1 -Type DWord -Force

# Enable RDP through Windows Firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Configure performance options
Write-Log "Configuring performance options..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord -Force  # Adjust for best performance

# Disable System Restore (not needed in cloud - use AMIs instead)
Write-Log "Disabling System Restore..."
Disable-ComputerRestore -Drive "C:\"

# Configure IE Enhanced Security Configuration (ESC) - Disable for Administrators
Write-Log "Disabling IE Enhanced Security Configuration for Administrators..."
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 1 -Type DWord -Force  # Keep enabled for Users

# Configure Server Manager to not start at logon
Write-Log "Configuring Server Manager..."
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask

# Install useful Windows Features
Write-Log "Installing useful Windows Features..."
$featuresToInstall = @(
    "Telnet-Client",           # Useful for troubleshooting
    "RSAT-AD-Tools"           # Active Directory tools (if needed)
)

foreach ($feature in $featuresToInstall) {
    try {
        Install-WindowsFeature -Name $feature -IncludeManagementTools -ErrorAction SilentlyContinue | Out-Null
        Write-Log "Installed feature: $feature"
    }
    catch {
        Write-Log "Feature installation failed or not available: $feature"
    }
}

# Configure Windows Explorer settings
Write-Log "Configuring Windows Explorer..."
$explorerKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $explorerKey -Name "Hidden" -Value 1 -Type DWord -Force  # Show hidden files
Set-ItemProperty -Path $explorerKey -Name "HideFileExt" -Value 0 -Type DWord -Force  # Show file extensions

# Set system locale and keyboard (US English)
Write-Log "Configuring regional settings..."
Set-WinSystemLocale -SystemLocale en-US
Set-WinUserLanguageList -LanguageList en-US -Force

# Configure NTP time synchronization for better accuracy
Write-Log "Configuring NTP synchronization..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config" -Name "MaxPosPhaseCorrection" -Value 3600 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config" -Name "MaxNegPhaseCorrection" -Value 3600 -Type DWord -Force

Write-Log "Windows configuration completed successfully"
