locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "windows2022" {
  # AMI Configuration
  ami_name                    = "WindowsServer2022-Base-v${var.build_number}-${local.timestamp}"
  ami_description             = "Windows Server 2022 Base Image with CloudWatch and SSM"
  ami_virtualization_type     = "hvm"
  ami_users                   = var.ami_users
  ami_regions                 = var.ami_regions

  # Source AMI - Windows Server 2022 English Full Base
  source_ami_filter {
    filters = {
      name                = "Windows_Server-2022-English-Full-Base*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["801119661308"] # Amazon
    most_recent = true
  }

  # Instance Configuration
  region                      = var.region
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id

  # Spot Instance for cost savings
  spot_price                  = "auto"
  spot_instance_types         = ["t3.large", "t3a.large"]

  # WinRM Communicator Configuration
  communicator                = "winrm"
  winrm_username              = var.winrm_username
  winrm_password              = var.winrm_password
  winrm_timeout               = "15m"
  winrm_use_ssl               = true
  winrm_insecure              = true

  # User Data for WinRM Setup
  user_data_file              = "${path.root}/scripts/bootstrap-winrm.ps1"

  # Launch Configuration
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 50
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true
    encrypted             = true
  }

  # Run Tags
  run_tags = {
    Name        = "packer-windows2022-builder"
    Application = "Windows Server 2022 Base"
    OS          = "Windows Server 2022"
    Builder     = "Packer"
    ManagedBy   = "Packer"
  }

  # AMI Tags
  tags = merge(
    {
      Name         = "WindowsServer2022-Base-v${var.build_number}"
      OS_Version   = "Windows Server 2022"
      OS_Family    = "Windows"
      Version      = var.build_number
      Application  = "Base Image"
      Runner       = "EC2"
      BuildDate    = local.timestamp
      PackerSource = "hcl2/windows2022"
    },
    var.tags
  )

  # Metadata options for enhanced security
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # IMDSv2 required
    http_put_response_hop_limit = 1
  }
}
