## Server

# Installation de nginx

echo "Installation de nginx et php"

pkg delete -y nginx
rm /usr/local/etc/nginx/nginx.conf

pkg install nginx
pkg install php72-fpm

# Initialisation de nginx

echo "Initialisation de nginx"

sysrc nginx_enable="YES"
service nginx stop
service nginx start
mkdir /var/www/YSNP
curl https://gist.githubusercontent.com/hugomassaria/c2d5271af64ce3c01221bbad55043eb7/raw/9725bedd2b35ab9137876037937e45ecd1c511c2/data.php > /var/www/YSNP/data.php
mkdir /usr/local/etc/nginx/domains/
curl https://gist.githubusercontent.com/hugomassaria/6996d95c1ef4db665123c260a089f818/raw/102ff0f19c3f813918fea86543b2bf9efd5d6e7b/data.conf > /usr/local/etc/nginx/domains/data.conf

sed '$d' /usr/local/etc/nginx/nginx.conf > /usr/local/etc/nginx/nginx.conf.temp && cat /usr/local/etc/nginx/nginx.conf.temp > /usr/local/etc/nginx/nginx.conf
rm /usr/local/etc/nginx/nginx.conf.temp
echo 'include "domains/*.conf";}' >> /usr/local/etc/nginx/nginx.conf

# Initialisation de PHP

echo "Initialisation de PHP"

# Restart services

service nginx restart
service php72-fpm restart