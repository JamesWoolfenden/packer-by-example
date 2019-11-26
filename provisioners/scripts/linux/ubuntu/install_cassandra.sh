#!/bin/bash -eux
sudo apt-get install -y python-minimal
sudo apt-key adv --keyserver pool.sks-keyservers.net --recv-key A278B781FE4B2BDA
sudo apt-get update
echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y cassandra
sudo service cassandra stop

# clear out data
sudo rm -rf /var/lib/cassandra/data/system/*
