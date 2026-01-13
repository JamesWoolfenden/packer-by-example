variable "vpc_id" {
  description = "The VPC you're building AMI's in"
  type        = string
}

variable "region" {
  description = "The AWS region you're using"
  type        = string
}

variable "subnet_id" {
  description = "The Subnet to build the AMI inm that's ssh'able"
  type        = string
}

variable "winrm_password" {
  description = "The WinRM password for Windows builds (set via WINRM_PASSWORD env var)"
  type        = string
  sensitive   = true
}
