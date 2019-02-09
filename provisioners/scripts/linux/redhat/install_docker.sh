#!/usr/bin/env bash
cd /tmp/ || exit
# pre-requisite for container-selinux-2.9-4.el7.noarch.rpm
sudo yum install policycoreutils-python

wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.21-1.el7.noarch.rpm
sudo rpm -i container-selinux-2.21-1.el7.noarch.rpm

#Set up the Docker CE repository on RHEL:
sudo yum install -y yum-utils
sudo yum install -y device-mapper-persistent-data lvm2
sudo yum-config-manager --enable rhel-7-server-extras-rpms
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast

# Install the latest version of Docker CE on RHEL:
sudo yum -y install docker-ce

#Start Docker:
sudo systemctl start docker

#Test your Docker CE installation:
sudo docker run hello-world

# configure Docker to start on boot
sudo systemctl enable docker

# add user to the docker group
sudo usermod -aG docker jethro

# install Docker Compose:
# install python-pip
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo yum install ./epel-release-latest-7.noarch.rpm
sudo yum install -y python-pip

sudo pip install docker-compose

# upgrade your Python packages:
sudo yum upgrade python*
