#!/usr/bin/env bash
# Install OpenTofu (open source Terraform alternative)
cd /tmp/ || exit
VERSION="1.8.2"
sudo apt install -y zip unzip
wget "https://github.com/opentofu/opentofu/releases/download/v${VERSION}/tofu_${VERSION}_linux_amd64.zip"
unzip "tofu_${VERSION}_linux_amd64.zip"
sudo mv /tmp/tofu /usr/local/bin/
# Create terraform symlink for compatibility
sudo ln -sf /usr/local/bin/tofu /usr/local/bin/terraform
