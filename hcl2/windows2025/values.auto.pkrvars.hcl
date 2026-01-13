# Default values for Windows Server 2025 Packer build

# AWS Configuration
# region      = "us-east-1"          # Set via AWS_REGION env var
# vpc_id      = "vpc-xxxxx"          # Required
# subnet_id   = "subnet-xxxxx"       # Required

# Instance Configuration
instance_type = "t3.large"           # t3.large recommended for Windows builds

# Build Configuration
# build_number   = "1"               # Set via BUILD_NUMBER env var or default to "1"

# WinRM Configuration (Security: Use environment variables, not hardcoded values)
# pragma: allowlist secret
# winrm_password = "SecurePassword"  # Set via WINRM_PASSWORD env var (REQUIRED)
winrm_username = "Administrator"

# AMI Sharing (Optional)
ami_users   = []                     # List of AWS account IDs to share AMI with
ami_regions = []                     # List of regions to copy AMI to

# Additional Tags (Optional)
tags = {
  Environment = "Production"
  ManagedBy   = "Packer"
  Department  = "Infrastructure"
  OSVersion   = "Windows Server 2025"
}
