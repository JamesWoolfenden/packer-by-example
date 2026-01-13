# Windows Server 2022 Packer Template

Modern HCL2 Packer template for building secure, production-ready Windows Server 2022 AMIs.

## Features

### Security

- ✓ Windows Defender enabled and configured
- ✓ SMBv1 disabled (security vulnerability)
- ✓ SMB encryption enabled
- ✓ TLS 1.2/1.3 only (SSL 3.0, TLS 1.0, TLS 1.1 disabled)
- ✓ PowerShell script block logging and transcription
- ✓ Enhanced audit policies
- ✓ Credential Guard support
- ✓ IMDSv2 required (metadata service security)
- ✓ EBS encryption enabled
- ✓ Unnecessary services disabled

### AWS Integration

- ✓ AWS Systems Manager (SSM) Agent (latest version)
- ✓ Amazon CloudWatch Agent with default config
- ✓ CloudWatch Logs (System, Application, Security events)
- ✓ CloudWatch Metrics (CPU, Memory, Disk, Network)
- ✓ EC2Launch v2 for instance initialization

### Software & Tools

- ✓ Chocolatey package manager
- ✓ AWS CLI
- ✓ AWS PowerShell modules
- ✓ PowerShell 7
- ✓ Git
- ✓ Python 3
- ✓ .NET SDK and Runtime (latest)
- ✓ OpenJDK (latest LTS)
- ✓ 7-Zip, Notepad++, PuTTY, WinSCP
- ✓ Google Chrome (for troubleshooting)
- ✓ Visual C++ Redistributables

### Optimizations

- ✓ High performance power plan
- ✓ Hibernation disabled (saves disk space)
- ✓ Unnecessary scheduled tasks disabled
- ✓ Event log sizes configured (100-200MB)
- ✓ Windows Update configured (no auto-reboot)
- ✓ Disk cleanup and optimization
- ✓ Telemetry and unnecessary services disabled
- ✓ GP3 EBS volumes with optimized IOPS/throughput
- ✓ Spot instances for cost-effective builds

## Prerequisites

1. **Packer 1.11.2+**

   ```bash
   ./../../setup-packer.sh
   ```

2. **AWS Credentials**

   <!-- pragma: allowlist secret -->
   ```bash
   export AWS_ACCESS_KEY_ID="your-key"
   export AWS_SECRET_ACCESS_KEY="your-secret"  # pragma: allowlist secret
   export AWS_REGION="us-east-1"
   ```

3. **Required Environment Variables**

   <!-- pragma: allowlist secret -->
   ```bash
   export WINRM_PASSWORD="YourSecurePassword123!"  # REQUIRED  # pragma: allowlist secret
   export BUILD_NUMBER="1"                          # Optional, defaults to env var
   ```

4. **Network Configuration**
   - VPC with internet access (for downloading packages)
   - Public subnet with auto-assign public IP
   - Security group allowing outbound HTTPS (443)

## Usage

### Quick Start

<!-- pragma: allowlist secret -->
```bash
# Set required variables
export AWS_REGION="us-east-1"
export WINRM_PASSWORD="YourVerySecurePassword123!"  # pragma: allowlist secret
export BUILD_NUMBER="1"

# Initialize Packer (first time only)
packer init .

# Validate template
packer validate \
  -var "vpc_id=vpc-xxxxx" \
  -var "subnet_id=subnet-xxxxx" \
  .

# Build AMI
packer build \
  -var "vpc_id=vpc-xxxxx" \
  -var "subnet_id=subnet-xxxxx" \
  .
```

### Using a Variables File

Create `custom.pkrvars.hcl`:

```hcl
region        = "us-east-1"
vpc_id        = "vpc-0123456789abcdef0"
subnet_id     = "subnet-0123456789abcdef0"
instance_type = "t3.large"
build_number  = "1"

# AMI sharing (optional)
ami_users   = ["123456789012", "210987654321"]
ami_regions = ["us-west-2", "eu-west-1"]

# Additional tags
tags = {
  Environment = "Production"
  CostCenter  = "Engineering"
  Project     = "WebApp"
}
```

Build with custom variables:

```bash
export WINRM_PASSWORD="YourSecurePassword123!"
packer build -var-file="custom.pkrvars.hcl" .
```

### CI/CD Integration

#### GitHub Actions

```yaml
name: Build Windows 2022 AMI
on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: hashicorp/setup-packer@main
        with:
          version: "1.11.2"

      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: us-east-1

      - name: Build AMI
        env:
          WINRM_PASSWORD: ${{ secrets.WINRM_PASSWORD }}
          BUILD_NUMBER: ${{ github.run_number }}
        run: |
          cd hcl2/windows2022
          packer init .
          packer build \
            -var "vpc_id=${{ secrets.VPC_ID }}" \
            -var "subnet_id=${{ secrets.SUBNET_ID }}" \
            .
```

#### Jenkins

```groovy
pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        WINRM_PASSWORD = credentials('winrm-password')
        VPC_ID = credentials('vpc-id')
        SUBNET_ID = credentials('subnet-id')
    }

    stages {
        stage('Validate') {
            steps {
                sh '''
                    cd hcl2/windows2022
                    packer init .
                    packer validate \
                      -var "vpc_id=${VPC_ID}" \
                      -var "subnet_id=${SUBNET_ID}" \
                      .
                '''
            }
        }

        stage('Build') {
            steps {
                sh '''
                    cd hcl2/windows2022
                    packer build \
                      -var "vpc_id=${VPC_ID}" \
                      -var "subnet_id=${SUBNET_ID}" \
                      .
                '''
            }
        }
    }
}
```

## Customization

### Adding More Software

Edit `scripts/install-software.ps1`:

```powershell
$packages = @(
    # Existing packages...
    "nodejs",              # Add Node.js
    "docker-desktop",      # Add Docker Desktop
    "visualstudio2022community"  # Add Visual Studio
)
```

### Modifying Security Settings

Edit `scripts/security-hardening.ps1` to adjust:

- Firewall rules
- Audit policies
- Password policies
- Service configurations
- TLS/SSL settings

### CloudWatch Configuration

Edit `scripts/install-cloudwatch-agent.ps1` to customize:

- Metrics collection intervals
- Log groups and streams
- Performance counters
- Custom metrics

### Skipping Provisioners

Comment out unwanted provisioners in `build.windows2022.pkr.hcl`:

```hcl
# Uncomment to skip Windows Updates (faster builds, less secure)
# provisioner "powershell" {
#   scripts = ["${path.root}/scripts/install-updates.ps1"]
# }
```

## Build Time

Typical build times:

- **Without Windows Updates**: 20-30 minutes
- **With Windows Updates**: 45-90 minutes (depends on available updates)
- **First build**: Longer due to package downloads

## Cost Optimization

1. **Use Spot Instances**: Already configured in template
2. **Choose smaller instance types**: For basic builds, t3.medium works
3. **Regional pricing**: Build in cheaper regions
4. **Cleanup old AMIs**: Use `../../ami-cleanup.sh`

```bash
# Keep only 3 most recent Windows 2022 AMIs
../../ami-cleanup.sh -n 3 -p "WindowsServer2022-Base"
```

## Troubleshooting

### WinRM Connection Issues

```bash
# Increase timeout
packer build -var "winrm_timeout=30m" ...

# Check user data execution
# Connect via EC2 Serial Console or Session Manager
Get-Content C:\ProgramData\Amazon\EC2Launch\log\agent.log
```

### Build Failures

```bash
# Enable detailed logging
export PACKER_LOG=1
export PACKER_LOG_PATH=packer.log
packer build ...
```

### Sysprep Issues

If sysprep fails, check:

1. No pending Windows Updates requiring reboot
2. EC2Launch v2 is properly installed
3. No invalid unattend.xml files in `C:\Windows\Panther`

## Security Best Practices

1. **Never hardcode passwords**: Always use environment variables
2. **Rotate WinRM password**: Use different passwords for each build
3. **Limit AMI sharing**: Only share with necessary AWS accounts
4. **Enable CloudTrail**: Monitor AMI usage and modifications
5. **Regular updates**: Rebuild AMIs monthly with latest updates
6. **Tag everything**: Use consistent tagging for inventory and cost tracking

## Post-Deployment

### First Instance Launch

1. **Change Administrator password** (WinRM password is temporary)
2. **Join domain** (if applicable)
3. **Configure CloudWatch Agent** with instance-specific settings
4. **Apply additional group policies**
5. **Install application-specific software**

### CloudWatch Agent Configuration

```bash
# On instance, configure CloudWatch Agent via SSM Parameter Store
aws ssm put-parameter \
  --name "AmazonCloudWatch-windows-config" \
  --type "String" \
  --value file://cloudwatch-config.json

# Start CloudWatch Agent
& "C:\Program Files\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1" `
  -a fetch-config `
  -m ec2 `
  -s `
  -c ssm:AmazonCloudWatch-windows-config
```

## Files

```text
hcl2/windows2022/
├── variables.pkr.hcl                    # Variable definitions
├── amazon-ebs.windows2022.pkr.hcl       # Source configuration
├── build.windows2022.pkr.hcl            # Build steps
├── values.auto.pkrvars.hcl              # Default values
├── README.md                            # This file
└── scripts/
    ├── bootstrap-winrm.ps1              # WinRM setup (user data)
    ├── install-updates.ps1              # Windows Updates
    ├── install-software.ps1             # Software installation
    ├── install-ssm-agent.ps1            # SSM Agent
    ├── install-cloudwatch-agent.ps1     # CloudWatch Agent
    ├── security-hardening.ps1           # Security configurations
    ├── configure-windows.ps1            # OS optimizations
    └── cleanup.ps1                      # Pre-sysprep cleanup
```

## Versions

- **Windows Server**: 2022 (latest available from Amazon)
- **PowerShell**: 7.x
- **AWS CLI**: Latest
- **.NET SDK**: Latest LTS
- **OpenJDK**: Latest LTS

## References

- [Packer Windows Builders](https://www.packer.io/docs/builders/amazon/ebs)
- [AWS EC2Launch v2](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2launch-v2.html)
- [CloudWatch Agent Configuration](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)
- [Windows Server 2022 Security Baseline](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-security-baselines)

## License

See repository LICENSE file.
