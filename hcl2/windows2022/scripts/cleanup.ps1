# Cleanup Script for Windows Server AMI
# Removes temporary files and prepares image for deployment

$ErrorActionPreference = "Stop"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] $Message"
}

Write-Log "Starting cleanup process..."

# Clear Windows Update cache
Write-Log "Clearing Windows Update cache..."
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item C:\Windows\SoftwareDistribution\Download\* -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv -ErrorAction SilentlyContinue

# Clear Windows temp directories
Write-Log "Clearing Windows temp directories..."
Remove-Item C:\Windows\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item C:\Users\*\AppData\Local\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue

# Clear Chocolatey cache
Write-Log "Clearing Chocolatey cache..."
if (Test-Path "C:\ProgramData\chocolatey\lib-bad") {
    Remove-Item C:\ProgramData\chocolatey\lib-bad\* -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path "C:\ProgramData\chocolatey\cache") {
    Remove-Item C:\ProgramData\chocolatey\cache\* -Recurse -Force -ErrorAction SilentlyContinue
}

# Clear Windows Installer cache (safely)
Write-Log "Clearing Windows Installer cache..."
$msiCache = "C:\Windows\Installer\$PatchCache$"
if (Test-Path $msiCache) {
    Get-ChildItem -Path $msiCache -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

# Clear DNS cache
Write-Log "Clearing DNS cache..."
Clear-DnsClientCache

# Clear Windows Error Reporting files
Write-Log "Clearing Windows Error Reporting files..."
Remove-Item C:\ProgramData\Microsoft\Windows\WER\ReportArchive\* -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item C:\ProgramData\Microsoft\Windows\WER\ReportQueue\* -Recurse -Force -ErrorAction SilentlyContinue

# Clear event logs
Write-Log "Clearing event logs..."
$eventLogs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue | Where-Object { $_.RecordCount -gt 0 }
foreach ($log in $eventLogs) {
    try {
        wevtutil cl $log.LogName
    }
    catch {
        Write-Log "Could not clear log: $($log.LogName)"
    }
}

# Clear IIS logs (if IIS is installed)
if (Get-Service W3SVC -ErrorAction SilentlyContinue) {
    Write-Log "Clearing IIS logs..."
    Remove-Item C:\inetpub\logs\LogFiles\* -Recurse -Force -ErrorAction SilentlyContinue
}

# Clear PowerShell history
Write-Log "Clearing PowerShell history..."
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force -ErrorAction SilentlyContinue

# Clear RDP cached data
Write-Log "Clearing RDP cache..."
Remove-Item "C:\Users\*\AppData\Local\Microsoft\Terminal Server Client\Cache\*" -Force -ErrorAction SilentlyContinue

# Clear Windows Defender scan history
Write-Log "Clearing Windows Defender history..."
Remove-Item "C:\ProgramData\Microsoft\Windows Defender\Scans\History\*" -Recurse -Force -ErrorAction SilentlyContinue

# Defragment disk (only for non-SSD)
Write-Log "Optimizing drives..."
Optimize-Volume -DriveLetter C -Defrag -Verbose

# Clear pagefiles at shutdown (will be recreated on boot)
Write-Log "Configuring pagefile clearing..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Value 1 -Type DWord -Force

# Remove Windows.old if exists
if (Test-Path "C:\Windows.old") {
    Write-Log "Removing Windows.old directory..."
    Remove-Item C:\Windows.old -Recurse -Force -ErrorAction SilentlyContinue
}

# Disk Cleanup using cleanmgr
Write-Log "Running Disk Cleanup..."
$volumeCaches = @(
    "Active Setup Temp Folders",
    "BranchCache",
    "Downloaded Program Files",
    "Internet Cache Files",
    "Memory Dump Files",
    "Offline Pages Files",
    "Old ChkDsk Files",
    "Previous Installations",
    "Recycle Bin",
    "Service Pack Cleanup",
    "Setup Log Files",
    "System error memory dump files",
    "System error minidump files",
    "Temporary Files",
    "Temporary Setup Files",
    "Thumbnail Cache",
    "Update Cleanup",
    "Upgrade Discarded Files",
    "Windows Defender",
    "Windows Error Reporting Archive Files",
    "Windows Error Reporting Queue Files",
    "Windows Error Reporting System Archive Files",
    "Windows Error Reporting System Queue Files",
    "Windows ESD installation files",
    "Windows Upgrade Log Files"
)

foreach ($key in $volumeCaches) {
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$key"
    if (Test-Path $regPath) {
        Set-ItemProperty -Path $regPath -Name "StateFlags0001" -Value 2 -Type DWord -Force
    }
}

# Run cleanmgr with our settings
Start-Process -FilePath cleanmgr.exe -ArgumentList "/sagerun:1" -Wait -NoNewWindow

# Clean up StateFlags
foreach ($key in $volumeCaches) {
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$key"
    if (Test-Path $regPath) {
        Remove-ItemProperty -Path $regPath -Name "StateFlags0001" -Force -ErrorAction SilentlyContinue
    }
}

# Clear any remaining Packer files
Write-Log "Clearing Packer temporary files..."
Remove-Item C:\Windows\Temp\packer-* -Recurse -Force -ErrorAction SilentlyContinue

# Get disk space info
Write-Log "Disk space after cleanup:"
$disk = Get-PSDrive C
Write-Log "  Free Space: $([math]::Round($disk.Free / 1GB, 2)) GB"
Write-Log "  Used Space: $([math]::Round($disk.Used / 1GB, 2)) GB"
Write-Log "  Total Size: $([math]::Round(($disk.Free + $disk.Used) / 1GB, 2)) GB"

Write-Log "Cleanup completed successfully"
Write-Log "AMI is ready for final sysprep and capture"
