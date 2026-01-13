# Install and Configure Amazon CloudWatch Agent
# Enables metric and log collection from Windows instances

$ErrorActionPreference = "Stop"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] $Message"
}

Write-Log "Installing Amazon CloudWatch Agent..."

# Download CloudWatch Agent
$cwAgentUrl = "https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/amazon-cloudwatch-agent.msi"
$installerPath = "$env:TEMP\amazon-cloudwatch-agent.msi"

Write-Log "Downloading CloudWatch Agent from $cwAgentUrl..."
Invoke-WebRequest -Uri $cwAgentUrl -OutFile $installerPath

# Install CloudWatch Agent
Write-Log "Installing CloudWatch Agent..."
Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qn /norestart" -Wait -NoNewWindow

# Wait for installation to complete
Start-Sleep -Seconds 10

# Create default CloudWatch Agent configuration
Write-Log "Creating default CloudWatch Agent configuration..."

$configDir = "C:\ProgramData\Amazon\AmazonCloudWatchAgent"
$configFile = "$configDir\amazon-cloudwatch-agent.json"

# Ensure config directory exists
if (-not (Test-Path -Path $configDir)) {
    New-Item -Path $configDir -ItemType Directory -Force | Out-Null
}

# Default configuration (metrics + logs)
$config = @{
    agent = @{
        metrics_collection_interval = 60
        run_as_user = "Administrator"
    }
    logs = @{
        logs_collected = @{
            windows_events = @{
                collect_list = @(
                    @{
                        event_name = "System"
                        event_levels = @("ERROR", "WARNING", "CRITICAL")
                        log_group_name = "/aws/ec2/windows/System"
                        log_stream_name = "{instance_id}"
                        event_format = "xml"
                    },
                    @{
                        event_name = "Application"
                        event_levels = @("ERROR", "WARNING", "CRITICAL")
                        log_group_name = "/aws/ec2/windows/Application"
                        log_stream_name = "{instance_id}"
                        event_format = "xml"
                    },
                    @{
                        event_name = "Security"
                        event_levels = @("ERROR", "WARNING")
                        log_group_name = "/aws/ec2/windows/Security"
                        log_stream_name = "{instance_id}"
                        event_format = "xml"
                    }
                )
            }
        }
    }
    metrics = @{
        namespace = "CWAgent"
        metrics_collected = @{
            LogicalDisk = @{
                measurement = @(
                    @{
                        name = "% Free Space"
                        rename = "DiskSpaceUtilization"
                        unit = "Percent"
                    }
                )
                metrics_collection_interval = 60
                resources = @("*")
            }
            Memory = @{
                measurement = @(
                    @{
                        name = "% Committed Bytes In Use"
                        rename = "MemoryUtilization"
                        unit = "Percent"
                    },
                    @{
                        name = "Available Mbytes"
                        rename = "MemoryAvailable"
                        unit = "Megabytes"
                    }
                )
                metrics_collection_interval = 60
            }
            "Paging File" = @{
                measurement = @(
                    @{
                        name = "% Usage"
                        rename = "PageFileUtilization"
                        unit = "Percent"
                    }
                )
                metrics_collection_interval = 60
                resources = @("*")
            }
            PhysicalDisk = @{
                measurement = @(
                    @{
                        name = "% Disk Time"
                        rename = "DiskTime"
                        unit = "Percent"
                    }
                )
                metrics_collection_interval = 60
                resources = @("*")
            }
            Processor = @{
                measurement = @(
                    @{
                        name = "% Processor Time"
                        rename = "CPUUtilization"
                        unit = "Percent"
                    }
                )
                metrics_collection_interval = 60
                resources = @("_Total")
            }
            TCPv4 = @{
                measurement = @(
                    @{
                        name = "Connections Established"
                        rename = "TCPConnections"
                        unit = "Count"
                    }
                )
                metrics_collection_interval = 60
            }
        }
    }
}

$config | ConvertTo-Json -Depth 10 | Out-File -FilePath $configFile -Encoding utf8

Write-Log "CloudWatch Agent configuration created at $configFile"

# Note: CloudWatch Agent will be configured and started on first instance boot
# This allows for instance-specific configuration via SSM Parameter Store

# Clean up installer
Remove-Item -Path $installerPath -Force

Write-Log "CloudWatch Agent installation completed"
Write-Log "To start the agent on instance boot, use SSM or configure via user data"
