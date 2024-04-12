#!/bin/bash
ip link set br0 down
brctl delbr br0
ip link delete tap0
#systemctl stop dnsmasq
killall dnsmasq
ss -lp "sport = :domain"
