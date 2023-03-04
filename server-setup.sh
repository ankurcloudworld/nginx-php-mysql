#!/bin/bash

# Install nginx server
sudo apt update
sudo apt install nginx -y

# Uncomment the line server_tokens at /etc/nginx/nginx.conf
sudo sed -i 's/# server_tokens off;/server_tokens off;/' /etc/nginx/nginx.conf

# Install PHP version with all extensions
read -p "Enter PHP version to install (e.g. 7.4): " php_version
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install php$php_version-fpm php$php_version-mysql php$php_version-curl php$php_version-gd php$php_version-mbstring php$php_version-xml php$php_version-xmlrpc>

# Install MySQL server
sudo apt install mysql-server -y
read -p "Enter MySQL username: " mysql_user
read -s -p "Enter MySQL password: " mysql_password
sudo mysql -e "CREATE USER '$mysql_user'@'localhost' IDENTIFIED WITH mysql_native_password BY '$mysql_password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$mysql_user'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"
