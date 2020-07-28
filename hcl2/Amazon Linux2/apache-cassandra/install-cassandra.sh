#!/bin/bash
sudo yum install java-1.8.0-openjdk -y

cat <<EOF | sudo tee -a /etc/yum.repos.d/cassandra311x.repo
[cassandra]
name=Apache Cassandra
baseurl=https://www.apache.org/dist/cassandra/redhat/311x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.apache.org/dist/cassandra/KEYS
EOF

sudo yum update -y

sudo yum install cassandra -y
sudo systemctl daemon-reload
sudo service cassandra stop

# clear out data
sudo rm -rf /var/lib/cassandra/data/system/*
