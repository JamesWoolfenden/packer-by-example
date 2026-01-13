# Install Essential Software via Chocolatey
# Installs commonly needed tools and runtimes

$ErrorActionPreference = "Stop"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] $Message"
}

Write-Log "Installing essential software packages..."

# Refresh environment to ensure Chocolatey is available
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Configure Chocolatey
choco feature enable -n allowGlobalConfirmation
choco feature enable -n useRememberedArgumentsForUpgrades

# Install essential packages
$packages = @(
    "googlechrome",           # Web browser for troubleshooting
    "7zip",                   # Archive utility
    "git",                    # Version control
    "notepadplusplus",        # Text editor
    "putty",                  # SSH client
    "winscp",                 # SCP/SFTP client
    "dotnet-runtime",         # .NET Runtime (latest)
    "dotnet-sdk",             # .NET SDK (latest)
    "vcredist-all",           # Visual C++ Redistributables
    "openjdk",                # OpenJDK (latest LTS)
    "python3",                # Python 3
    "awscli",                 # AWS CLI
    "powershell-core"         # PowerShell 7
)

foreach ($package in $packages) {
    Write-Log "Installing $package..."
    try {
        choco install $package -y --limit-output --no-progress
        Write-Log "$package installed successfully"
    }
    catch {
        Write-Log "Warning: Failed to install $package - $($_.Exception.Message)"
    }
}

# Install AWS PowerShell modules
Write-Log "Installing AWS PowerShell modules..."
Install-Module -Name AWS.Tools.Installer -Force -AllowClobber
Install-AWSToolsModule AWS.Tools.EC2,AWS.Tools.S3,AWS.Tools.CloudWatch,AWS.Tools.SSM -Force

# Refresh environment variables after installations
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Log "Software installation completed"

# Display installed versions
Write-Log "Installed software versions:"
Write-Log "  Git: $(git --version 2>&1)"
Write-Log "  Python: $(python --version 2>&1)"
Write-Log "  AWS CLI: $(aws --version 2>&1)"
Write-Log "  PowerShell: $($PSVersionTable.PSVersion)"
Write-Log "  Java: $(java -version 2>&1 | Select-Object -First 1)"
