## Gateway

# Configurer les interfaces réseaux

echo "Configuration des interfaces réseaux"

echo "inet 192.168.42.64 255.255.255.0 NONE" > /etc/hostname.em1
ifconfig em1 inet 192.168.42.64 255.255.255.0

echo "inet 192.168.42.128 255.255.255.0 NONE" > /etc/hostname.em2
ifconfig em2 inet 192.168.42.128 255.255.255.0

echo "inet autoconf" > /etc/hostname.em0
ifconfig em0 inet autoconf

sh /etc/netstart

# Activer le transfert d'IP afin que les paquets puissent voyager entre les interfaces réseaux 

echo "Activation du transfert d'IP"

echo "net.inet.ip.forwarding=1" >> /etc/sysctl.conf
sysctl net.inet.ip.forwarding=1

# Configuration de la redirection de traffic

echo "pass in on { em1 em2 } inet" > /etc/pf.conf

pfctl -f /etc/pf.conf

# Configuration du DHCP

echo "Configuration du DHCP"

echo "option  domain-name-servers 8.8.8.8;
subnet 192.168.42.0 netmask 255.255.255.192 {
    option routers 192.168.42.1;
    option domain-name-servers 192.168.42.1, 8.8.8.8;
    range 192.168.42.40 192.168.42.60;
}

subnet 192.168.42.64 netmask 255.255.255.192 {
    option routers 192.168.42.65;
    option domain-name-servers 192.168.42.65, 8.8.8.8;
    range 192.168.42.70 192.168.42.110;
    host server {
        hardware ethernet 08:00:27:F9:79:CB;
        fixed-address 192.168.42.70;
    }
}

subnet 192.168.42.128 netmask 255.255.255.192 {
    option routers 192.168.42.129;
    option domain-name-servers 192.168.42.128, 8.8.8.8;
    range 192.168.42.140 192.168.42.180;
}" > /etc/dhcpd.conf

echo "dhcpd_flags=em1 em2 em3" > /etc/rc.conf.local

rcctl enable dhcpd
rcctl stop dhcpd
rcctl start dhcpd