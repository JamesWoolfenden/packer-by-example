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
      ami_name= "Base v1 Windows2019"
      ami_description= "Windows 2019 Base"
      user_data_file= "bootstrap_win.txt"
      communicator= "winrm"
      winrm_username= "Administrator"
      winrm_timeout= "10m"
      winrm_password="SuperS3cr3t!!!!"
      #if empty it uses the default vpc, COMMENTS!!!!
      vpc_id= ""
      subnet_id=""
}

build {
sources =[
   "source.amazon-ebs.Windows2019"
]
 provisioner "powershell" {
    inline = ["iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))|out-null"
      ,"choco install javaruntime -y -force"]
  }
}
