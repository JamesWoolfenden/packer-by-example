# Install and Configure AWS Systems Manager (SSM) Agent
# SSM Agent enables remote management of EC2 instances

$ErrorActionPreference = "Stop"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] $Message"
}

Write-Log "Installing AWS Systems Manager Agent..."

# SSM Agent is pre-installed on Windows Server 2022 AMIs
# But we'll ensure it's the latest version

# Download latest SSM Agent installer
$ssmInstallerUrl = "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe"
$installerPath = "$env:TEMP\AmazonSSMAgentSetup.exe"

Write-Log "Downloading SSM Agent from $ssmInstallerUrl..."
Invoke-WebRequest -Uri $ssmInstallerUrl -OutFile $installerPath

# Install SSM Agent
Write-Log "Installing SSM Agent..."
Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait -NoNewWindow

# Wait for installation to complete
Start-Sleep -Seconds 10

# Configure SSM Agent to start automatically
Write-Log "Configuring SSM Agent service..."
Set-Service -Name "AmazonSSMAgent" -StartupType Automatic

# Start SSM Agent
Start-Service -Name "AmazonSSMAgent"

# Verify SSM Agent is running
$ssmService = Get-Service -Name "AmazonSSMAgent"
if ($ssmService.Status -eq "Running") {
    Write-Log "SSM Agent is running successfully"
} else {
    Write-Log "Warning: SSM Agent service is not running"
    Write-Log "Service Status: $($ssmService.Status)"
}

# Clean up installer
Remove-Item -Path $installerPath -Force

Write-Log "SSM Agent installation completed"
Write-Log "Instances launched from this AMI will be manageable via AWS Systems Manager"
