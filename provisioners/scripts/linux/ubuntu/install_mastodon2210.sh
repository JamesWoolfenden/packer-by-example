#!/bin/bash -eux
sudo apt update -y 
sudo apt-get install -y curl
curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install nodejs

sudo npm install -g yarn
yarn -v

sudo apt install -y \
imagemagick ffmpeg libpq-dev libxml2-dev libxslt1-dev file git-core \
g++ libprotobuf-dev protobuf-compiler pkg-config gcc autoconf \
bison build-essential libssl-dev libyaml-dev libreadline6-dev \
zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev \
nginx redis-server redis-tools postgresql postgresql-contrib \
certbot libidn11-dev libicu-dev libjemalloc-dev ruby ruby-dev git

sudo adduser mastodon --system --group --disabled-login

git clone https://github.com/tootsuite/mastodon.git
sudo mkdir -p /var/www/
sudo mv mastodon/ /var/www/
sudo chown mastodon:mastodon /var/www/mastodon/ -R
cd /var/www/mastodon/
sudo -u mastodon git checkout v3.5.3
sudo gem install bundler
sudo -u mastodon bundle config deployment 'true'
sudo -u mastodon bundle config without 'development test'
sudo -u mastodon bundle install -j$(getconf _NPROCESSORS_ONLN)
