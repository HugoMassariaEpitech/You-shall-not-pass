## Server

# Installation de nginx

echo "Installation de nginx et php"

pkg update
pkg upgrade -y
pkg install -y nginx php74 mysql80-server php74-mysqli mod_php74

# Initialisation de nginx

echo "Initialisation de nginx"

echo 'nginx_enable="YES"' >> /etc/rc.conf
mkdir /var/www/YSNP
curl https://gist.githubusercontent.com/hugomassaria/c2d5271af64ce3c01221bbad55043eb7/raw/9725bedd2b35ab9137876037937e45ecd1c511c2/data.php > /var/www/YSNP/data.php
mkdir /usr/local/etc/nginx/domains/
curl https://gist.githubusercontent.com/hugomassaria/6996d95c1ef4db665123c260a089f818/raw/8c14cdc11ab43b2c2221b61030aa4d02cc33daa1/data.conf > /usr/local/etc/nginx/domains/data.conf

sed '$d' /usr/local/etc/nginx/nginx.conf > /usr/local/etc/nginx/nginx.conf.temp && cat /usr/local/etc/nginx/nginx.conf.temp > /usr/local/etc/nginx/nginx.conf
rm /usr/local/etc/nginx/nginx.conf.temp
echo 'include "domains/*.conf";}' >> /usr/local/etc/nginx/nginx.conf

# Initialisation de PHP

echo "Initialisation de PHP"

echo 'php_fpm_enable="YES"' >> /etc/rc.conf
sed 's/.*listen =.*/listen = /var/run/php74-fpm.sock;/' > /usr/local/etc/php-fpm.d/www.conf.temp && cat /usr/local/etc/php-fpm.d/www.conf.temp > /usr/local/etc/php-fpm.d/www.conf
rm /usr/local/etc/php-fpm.d/www.conf.temp
sed 's/.*;listen.owner = www.*/listen.owner = www/' /usr/local/etc/php-fpm.d/www.conf > /usr/local/etc/php-fpm.d/www.conf.temp && cat /usr/local/etc/php-fpm.d/www.conf.temp > /usr/local/etc/php-fpm.d/www.conf
rm /usr/local/etc/php-fpm.d/www.conf.temp
sed 's/.*;listen.group = www.*/listen.group = www/' /usr/local/etc/php-fpm.d/www.conf > /usr/local/etc/php-fpm.d/www.conf.temp && cat /usr/local/etc/php-fpm.d/www.conf.temp > /usr/local/etc/php-fpm.d/www.conf
rm /usr/local/etc/php-fpm.d/www.conf.temp
sed 's/.*;listen.mode = 0660.*/listen.mode = 0660/' /usr/local/etc/php-fpm.d/www.conf > /usr/local/etc/php-fpm.d/www.conf.temp && cat /usr/local/etc/php-fpm.d/www.conf.temp > /usr/local/etc/php-fpm.d/www.conf
rm /usr/local/etc/php-fpm.d/www.conf.temp
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
sed 's/.*cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/' /usr/local/etc/php.ini > /usr/local/etc/php.ini.temp && cat /usr/local/etc/php.ini.temp > /usr/local/etc/php.ini
rm /usr/local/etc/php.ini.temp

# Initialisation de Mysql

echo "Initialisation de Mysql"

echo 'mysql_enable="YES"' >> /etc/rc.conf
mysql_secure_installation
mysql --user="root" --password="Azerty1234!" --execute="CREATE USER 'backend'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Bit8Q6a6G';"
mysql --user="root" --password="Azerty1234!" --execute="CREATE DATABASE nsa501;"
mysql --user="root" --password="Azerty1234!" --execute="GRANT ALL ON nsa501.* to 'backend'@'localhost';"
mysql --user="root" --password="Azerty1234!" --execute="flush privileges;"

curl https://gist.githubusercontent.com/hugomassaria/8c9e3991fb966a8d5c29a67fbf5a0fed/raw/08a9075246e54f85747154a5193f68414f3ff6b8/nsa501.sql > /root/nsa501.sql
mysql -ubackend -pBit8Q6a6G nsa501 < /root/nsa501.sql

# Restart all services

echo "Restart all services"

service nginx start
service nginx restart
service nginx status

service mysql-server start
service mysql-server restart
service mysql-server status

service php-fpm start
service php-fpm restart
service php-fpm status