source "amazon-ebs" "demo" {
      region= "eu-west-1"
      instance_type= "t2.micro"
      source_ami_filter {
        filters {
          virtualization-type= "hvm"
          name= "*Windows_Server-2012-R2*English-64Bit-Base*"
          root-device-type= "ebs"
        }
        most_recent= true
        owners= ["amazon"]
      }
      ami_name= "packer-demo-{{timestamp}}"
      user_data_file= ".\\bootstrap_win.txt"
      communicator= "winrm"
      winrm_username= "Administrator"
      winrm_password="SuperS3cr3t!!!!"
      vpc_id= "vpc-510efa34"
      subnet_id="subnet-f60eff81"
}

build {
sources =[
   "source.amazon-ebs.demo"
]
}
