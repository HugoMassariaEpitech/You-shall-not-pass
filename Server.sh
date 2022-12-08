## Server

# Installation de nginx

echo "Installation de nginx"

pkg install nginx

# Initialisation de nginx

echo "Initialisation de nginx"

sysrc nginx_enable="YES"
service nginx stop
service nginx start
mkdir /var/www/YSNP
curl https://gist.githubusercontent.com/hugomassaria/c2d5271af64ce3c01221bbad55043eb7/raw/9725bedd2b35ab9137876037937e45ecd1c511c2/data.php > /var/www/YSNP/data.php
mkdir /usr/local/etc/nginx/domains/
echo "server { server_name 192.168.42.70; access_log  /var/log/nginx/data.access.log; error_log  /var/log/nginx/data.error.log; root /var/www/YSNP; }" > /usr/local/etc/nginx/domains/data.conf
echo 'include "domains/*.conf";' >> /usr/local/etc/nginx/nginx.conf
service nginx reload