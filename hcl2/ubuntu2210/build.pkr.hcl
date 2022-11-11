build {
  sources = [
    "source.amazon-ebs.base2210"
  ]

  provisioner "shell" {
    scripts = [
      "../provisioners/scripts/linux/ubuntu/install_aws_ssm2210.sh"]
  }
}
