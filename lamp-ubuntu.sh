#!/usr/bin/env bash

echo ">>> Installing Apache Server"

# Add repo for latest FULL stable Apache
# (Required to remove conflicts with PHP PPA due to partial Apache upgrade within it)
sudo add-apt-repository -y ppa:ondrej/apache2


# Update Again
sudo apt-key -y update
sudo apt-get -y update
sudo apt-get -y install apache2

echo ">>> Installing Git"

sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get -y update
sudo apt-get install -y git

echo ">>> Installing PHP"

# Add repo for PHP 5.5
sudo add-apt-repository -y ppa:ondrej/php5

# Update Again
sudo apt-key -y update
sudo apt-get -y update

sudo apt-get install -y php5-cli php5-fpm php5-json php5-dev php-pear libpcre3-dev php5-curl php5-gd php5-gmp php5-mcrypt php5-imagick php5-intl php5-xdebug


echo ">>> Installing MySQL"
sudo apt-get install -y mysql-server libapache2-mod-auth-mysql php5-mysql

echo ">>> Installing Memcache"
sudo apt-get install -y memcached php5-memcached

echo ">>> Installing MongoDB"

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

echo ">>> Installing Composer"

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer