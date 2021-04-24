#!/bin/bash
clear
echo "_script_developed_by_Avinash_"

echo "_wp-cli Downloading"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
echo " "
echo " update_repository "
sudo apt-get update

echo " "
echo "software-properties-common "
sudo apt -y install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt install php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl -y

echo " "
echo "send mail installation"
sudo apt-get install sendmail -y
echo ""
echo "nginx_installtion"
sudo apt-get install -y nginx

echo " "
echo "php fpm installation"
sudo apt-get install -y php7.4-fpm
sudo apt-get install -y nginx mariadb-server mariadb-client php-fpm php-mysql

php wp-cli.phar --info
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp --info

echo "_Database_details_"
echo -n "Database Host (localhost) :"
read dbhost
echo " "
echo -n "Database Name : "
read dbname
echo -n "Database User : "
read dbuser
echo
echo -n "Database Password : "
read dbpass

echo "_Admin_details_"
echo -n "Site url (https://www.xxxx.com/) : "
read siteurl
echo -n "Site Name (xxxxx) : "
read sitename
echo -n "amail Address (avinash@flexicloud.in) : "
read wpemail
echo -n "admin User Name : "
read wpuser
echo -n "admin User Password : "
read wppass
echo
echo "wordpress_installation"
echo "Downloading wordpress latest version..."
curl -O https://wordpress.org/latest.tar.gz
echo "Extracting tarball wordpress..."
tar -zxvf latest.tar.gz

cp -rf wordpress/* /var/www/html
cd /var/www/html
chown -R www-data:www-data .

#create wp config
echo
echo "Creating database configuration file..."
cp -pv wp-config-sample.php wp-config.php
#set database details with perl find and replace
perl -pi -e "s/localhost/$dbhost/g" wp-config.php
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php
#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 777 wp-content/uploads

echo "Installing wordpress..."
sudo wp core install --url="$siteurl" --title="$sitename" --admin_user="$wpuser" --admin_password="$wppass" --admin_email="$wpemail" --allow-root

echo "Installation is complete."
