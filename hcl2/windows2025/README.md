# Windows Server 2025 Packer Template

Modern HCL2 Packer template for building Windows Server 2025 AMIs. This template extends the Windows Server 2022 template with Windows Server 2025-specific configurations.

## What's New in Windows Server 2025

- Enhanced security features
- Improved hybrid cloud capabilities
- Better performance and efficiency
- Updated security baselines
- Extended support lifecycle

## Quick Start

```bash
# Set required variables
export AWS_REGION="us-east-1"
export WINRM_PASSWORD=...
export BUILD_NUMBER="1"

# Initialize and build
packer init .
packer build \
  -var "vpc_id=vpc-xxxxx" \
  -var "subnet_id=subnet-xxxxx" \
  .
```

## Template Structure

This template reuses most scripts from the Windows Server 2022 template since they're compatible. Only the source AMI filter differs to select Windows Server 2025 images.

## Shared Scripts

The following scripts are shared with Windows 2022:

- Bootstrap WinRM configuration
- Software installation
- SSM Agent setup
- CloudWatch Agent configuration
- Security hardening
- Windows optimization
- Cleanup procedures

See the [Windows Server 2022 README](../windows2022/README.md) for detailed documentation on these scripts.

## Windows 2025 Specific Features

The template is pre-configured for Windows Server 2025 but uses the same hardening and configuration scripts as 2022. Windows Server 2025 maintains backward compatibility while adding new features.

For full documentation, customization options, and troubleshooting, refer to the [Windows Server 2022 template](../windows2022/).

## Build Time

- **Without Updates**: 20-30 minutes
- **With Updates**: 45-90 minutes

## Availability

Note: Windows Server 2025 AMIs may not be available in all AWS regions immediately after release. Check AWS Marketplace for availability in your region.
