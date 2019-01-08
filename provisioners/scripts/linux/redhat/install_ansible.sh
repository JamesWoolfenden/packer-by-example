#!/bin/bash -eux

# Install EPEL repository.
sudo yum update -y

# this can fail if you havent accepted this in your aws account
#sudo subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"
#sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install Ansible.
sudo yum -y install python
sudo easy_install pip
sudo pip install ansible
