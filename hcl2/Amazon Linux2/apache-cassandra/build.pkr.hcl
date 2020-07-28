build {
sources=[
  "source.amazon-ebs.cassandra"
  ]

  provisioner "shell" {
     scripts=[
       "{{ template_dir }}install-cassandra.sh"
       ]
    }
}
