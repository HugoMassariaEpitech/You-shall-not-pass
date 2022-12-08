# Installation de nginx

echo "Installation de nginx"

pkg install nginx

# Initialisation de nginx

echo "Initialisation de nginx"

sysrc nginx_enable="YES"
service nginx stop
service nginx start
mkdir /var/www/YSNP
echo ""