variable "vpc_id" {
  description="The VPC you're building AMI's in"
  type=string
}

variable "region" {
  description="The AWS region you're using"
  type=string
}

variable "subnet_id" {
  description="The Subnet to build the AMI inm that's ssh'able"
  type=string
}

variable "BUILD_NUMBER" {
  description="The build number"
  type=string
  default="1"
}

variable "instance_type" {
  default="t3.micro"
  description="The AMI build instance"
  type=string
}

variable "ami_users" {
  default=[]
}

variable "associate_public_ip_address" {
  type=bool
  default=true
}

variable "ssh_interface" {
  type   = string
  default= "public_ip"
}
