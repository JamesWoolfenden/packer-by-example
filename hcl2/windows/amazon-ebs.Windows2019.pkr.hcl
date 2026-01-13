source "amazon-ebs" "Windows2019" {
  ami_description             = "Windows 2019 Base"
  ami_name                    = "Base v1 Windows2019 {{timestamp}}"
  associate_public_ip_address = "true"
  communicator                = "winrm"
  instance_type               = "t2.micro"
  region                      = var.region
  source_ami_filter {
    filters {
      virtualization-type = "hvm"
      name                = "Windows_Server-2019-English-Full-Base*"
      root-device-type    = "ebs"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  #using spot market as cheaper
  spot_price     = "auto"
  subnet_id      = var.subnet_id
  user_data_file = "./HCL2/bootstrap_win.txt"
  #if empty it uses the default vpc, COMMENTS!!!!
  vpc_id         = var.vpc_id
  winrm_password = var.winrm_password
  winrm_timeout  = "10m"
  winrm_username = "Administrator"
}
