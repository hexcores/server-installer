#!/usr/bin/env bash

echo ">>> Welcome Nginx, MongoDB, NodeJS, PHP Installer
- Nginx
- PHP 5.6
- MongoDB
- NodeJS 0.12
- Git
- Bower
- Gulp
- Composer
- Python 2.7
- Redis
- Memcached
"

# Update Ubuntu Packages
sudo apt-get update

# Update System Packages
sudo apt-get -y upgrade

# Set Locale
echo ">>> Setting up Timezone & Locale to en_US.UTF-8"
sudo echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
sudo locale-gen en_US.UTF-8
sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Install Some PPAs
sudo apt-add-repository -y ppa:nginx/stable
sudo apt-add-repository -y ppa:git-core/ppa
sudo apt-add-repository -y ppa:ondrej/php5-5.6
sudo apt-add-repository -y ppa:rwky/redis

# Update Again Ubuntu Packages
sudo apt-get update

# Install base package
echo ">>> Install Basic Package and Git"
sudo apt-get install -y software-properties-common build-essential \
curl unzip git-core ack-grep gcc libmcrypt4 libpcre3-dev \
make python2.7-dev python-pip re2c whois vim

# Install Nginx Server
echo ">>> Installing Nginx Server"
sudo apt-get install -y nginx

# Prepare Blackfire
curl -s https://packagecloud.io/gpg.key | sudo apt-key add -
echo "deb http://packages.blackfire.io/debian any main" | sudo tee /etc/apt/sources.list.d/blackfire.list

# Install MongoDB
echo ">>> Installing MongoDB"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
# Update
sudo apt-get -y update
sudo apt-get install -y mongodb-org

# Install NodeJS
echo ">>> Installing NodeJS, Gulp and Bower"
curl -sL https://deb.nodesource.com/setup_5.x | sudo bash -
sudo apt-get install -y nodejs
sudo /usr/bin/npm install -g gulp
sudo /usr/bin/npm install -g bower

# Install PHP 5.6 and Extensions
echo ">>> Installing PHP 5.6 and Extensions"
sudo apt-get install -y php5-cli php5-fpm php5-dev php-pear \
php5-apcu php5-json php5-curl php5-gd php5-imagick \
php5-gmp php5-imap php5-mcrypt php5-xdebug php5-memcached

# Install Redis and Memcached
echo ">>> Installing Redis and Memcached"
sudo apt-get install -y redis-server memcached

# Enable PHP mcrypt for Laravel
sudo ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available
sudo php5enmod mcrypt

# Install Blackfire
sudo apt-get install -y blackfire-agent blackfire-php

# Install SSH Extension For PHP
apt-get install -y libssh2-1-dev libssh2-php

# Setup PHP mongo extennsion
sudo pecl install mongo
echo 'extension=mongo.so' | sudo tee /etc/php5/mods-available/mongo.ini
sudo ln -s /etc/php5/mods-available/mongo.ini /etc/php5/fpm/conf.d/mongo.ini
sudo ln -s /etc/php5/mods-available/mongo.ini /etc/php5/cli/conf.d/mongo.ini

# Configure PHP Error Reporting
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/cli/php.ini

# Configure PHP Date Timezone
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php5/cli/php.ini

# Configure PHP Memory Limit, Upload Filesize and Post Size
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php5/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php5/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/cli/php.ini

# Configure PHP XDebug
sudo tee $(find /etc/php5 -name xdebug.ini) <<-EOF
zend_extension=$(find /usr/lib/php5 -name xdebug.so)
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1
xdebug.max_nesting_level=250
EOF

# Restart Nginx and PHP
sudo service nginx restart
sudo service php5-fpm restart

# Create SWAP
sudo fallocate -l 1M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# Setup the Swap file for permanent
echo "/swapfile   none    swap    sw    0   0" | sudo tee -a /etc/fstab

# Install composer
echo ">>> Installing Composer"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Install Laravel Envoy
composer global require "laravel/envoy=~1.0"

