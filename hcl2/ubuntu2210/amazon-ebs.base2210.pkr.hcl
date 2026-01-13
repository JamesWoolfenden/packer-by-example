source "amazon-ebs" "base2210" {
  ami_description             = "ubuntu base 22.10"
  ami_name                    = "ubuntu-22.10-BASE-v1-{{timestamp}}-AMI"
  ami_users                   = var.ami_users
  ami_virtualization_type     = "hvm"
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  region                      = var.region
  run_tags = {
    Name        = "ubuntu-base-packer"
    Application = "base"
    OS          = "Ubuntu 22.10"
  }

  ssh_username = "ubuntu"
  subnet_id    = var.subnet_id
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-kinetic-22.10-amd64-server-*"
      root-device-type    = "ebs"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  temporary_key_pair_name = "ubuntu-packer-{{timestamp}}"
  vpc_id                  = var.vpc_id
  tags = {
    OS_Version  = "Ubuntu 22.10"
    Version     = var.BUILD_NUMBER
    Application = "Ubuntu Image"
    Runner      = "EC2"
  }
}
