#!/bin/bash
sudo yum install java-1.8.0-openjdk -y
sudo yum install libaio -y

cat <<EOF | sudo tee -a /etc/yum.repos.d/datastax.repo
[datastax]
name=DataStax Repo for DataStax Enterprise
baseurl=https://rpm.datastax.com/enterprise/
enabled=1
gpgcheck=1
EOF

sudo rpm --import https://rpm.datastax.com/rpm/repo_key

sudo yum update -y
sudo yum install dse-full -y

sudo systemctl daemon-reload
sudo service dse stop

# clear out data
sudo rm -rf /var/lib/cassandra/data/system/*
