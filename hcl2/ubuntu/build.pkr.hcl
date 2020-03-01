build {
sources=[
  "source.amazon-ebs.base1604"
  ]

  provisioner "shell" {
     scripts=[
       "../provisioners/scripts/linux/ubuntu/install_ansible.sh",
       "../provisioners/scripts/linux/ubuntu/install_aws_ssm.sh"]
  }
    provisioner "ansible-local" {
      playbook_file= "../provisioners/ansible/playbooks/cloudwatch-metrics.yml"
      role_paths= [
        "../provisioners/ansible/roles/cloudwatch-metrics"
      ]
    }
}
