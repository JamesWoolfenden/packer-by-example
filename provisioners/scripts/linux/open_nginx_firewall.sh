#!/bin/bash -eux
# nginx
sudo firewall-cmd --permanent --zone=public --add-port=22/tcp
