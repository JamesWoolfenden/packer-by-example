#!/usr/bin/env bash
cd /tmp/
VERSION="0.11.11"
sudo apt install -y zip unzip
wget "https://releases.hashicorp.com/terraform/$VERSION/terraform_${VERSION}_linux_amd64.zip"
unzip "terraform_${VERSION}_linux_amd64.zip"
sudo mv /tmp/terraform /usr/local/bin/
