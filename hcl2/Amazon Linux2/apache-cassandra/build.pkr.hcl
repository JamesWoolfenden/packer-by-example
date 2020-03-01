build {
sources=[
  "source.amazon-ebs.cassandra"
  ]

  provisioner "shell" {
     scripts=[
       "../../provisioners/scripts/linux/install-cassandra.sh"
       ]
    }
}
