build {
  name = "windows-server-2025"
  sources = [
    "source.amazon-ebs.windows2025"
  ]

  # All scripts are compatible between Windows 2022 and 2025
  # Referencing the Windows 2022 scripts directory

  # Install Windows Updates
  provisioner "powershell" {
    scripts = [
      "${path.root}/../windows2022/scripts/install-updates.ps1"
    ]
    elevated_user     = var.winrm_username
    elevated_password = var.winrm_password
  }

  # Install essential software via Chocolatey
  provisioner "powershell" {
    scripts = [
      "${path.root}/../windows2022/scripts/install-software.ps1"
    ]
    elevated_user     = var.winrm_username
    elevated_password = var.winrm_password
  }

  # Install and configure AWS SSM Agent
  provisioner "powershell" {
    scripts = [
      "${path.root}/../windows2022/scripts/install-ssm-agent.ps1"
    ]
    elevated_user     = var.winrm_username
    elevated_password = var.winrm_password
  }

  # Install and configure CloudWatch Agent
  provisioner "powershell" {
    scripts = [
      "${path.root}/../windows2022/scripts/install-cloudwatch-agent.ps1"
    ]
    elevated_user     = var.winrm_username
    elevated_password = var.winrm_password
  }

  # Apply security hardening
  provisioner "powershell" {
    scripts = [
      "${path.root}/../windows2022/scripts/security-hardening.ps1"
    ]
    elevated_user     = var.winrm_username
    elevated_password = var.winrm_password
  }

  # Configure Windows features and optimization
  provisioner "powershell" {
    scripts = [
      "${path.root}/../windows2022/scripts/configure-windows.ps1"
    ]
    elevated_user     = var.winrm_username
    elevated_password = var.winrm_password
  }

  # Cleanup before creating AMI
  provisioner "powershell" {
    scripts = [
      "${path.root}/../windows2022/scripts/cleanup.ps1"
    ]
    elevated_user     = var.winrm_username
    elevated_password = var.winrm_password
  }

  # EC2Launch v2 configuration and sysprep
  provisioner "powershell" {
    inline = [
      "C:/ProgramData/Amazon/EC2Launch/ec2launch.exe reset --clean --block",
      "C:/ProgramData/Amazon/EC2Launch/ec2launch.exe sysprep --clean --shutdown"
    ]
    elevated_user     = var.winrm_username
    elevated_password = var.winrm_password
  }

  # Post-processor to create manifest
  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
    custom_data = {
      source_ami_name = "{{ .SourceAMIName }}"
      build_time      = "{{ timestamp }}"
      builder_type    = "{{ .BuilderType }}"
      os_version      = "Windows Server 2025"
    }
  }
}
