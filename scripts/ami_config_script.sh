#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get update

# As always, there's an apt race condition that results in
# E: Unable to locate package mysql-server
# ...if we don't wait here for a sec. What a sad heap of garbage.
sleep 20

sudo apt-get install mysql-server -y

sudo apt-get install nginx php-mysql php-fpm -y

sudo systemctl start nginx php8.3-fpm
sudo systemctl enable mysql nginx php8.3-fpm

# Modules from https://make.wordpress.org/hosting/handbook/server-environment/#php-extensions
sudo apt-get install -y php-curl php-common php-imagick php-mbstring php-xml php-zip php-json php-xmlrpc php-gd php-intl

# some nginx config
sudo mkdir -p /usr/share/nginx/cache/fcgi
sudo rm /etc/nginx/sites-enabled/default

# some php config
# TODO in 22.04 this is naturally in /run/php/, e.g. /run/php/php-fpm.sock
sudo mkdir /run/php-fpm
# I am choosing to leave the default php-fpm conf because it's fine (/etc/php/8.3/fpm/php-fpm.conf)
