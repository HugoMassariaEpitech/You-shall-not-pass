## Gateway

# Configurer les interfaces réseaux

echo "Configuration des interfaces réseaux"

echo "dhcp" > /etc/hostname.em0
echo "inet 192.168.42.65 255.255.255.192 192.168.42.127" > /etc/hostname.em1
echo "inet 192.168.42.129 255.255.255.192 192.168.42.191" > /etc/hostname.em2

sh /etc/netstart

# Activer le transfert d'IP afin que les paquets puissent voyager entre les interfaces réseaux 

echo "Activation du transfert d'IP"

echo "net.inet.ip.forwarding=1" > /etc/sysctl.conf
sysctl net.inet.ip.forwarding=1

# Configuration de la redirection de traffic

echo "administration = "em1"
server = "em2"
employee = "em3"



table <martians> { 0.0.0.0/8 192.168.42.0/26 192.168.42.64/26 192.168.42.128/26 }
set block-policy drop
set loginterface egress
set skip on lo
match in all scrub (no-df random-id max-mss 1440)
match out on egress inet from !(egress:network) to any nat-to (egress:0)



antispoof quick for { egress $administration }
antispoof quick for { egress $server }
antispoof quick for { egress $employee }



block in quick on egress from <martians> to any
block return out quick on egress from any to <martians>



block all



pass out quick inet keep state



#Administration reach all server into the network server on all ports
pass in on { $administration } all
pass out on { $administration } all



#Employee Administration and Server go out internet, ping devices on another subnet
pass in on { $administration } inet
pass in on { $server } inet
pass in on { $employee } inet



#Employee reach only http and https protocol and block ssh
pass in on { $employee } proto tcp to port {80 443}
pass out on { $employee } proto { tcp udp } to port {80 443}
block in on { $employee } proto tcp to port 22
block out on { $employee } proto tcp to port 22" > /etc/pf.conf

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