#!/usr/bin/env bash


set -e

sudo ip l add br0 type bridge
sudo ip l set up dev br0


sudo mkdir -p /etc/netns/ap0
sudo bash -c "echo \"nameserver 1.1.1.1\" > /etc/netns/ap0/resolv.conf"
sudo bash -c "echo \"nameserver 8.8.8.8\" > /etc/netns/ap0/resolv.conf"
sudo bash -c "echo \"nameserver 9.9.9.9\" > /etc/netns/ap0/resolv.conf"

sudo ip netns add ap0
sudo ip netns exec ap0 ip l set up lo
sudo ip netns exec ap0 ip link add eth0 type veth peer name vap0 
sudo ip netns exec ap0 ip l set dev vap0 netns 1
sudo ip netns exec ap0 ip l set up dev eth0


sudo ip l set up dev vap0
sudo ip l set dev vap0 master br0  

sudo ip addr add 192.168.100.1/24  brd + dev br0

sudo dnsmasq -i br0 --dhcp-range=192.168.100.2,192.168.100.200,6h --dhcp-option=6,1.1.1.1,8.8.8.8 --dhcp-authoritative --bind-interfaces  -d --dhcp-leasefile=dhcp.leases > dnsmasq.out 2>&1 & echo $! > dns.pid


sudo iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -j MASQUERADE --random
sudo iptables -A FORWARD -s 192.168.100.0/24 -o eth0 -j ACCEPT
sudo iptables -A FORWARD -m state --state ESTABLISHED,RELATED -d 192.168.100.0/24 -i eth0 -j ACCEPT

sudo ip netns exec ap0 dhclient eth0 -v

sudo ip netns exec ap0 bash
