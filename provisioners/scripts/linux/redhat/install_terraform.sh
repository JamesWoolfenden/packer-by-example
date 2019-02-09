#!/usr/bin/env bash
cd /tmp/ || exit
sudo yum install -y zip unzip
wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
unzip terraform_0.11.10_linux_amd64.zip
sudo mv /tmp/terraform /usr/local/bin/
