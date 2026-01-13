<powershell>
# Modern WinRM Bootstrap Script for Packer
# Windows Server 2022
# This script configures WinRM with SSL for secure Packer communication

$ErrorActionPreference = "Stop"

# Log function
function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] $Message"
}

Write-Log "Starting WinRM configuration for Packer..."

# Set Administrator password from Packer variable
$password = "{{ .WinRMPassword }}"
net user Administrator $password
wmic useraccount where "name='Administrator'" set PasswordExpires=FALSE
Write-Log "Administrator password configured"

# Configure PowerShell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Write-Log "PowerShell execution policy set to RemoteSigned"

# Configure WinRM
Write-Log "Configuring WinRM..."

# Stop WinRM to reconfigure
Stop-Service -Name WinRM -Force

# Remove existing listeners
Get-ChildItem WSMan:\Localhost\listener | Where-Object { $_.Keys -like "Transport=*" } | Remove-Item -Recurse -Force

# Configure WinRM service
winrm quickconfig -quiet -force
winrm set winrm/config '@{MaxTimeoutms="7200000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'
winrm set winrm/config/winrs '@{MaxShellsPerUser="50"}'
winrm set winrm/config/service '@{AllowUnencrypted="false"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'

# Create self-signed certificate for HTTPS
Write-Log "Creating self-signed certificate for WinRM HTTPS..."
$cert = New-SelfSignedCertificate -DnsName "packer" -CertStoreLocation "Cert:\LocalMachine\My"
$certThumbprint = $cert.Thumbprint

# Create HTTPS listener
Write-Log "Creating HTTPS WinRM listener..."
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $certThumbprint -Force

# Also create HTTP listener for fallback (Packer will use HTTPS with insecure flag)
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTP -Address * -Force

# Configure firewall rules
Write-Log "Configuring Windows Firewall..."
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=allow localip=any remoteip=any
netsh advfirewall firewall add rule name="WinRM HTTPS" dir=in action=allow protocol=TCP localport=5986

# Enable WinRM for remote shells
Enable-PSRemoting -Force -SkipNetworkProfileCheck

# Configure UAC for remote access
Write-Log "Configuring UAC for remote access..."
$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
Set-ItemProperty -Path $regPath -Name 'LocalAccountTokenFilterPolicy' -Value 1 -Force

# Configure Network Profile to Private (allows WinRM)
Write-Log "Setting network profile to Private..."
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

# Start WinRM service
Write-Log "Starting WinRM service..."
Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM

# Verify WinRM is listening
Write-Log "Verifying WinRM listeners..."
winrm enumerate winrm/config/listener

# Install Chocolatey package manager
Write-Log "Installing Chocolatey package manager..."
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Log "WinRM configuration completed successfully"
Write-Log "Packer can now connect via WinRM"

</powershell>
