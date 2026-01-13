# Windows Server Packer Templates

Comparison and migration guide for Windows Server templates in this repository.

## Available Templates

### Modern Templates (HCL2) - Recommended ✓

| Version                 | Path                | Status    | Support End | Recommendation                      |
| ----------------------- | ------------------- | --------- | ----------- | ----------------------------------- |
| **Windows Server 2025** | `hcl2/windows2025/` | ✓ Current | ~2034       | **Recommended for new deployments** |
| **Windows Server 2022** | `hcl2/windows2022/` | ✓ Current | Oct 2031    | **Recommended for production**      |
| Windows Server 2019     | `hcl2/windows/`     | Supported | Jan 2029    | Use 2022 instead                    |

### Legacy Templates (JSON) - Deprecated

| Version                | Path                                                | Status      | Support End | Action Required  |
| ---------------------- | --------------------------------------------------- | ----------- | ----------- | ---------------- |
| Windows Server 2019    | `packfiles/Windows/amazon-ebs.winserver2019.json`   | ⚠️ Legacy   | Jan 2029    | Migrate to HCL2  |
| Windows Server 2016    | `packfiles/Windows/amazon-ebs.winserver2016.json`   | ⚠️ Extended | Jan 2027    | Migrate to 2022+ |
| Windows Server 2012 R2 | `packfiles/Windows/amazon-ebs.winserver2012r2.json` | 🔴 EOL      | Oct 2023    | **Deprecated**   |

## Feature Comparison

| Feature                 | Legacy (JSON)                   | Modern (HCL2)                |
| ----------------------- | ------------------------------- | ---------------------------- |
| **Packer Format**       | JSON                            | HCL2                         |
| **WinRM Security**      | Hardcoded passwords (now fixed) | Environment variables        |
| **EBS Encryption**      | ❌ No                           | ✓ Yes (default)              |
| **GP3 Volumes**         | ❌ No (GP2)                     | ✓ Yes (optimized IOPS)       |
| **IMDSv2**              | ❌ Optional                     | ✓ Required (enforced)        |
| **Spot Instances**      | ✓ Yes                           | ✓ Yes (multi-type fallback)  |
| **SSM Agent**           | ❌ Not installed                | ✓ Latest version             |
| **CloudWatch Agent**    | Basic metrics                   | Full metrics + logs          |
| **Security Hardening**  | Basic                           | Comprehensive (CIS-aligned)  |
| **Software Management** | Chocolatey                      | Chocolatey + PowerShell      |
| **TLS Configuration**   | Not configured                  | TLS 1.2/1.3 only             |
| **SMBv1**               | Enabled (vulnerable)            | ✓ Disabled                   |
| **Windows Defender**    | Default settings                | Optimized configuration      |
| **PowerShell Logging**  | Not enabled                     | Script block + transcription |
| **Disk Optimization**   | Basic                           | Comprehensive cleanup        |
| **Documentation**       | Minimal                         | Extensive README             |

## What's Included in Modern Templates

### Windows Server 2022

**Security Features:**

- Windows Defender fully configured
- SMBv1 disabled, SMB encryption enabled
- TLS 1.2/1.3 only (older protocols disabled)
- PowerShell script block logging and transcription
- Enhanced audit policies
- Credential Guard support
- IMDSv2 required
- EBS encryption by default

**AWS Integration:**

- SSM Agent (latest)
- CloudWatch Agent with default config
- CloudWatch Logs (System, Application, Security)
- CloudWatch Metrics (CPU, Memory, Disk, Network)
- EC2Launch v2

**Pre-installed Software:**

- AWS CLI + AWS PowerShell modules
- PowerShell 7
- Git, Python 3
- .NET SDK (latest)
- OpenJDK (LTS)
- Chrome, 7-Zip, Notepad++, PuTTY, WinSCP
- Visual C++ Redistributables

**Optimizations:**

- High performance power plan
- Hibernation disabled
- Unnecessary services/tasks disabled
- Event logs configured (100-200MB)
- Windows Update configured (no auto-reboot)
- Disk cleanup and optimization
- GP3 volumes with optimized IOPS

### Windows Server 2025

All features from Windows Server 2022, plus:

- Latest Windows Server platform
- Enhanced security baseline
- Improved hybrid cloud features
- Extended support lifecycle (~2034)

**Note:** Windows Server 2025 templates reuse Windows 2022 scripts for compatibility.

## Migration Guide

### From Legacy JSON to Modern HCL2

#### 1. Review Current Template

```bash
# Inventory your current usage
find packfiles/Windows -name "*.json"
```

#### 2. Choose Target Template

- **Production workloads**: Windows Server 2022
- **New deployments**: Windows Server 2025
- **Long-term support**: Windows Server 2022 (proven stability)

#### 3. Update Build Scripts

**Before (JSON):**

```bash
export WINRM_PASSWORD=...  # Was hardcoded before our fixes
packer build \
  -var "region=$AWS_REGION" \
  -var "vpc_id=$VPC_ID" \
  -var "subnet_id=$SUBNET_ID" \
  packfiles/Windows/amazon-ebs.winserver2019.json
```

**After (HCL2):**

```bash
export WINRM_PASSWORD=...
cd hcl2/windows2022
packer init .
packer build \
  -var "vpc_id=$VPC_ID" \
  -var "subnet_id=$SUBNET_ID" \
  .
```

#### 4. Update CI/CD Pipelines

**Jenkins Example:**

```groovy
// Before
stage('Build AMI') {
    sh "packer build packfiles/Windows/amazon-ebs.winserver2019.json"
}

// After
stage('Build AMI') {
    dir('hcl2/windows2022') {
        sh 'packer init .'
        sh 'packer build .'
    }
}
```

**GitHub Actions Example:**

```yaml
# Before
- name: Build
  run: packer build packfiles/Windows/amazon-ebs.winserver2019.json

# After
- name: Build
  run: |
    cd hcl2/windows2022
    packer init .
    packer build .
```

#### 5. Test Thoroughly

1. **Build validation**: Ensure AMI builds successfully
2. **Launch test**: Create EC2 instance from new AMI
3. **Connectivity**: Verify RDP, SSM Session Manager
4. **Services**: Check SSM Agent, CloudWatch Agent
5. **Software**: Verify all required applications
6. **Security**: Test firewall rules, group policies
7. **Performance**: Compare boot times, resource usage

#### 6. Update Documentation

- Update runbooks with new build commands
- Document new features (SSM, CloudWatch)
- Update security baseline documentation
- Revise troubleshooting guides

## Side-by-Side Comparison

### Build Command Comparison

| Aspect            | Legacy JSON                 | Modern HCL2                |
| ----------------- | --------------------------- | -------------------------- |
| **Directory**     | `packfiles/Windows/`        | `hcl2/windows2022/`        |
| **Init Required** | No                          | Yes (`packer init .`)      |
| **Variables**     | Multiple `-var` flags       | Variables file or env vars |
| **Secrets**       | Was hardcoded (now fixed)   | Environment variables only |
| **Validation**    | `packer validate file.json` | `packer validate .`        |
| **Build**         | `packer build file.json`    | `packer build .`           |

### Runtime Comparison

| Metric             | Legacy    | Modern                    |
| ------------------ | --------- | ------------------------- |
| **Build Time**     | 15-25 min | 20-35 min (more features) |
| **AMI Size**       | ~8-10 GB  | ~12-15 GB (more software) |
| **Boot Time**      | ~2-3 min  | ~2-3 min                  |
| **Security Score** | Basic     | CIS-aligned               |

## Customization Examples

### Add Domain Join

Create `hcl2/windows2022/scripts/domain-join.ps1`:

```powershell
# Domain join configuration
$domain = "corp.example.com"
$ou = "OU=Servers,DC=corp,DC=example,DC=com"

# Note: Use AWS Secrets Manager for credentials in production
Add-Computer -DomainName $domain -OUPath $ou -Restart
```

Add to `build.windows2022.pkr.hcl`:

```hcl
provisioner "powershell" {
  scripts           = ["${path.root}/scripts/domain-join.ps1"]
  elevated_user     = var.winrm_username
  elevated_password = var.winrm_password
}
```

### Install IIS

Create `hcl2/windows2022/scripts/install-iis.ps1`:

```powershell
# Install IIS with management tools
Install-WindowsFeature -Name Web-Server -IncludeManagementTools
Install-WindowsFeature -Name Web-Asp-Net45
Install-WindowsFeature -Name Web-Mgmt-Console

# Configure IIS
Import-Module WebAdministration
Set-ItemProperty "IIS:\Sites\Default Web Site" -Name physicalPath -Value "C:\inetpub\wwwroot"
```

### Add Custom Monitoring

Extend `install-cloudwatch-agent.ps1` with custom metrics:

```powershell
# Add to CloudWatch config
$config.metrics.metrics_collected.add("Stateful_Service", @{
    measurement = @(
        @{
            name = "% Processor Time"
            rename = "ServiceCPU"
        }
    )
})
```

## Troubleshooting

### Common Issues

#### WinRM Timeout

**Symptoms:** Packer can't connect via WinRM

**Solutions:**

```bash
# Increase timeout
packer build -var "winrm_timeout=30m" .

# Check bootstrap script execution
# Via EC2 Serial Console: Get-Content C:\ProgramData\Amazon\EC2Launch\log\agent.log
```

#### Sysprep Failure

**Symptoms:** Build fails at sysprep stage

**Cause:** Pending Windows Updates or invalid configurations

**Solutions:**

1. Comment out Windows Updates provisioner for testing
2. Check EC2Launch v2 logs
3. Verify no unattend.xml conflicts

#### Software Installation Failures

**Symptoms:** Chocolatey packages fail to install

**Solutions:**

```powershell
# In install-software.ps1, add retry logic:
$maxRetries = 3
$retryCount = 0

do {
    try {
        choco install $package -y
        break
    }
    catch {
        $retryCount++
        Start-Sleep -Seconds 30
    }
} while ($retryCount -lt $maxRetries)
```

## Cost Optimization

### Build Costs

| Instance Type       | Cost per Hour (us-east-1) | Build Time  | Approx Cost |
| ------------------- | ------------------------- | ----------- | ----------- |
| t3.large            | $0.0832                   | ~30 min     | $0.04       |
| t3.xlarge           | $0.1664                   | ~25 min     | $0.07       |
| **t3.large (spot)** | **~$0.025**               | **~30 min** | **~$0.01**  |

**Recommendation:** Use spot instances (already configured in templates)

### Storage Costs

| Component       | Size       | Monthly Cost     |
| --------------- | ---------- | ---------------- |
| AMI (snapshot)  | ~12 GB     | $0.60/month      |
| Unused old AMIs | 12 GB each | $0.60/month each |

**Recommendation:** Use `../../ami-cleanup.sh` to remove old AMIs

```bash
# Keep only 3 most recent Windows Server 2022 AMIs
../../ami-cleanup.sh -n 3 -p "WindowsServer2022-Base"
```

## Best Practices

1. **Build Regularly**: Monthly builds ensure latest security patches
2. **Test Thoroughly**: Always test new AMIs before production deployment
3. **Use Spot Instances**: 70% cost savings for builds (pre-configured)
4. **Tag Everything**: Consistent tagging for cost allocation
5. **Automate Cleanup**: Remove old AMIs automatically
6. **Version Control**: Track all template changes in Git
7. **Secrets Management**: Never commit passwords or credentials
8. **Document Changes**: Maintain changelog for your AMIs

## Support Matrix

| Windows Version | Mainstream Support | Extended Support | Recommended         |
| --------------- | ------------------ | ---------------- | ------------------- |
| 2025            | 2025-2030          | 2030-2034        | ✓ Yes               |
| 2022            | 2021-2026          | 2026-2031        | ✓ Yes               |
| 2019            | 2018-2024          | 2024-2029        | Use 2022 instead    |
| 2016            | 2016-2022          | 2022-2027        | Migrate to 2022+    |
| 2012 R2         | 2013-2018          | 2018-2023        | **EOL - Don't use** |

## Next Steps

1. **Review the README** in `hcl2/windows2022/` for detailed usage
2. **Build a test AMI** in a non-production account
3. **Launch test instance** and verify functionality
4. **Update CI/CD** pipelines for automated builds
5. **Schedule monthly rebuilds** for security updates
6. **Implement AMI lifecycle** management with cleanup script

## Additional Resources

- [Windows Server 2022 Template](../hcl2/windows2022/)
- [Windows Server 2025 Template](../hcl2/windows2025/)
- [AMI Lifecycle Management](AMI-LIFECYCLE.md)
- [Template Inventory](TEMPLATE-INVENTORY.md)
- [Packer Documentation](https://www.packer.io/docs)
- [AWS EC2 Windows Guide](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/)
