build {
sources=[
  "source.amazon-ebs.cassandra-dse"
  ]

  provisioner "shell" {
     scripts=[
       "../../provisioners/scripts/linux/install-cassandra-dse.sh"
       ]
    }
}
