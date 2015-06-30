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
sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime
sudo locale-gen en_US.UTF-8

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

# Install MongoDB
echo ">>> Installing MongoDB"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
# Update
sudo apt-get -y update
sudo apt-get install -y mongodb-org
sudo pecl install mongo

# Install NodeJS
echo ">>> Installing NodeJS, Gulp and Bower"
curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
sudo apt-get install -y nodejs
sudo /usr/bin/npm install -g gulp
sudo /usr/bin/npm install -g bower

# Install PHP 5.6
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

# Enable PHP mongo
echo 'extension=mongo.so' | sudo tee /etc/php5/mods-available/mongo.ini
sudo php5enmod mongo

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
sudo echo "xdebug.cli_color = 1" >> /etc/php5/fpm/conf.d/20-xdebug.ini
sudo echo "xdebug.remote_enable = 1" >> /etc/php5/fpm/conf.d/20-xdebug.ini
sudo echo "xdebug.remote_port = 9000" >> /etc/php5/fpm/conf.d/20-xdebug.ini
sudo echo "xdebug.show_local_vars = 1" >> /etc/php5/fpm/conf.d/20-xdebug.ini
sudo echo "xdebug.remote_connect_back = 1" >> /etc/php5/fpm/conf.d/20-xdebug.ini
sudo echo "xdebug.max_nesting_level = 250" >> /etc/php5/fpm/conf.d/20-xdebug.ini

# Restart Nginx and PHP
sudo service nginx restart
sudo service php5-fpm restart

# Install composer
echo ">>> Installing Composer"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
