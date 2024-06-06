#!/bin/bash
 
# Install nginx server
sudo apt update
sudo apt install nginx -y
 
# Add client_max_body_size with a value of 300M to Nginx configuration using sed
if ! grep -q "client_max_body_size" /etc/nginx/nginx.conf; then
    sudo sed -i '/http {/a client_max_body_size 300M;' /etc/nginx/nginx.conf
fi
 
# Uncomment the line server_tokens
sudo sed -i 's/# server_tokens off;/server_tokens off;/' /etc/nginx/nginx.conf
 
# Install PHP version with all extensions
read -p "Enter PHP version to install (e.g. 7.4): " php_version
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install php$php_version-fpm php$php_version-mysql php$php_version-curl php$php_version-gd php$php_version-mbstring php$php_version-xml php$php_version-xmlrpc -y
 
# Modify PHP INI values

if ! grep -q "max_execution_time = 300" /etc/php/$php_version/fpm/php.ini; then
    sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/$php_version/fpm/php.ini
fi
if ! grep -q "memory_limit = 256M" /etc/php/$php_version/fpm/php.ini; then
    sudo sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/$php_version/fpm/php.ini
fi
if ! grep -q "post_max_size = 300M" /etc/php/$php_version/fpm/php.ini; then
    sudo sed -i 's/post_max_size = 8M/post_max_size = 300M/' /etc/php/$php_version/fpm/php.ini
fi
if ! grep -q "upload_max_filesize = 300M" /etc/php/$php_version/fpm/php.ini; then
    sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 300M/' /etc/php/$php_version/fpm/php.ini
fi
 
# Restart PHP-FPM
sudo systemctl restart php$php_version-fpm
 
# Install MySQL server
sudo apt install mysql-server -y
 
# Turn off echo to hide password input
stty -echo
read -p "Enter MySQL root user password: " mysql_password
# Turn echo back on
stty echo
echo  # Add a newline after the password input

# Change the root password dynamically
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$mysql_password';"
