#!/bin/bash
# This script reset MySQL password then import Zabbix Database

#Hack to avaoid mysql.sock error
usermod -d /var/lib/mysql/ mysql
ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock
chown -R mysql:mysql /var/lib/mysql

service mysql restart 

# Changing MySQL default Password
MYSQL_PASSWORD="root"
echo "mysql root and admin password: $MYSQL_PASSWORD"
mysqladmin -uroot password $MYSQL_PASSWORD

#Create Zabbix User
mysql -uroot -p"$MYSQL_PASSWORD" -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbix';"
mysql -uroot -p"$MYSQL_PASSWORD" -e "GRANT ALL PRIVILEGES ON *.* TO 'zabbix'@'localhost' WITH GRANT OPTION;"

# Create Database Zabbix
mysql -uroot -p"$MYSQL_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS zabbix CHARACTER SET utf8;"

#Import Zabbix Database
zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -u zabbix -pzabbix zabbix
zabbix_mysql_v="$(ls -d /usr/share/doc/zabbix-server-mysql-*)"
mysql -uroot -D zabbix -p"$MYSQL_PASSWORD" < "${zabbix_mysql_v}/create/schema.sql"
mysql -uroot -D zabbix -p"$MYSQL_PASSWORD" < "${zabbix_mysql_v}/create/images.sql"
mysql -uroot -D zabbix -p"$MYSQL_PASSWORD" < "${zabbix_mysql_v}/create/data.sql"

# Enable Zabbix Server
update-rc.d zabbix-server enable

#Restart Zabbix Server
service  zabbix-server restart

#Restart Apache Server
service apache2 restart

#Data import needs soem time 
sleep 5

exec "$@"
