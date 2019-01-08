#!/bin/bash -eux
# broker
sudo firewall-cmd --permanent --zone=public --add-port=6668/tcp
sudo firewall-cmd --permanent --zone=public --add-port=22/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9092/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9093/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9094/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9095/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9096/tcp

# connect
sudo firewall-cmd --permanent --zone=public --add-port=8083/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9021/tcp

# zookeeper
sudo firewall-cmd --permanent --zone=public --add-port=2181/tcp
sudo firewall-cmd --permanent --zone=public --add-port=2888/tcp
sudo firewall-cmd --permanent --zone=public --add-port=5570/tcp
sudo firewall-cmd --permanent --zone=public --add-port=5580/tcp
sudo firewall-cmd --permanent --zone=public --add-port=5590/tcp
sudo firewall-cmd --permanent --zone=public --add-port=0-65000/tcp
sudo firewall-cmd --permanent --zone=public --add-port=0-65000/udp
