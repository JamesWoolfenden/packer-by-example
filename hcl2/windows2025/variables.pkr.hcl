# Variables for Windows Server 2025
# Identical to Windows 2022 - keeping separate for future customization

variable "region" {
  description = "The AWS region to build in"
  type        = string
  default     = env("AWS_REGION")
}

variable "vpc_id" {
  description = "The VPC ID to build in"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to build in"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for building"
  type        = string
  default     = "t3.large"
}

variable "build_number" {
  description = "Build number for versioning"
  type        = string
  default     = env("BUILD_NUMBER")
}

variable "winrm_password" {
  description = "Administrator password for WinRM (sensitive)"
  type        = string
  sensitive   = true
  default     = env("WINRM_PASSWORD")
}

variable "winrm_username" {
  description = "Administrator username for WinRM"
  type        = string
  default     = "Administrator"
}

variable "ami_users" {
  description = "List of AWS account IDs to share the AMI with"
  type        = list(string)
  default     = []
}

variable "ami_regions" {
  description = "List of regions to copy the AMI to"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the AMI"
  type        = map(string)
  default     = {}
}
