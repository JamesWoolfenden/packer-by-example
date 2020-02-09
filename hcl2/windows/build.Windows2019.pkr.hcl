build {
sources =[
   "source.amazon-ebs.Windows2019"
]
 provisioner "powershell" {
    inline = ["iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))|out-null"
      ,"choco install javaruntime -y -force"]
  }
}
