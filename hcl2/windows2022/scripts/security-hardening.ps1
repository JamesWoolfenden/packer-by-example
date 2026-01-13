# Windows Security Hardening Script
# Applies security best practices for Windows Server 2022

$ErrorActionPreference = "Stop"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] $Message"
}

Write-Log "Applying security hardening configurations..."

# Enable Windows Defender
Write-Log "Configuring Windows Defender..."
Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -DisableBehaviorMonitoring $false
Set-MpPreference -DisableBlockAtFirstSeen $false
Set-MpPreference -DisableIOAVProtection $false
Set-MpPreference -DisableScriptScanning $false
Set-MpPreference -SubmitSamplesConsent SendAllSamples

# Update Windows Defender signatures
Write-Log "Updating Windows Defender signatures..."
Update-MpSignature

# Configure Windows Firewall
Write-Log "Configuring Windows Firewall..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True

# Disable unnecessary services for security
Write-Log "Disabling unnecessary services..."
$servicesToDisable = @(
    "RemoteRegistry",           # Remote Registry
    "WSearch",                  # Windows Search (if not needed)
    "SSDPSRV",                  # SSDP Discovery
    "upnphost",                 # UPnP Device Host
    "WMPNetworkSvc",           # Windows Media Player Network Sharing
    "XblAuthManager",          # Xbox Live Auth Manager
    "XblGameSave",             # Xbox Live Game Save
    "XboxGipSvc",              # Xbox Accessory Management
    "XboxNetApiSvc"            # Xbox Live Networking Service
)

foreach ($service in $servicesToDisable) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($svc) {
        Write-Log "Disabling service: $service"
        Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
    }
}

# Configure audit policies
Write-Log "Configuring audit policies..."
auditpol /set /category:"Account Logon" /success:enable /failure:enable
auditpol /set /category:"Account Management" /success:enable /failure:enable
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
auditpol /set /category:"Policy Change" /success:enable /failure:enable
auditpol /set /category:"Privilege Use" /success:enable /failure:enable
auditpol /set /category:"System" /success:enable /failure:enable

# Configure password policy
Write-Log "Configuring password policy..."
net accounts /minpwlen:12
net accounts /maxpwage:90
net accounts /minpwage:1
net accounts /uniquepw:5

# Disable SMBv1 (security vulnerability)
Write-Log "Disabling SMBv1..."
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

# Enable SMB encryption
Write-Log "Enabling SMB encryption..."
Set-SmbServerConfiguration -EncryptData $true -Force

# Configure TLS settings
Write-Log "Configuring TLS settings..."

# Disable SSL 3.0, TLS 1.0, and TLS 1.1
$protocols = @{
    'SSL 3.0' = $false
    'TLS 1.0' = $false
    'TLS 1.1' = $false
    'TLS 1.2' = $true
    'TLS 1.3' = $true
}

foreach ($protocol in $protocols.Keys) {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server"

    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }

    $enabled = if ($protocols[$protocol]) { 1 } else { 0 }
    $disabledByDefault = if ($protocols[$protocol]) { 0 } else { 1 }

    Set-ItemProperty -Path $regPath -Name "Enabled" -Value $enabled -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DisabledByDefault" -Value $disabledByDefault -Type DWord -Force

    Write-Log "Configured $protocol - Enabled: $($protocols[$protocol])"
}

# Configure PowerShell script execution auditing
Write-Log "Enabling PowerShell script block logging..."
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "EnableScriptBlockLogging" -Value 1 -Type DWord -Force

# Enable PowerShell transcription
Write-Log "Enabling PowerShell transcription..."
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "EnableTranscripting" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $regPath -Name "OutputDirectory" -Value "C:\PSTranscripts" -Type String -Force
Set-ItemProperty -Path $regPath -Name "EnableInvocationHeader" -Value 1 -Type DWord -Force

# Create PowerShell transcripts directory
if (-not (Test-Path "C:\PSTranscripts")) {
    New-Item -Path "C:\PSTranscripts" -ItemType Directory -Force | Out-Null
}

# Disable anonymous enumeration
Write-Log "Disabling anonymous enumeration..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymous" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymousSAM" -Value 1 -Type DWord -Force

# Enable credential guard (if supported)
Write-Log "Checking Credential Guard support..."
$hvci = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard
if ($hvci.VirtualizationBasedSecurityStatus -eq 2) {
    Write-Log "Credential Guard is already enabled"
} else {
    Write-Log "Attempting to enable Credential Guard..."
    # This requires a reboot to take effect
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
    Set-ItemProperty -Path $regPath -Name "LsaCfgFlags" -Value 1 -Type DWord -Force
}

# Configure time synchronization (important for security)
Write-Log "Configuring time synchronization..."
w32tm /config /manualpeerlist:"169.254.169.123" /syncfromflags:manual /reliable:yes /update
Restart-Service w32time

Write-Log "Security hardening completed successfully"
Write-Log "Note: Some security settings require a reboot to take full effect"
