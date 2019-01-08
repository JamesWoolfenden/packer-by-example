#!/usr/bin/env bash
cd /tmp/
sudo yum install -y zip unzip
wget https://releases.hashicorp.com/terraform/0.11.9/terraform_0.11.9_linux_amd64.zip
unzip terraform_0.11.9_linux_amd64.zip
sudo mv /tmp/terraform /usr/local/bin/
