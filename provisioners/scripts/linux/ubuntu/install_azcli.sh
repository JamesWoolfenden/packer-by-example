#!/usr/bin/env bash
sudo apt-get install apt-transport-https lsb-release software-properties-common dirmngr -y

#modify sources
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list

# signing key
curl -sL "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xEB3E94ADBE1229CF" | sudo apt-key add

# now the cli
sudo apt-get update
sudo apt-get install azure-cli
