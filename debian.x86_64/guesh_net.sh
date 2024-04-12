ip a add 172.20.10.10/16 dev ens3
ip l set ens3 up
ip r add 172.20.0.1 dev ens3
ip r add default via 172.20.0.1
