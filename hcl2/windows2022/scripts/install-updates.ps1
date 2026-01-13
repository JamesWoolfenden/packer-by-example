# Install Windows Updates
# This script installs critical and security updates

$ErrorActionPreference = "Stop"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] $Message"
}

Write-Log "Installing Windows Updates module..."

# Install PSWindowsUpdate module
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name PSWindowsUpdate -Force -SkipPublisherCheck

Write-Log "Checking for available updates..."

# Get available updates
$updates = Get-WindowsUpdate -MicrosoftUpdate

if ($updates.Count -eq 0) {
    Write-Log "No updates available"
    exit 0
}

Write-Log "Found $($updates.Count) updates to install"

# Install updates (excluding preview updates)
Write-Log "Installing updates... This may take a while."
Get-WindowsUpdate -MicrosoftUpdate -Install -AcceptAll -IgnoreReboot -NotCategory "Preview"

Write-Log "Windows updates installation completed"

# Note: Not rebooting during Packer build to avoid timeout issues
# Updates requiring reboot will be applied on first instance boot
