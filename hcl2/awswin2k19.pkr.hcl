source "amazon-ebs" "Windows2019" {
      region= ""
      instance_type= "t2.micro"
      source_ami_filter {
        filters {
          virtualization-type= "hvm"
          name="Windows_Server-2019-English-Full-Base*"
          root-device-type= "ebs"
        }
        most_recent= true
        owners= ["amazon"]
      }
      ami_name= "Base v1 Windows2019 {{timestamp}}"
      ami_description= "Windows 2019 Base"
      associate_public_ip_address="true"
      user_data_file= "./HCL2/bootstrap_win.txt"
      communicator= "winrm"
      winrm_username= "Administrator"
      winrm_timeout= "10m"
      winrm_password="SuperS3cr3t!!!!"
      #using spot market as cheaper
      spot_price="0"
      #if empty it uses the default vpc, COMMENTS!!!!
      vpc_id= ""
      subnet_id=""
}
