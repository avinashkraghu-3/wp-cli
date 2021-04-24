#!/bin/bash
 
read -r -p "install nginx,php7.4,mysql-10.3,npm,pm2,node,phpmyadmin only confirm [Y/n] " input
 
case $input in
    [yY][eE][sS]|[yY])
sudo apt-get update
echo " "
echo "software-properties-common "
sudo apt -y install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt install php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl php7.4-fpm -y
sudo apt-get install -y nginx
sudo apt install wget
wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
echo "7a24f5580421fd353dc22c5439001bdaec86c54ed911c80e5482f62921125ac8 mariadb_repo_setup" \
    | sha256sum -c -
chmod +x mariadb_repo_setup
sudo ./mariadb_repo_setup \
   --mariadb-server-version="mariadb-10.3"
sudo apt update
sudo apt install mariadb-server mariadb-backup -y
systemctl status mariadb
#sudo apt install pwgen -y
#PASS=`pwgen -s 40 1`
#echo $PASS > sftp_password.txt
#read -p "Enter sftp username : " sftpusername
#echo $PASS
#useradd -m $sftpusername
#echo "$sftpusername:$PASS" | chpasswd

echo "installing node and npm latest version"
echo "list of npm - https://nodejs.org/dist/v14.16.1/"
cd /opt/
sudo chmod -R 755 ./
wget https://nodejs.org/dist/v14.16.1/node-v14.16.1-linux-x64.tar.gz
tar xf node-v14.16.1-linux-x64.tar.gz
export NODEJS_HOME=/opt/node-v14.16.1-linux-x64/bin
export PATH=$NODEJS_HOME:$PATH
cat << EOF >> ~/.profile
export NODEJS_HOME=/opt/node-v10.1.0-linux-x64/bin
export PATH=$NODEJS_HOME:$PATH
EOF
echo "refresh profile"
. ~/.profile

echo "pm2 installation"
npm install -g pm2

echo "list pm2 services"
pm2 list

echo "install phpadmin"
echo "###############################"
echo "press tab for nginx installtion"
echo "###############################"
sudo apt update
sudo apt install phpmyadmin

cp -pv /root/allin_one/phpmyadmin.conf /etc/nginx/snippets/phpmyadmin.conf
cp -pv /etc/nginx/sites-available/default /etc/nginx/sites-available/default_backup
sed '/# include/a    include snippets/phpmyadmin.conf;' /etc/nginx/sites-available/default >  /etc/nginx/sites-available/default_1
mv /etc/nginx/sites-available/default_1 /etc/nginx/sites-available/default
sudo systemctl restart nginx

 ;;
    [nN][oO]|[nN])
 echo "No"
       ;;
    *)
 echo "Invalid input..."
 exit 1
 ;;
esac
