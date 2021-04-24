#!/bin/bash
sudo apt install pwgen -y
PASS=`pwgen -s 40 1`

echo -n "Database Name : "
read dbname


echo -n "Database user : "
read dbuser

mysql -uroot <<MYSQL_SCRIPT
CREATE DATABASE $dbname;

CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL user created."
echo "Username:   $dbuser" > db_details.txt
echo "Username:   $dbname" >> db_details.txt
echo "Password:   $PASS"   >> db_details.txt
