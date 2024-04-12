#systemctl stop dnsmasq
ip link add name br0 type bridge
ip addr add 172.20.0.1/16 dev br0
ip link set br0 up
echo 'br0 done'
dnsmasq --interface=br0 --bind-interfaces --dhcp-range=172.20.0.2,172.20.255.254
echo 'dnsmasq done'

ip tuntap add dev tap0 mode tap user "lukasz"
ip link set tap0 up promisc on
ip link set tap0 master br0
echo 'tap0 done'

iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i tap0 -o wlan0 -j ACCEPT
echo 'iptables done'

ip link set tap0 up
echo 'tap0 up'
