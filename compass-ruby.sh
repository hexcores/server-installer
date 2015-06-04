#!/usr/bin/env bash

echo "Install Ruby and Compass"

#https://gorails.com/setup/ubuntu/14.04
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties
sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

echo "Get RVM Installer"
 
curl -L https://get.rvm.io | bash -s stable

echo "Make RVM Source"

source ~/.rvm/scripts/rvm
echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc

echo "RVM Install for Ruby 2.1.2"

rvm install 2.1.2
rvm use 2.1.2 --default
ruby -v

echo "Install compass gem" 
#http://blog.acrona.com/index.php?post/2014/05/15/Installer-Fondation-et-Compass/sass-sur-Ubuntu-14.04
gem install compass
