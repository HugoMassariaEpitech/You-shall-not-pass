## Server

# Installation de nginx

echo "Installation de nginx et php"

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
echo "server { server_name 192.168.42.70; access_log  /var/log/nginx/data.access.log; error_log  /var/log/nginx/data.error.log; root /var/www/YSNP; location ~ \.php$ { try_files $uri =404; fastcgi_pass unix:/var/run/php72-fpm.sock; fastcgi_index data.php; fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; include fastcgi_params; }}" > /usr/local/etc/nginx/domains/data.conf

sed '$d' /usr/local/etc/nginx/nginx.conf > /tmp/nginx.conf.temp && /tmp/nginx.conf.temp > /usr/local/etc/nginx/nginx.conf
rm /tmp/nginx.conf.temp
echo 'include "domains/*.conf";}' >> /usr/local/etc/nginx/nginx.conf

# Initialisation de PHP

echo "Initialisation de PHP"

# Restart services

service nginx restart
service php72-fpm restart