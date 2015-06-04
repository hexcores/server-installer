#!/usr/bin/env bash

#echo ">>> Installing MongoDB"

# Get key and add to sources
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

# Update
sudo apt-get -y update
sudo apt-get install -y mongodb-org
sudo pecl install mongo
# add extencion file and restart service
echo 'extension=mongo.so' | sudo tee /etc/php5/mods-available/mongo.ini
sudo php5enmod mongo

sudo service apache2 restart