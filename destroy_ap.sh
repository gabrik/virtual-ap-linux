#!/usr/bin/env bash

#set -e

sudo kill -2 $(cat dns.pid)

rm dns.pid


sudo iptables -t nat -D POSTROUTING -s 192.168.100.0/24  -j MASQUERADE --random

sudo iptables -D FORWARD -s 192.168.100.0/24 -o eth0 -j ACCEPT
sudo iptables -D FORWARD -m state --state ESTABLISHED,RELATED -d 192.168.100.0/24 -i eth0 -j ACCEPT

sudo ip l del vap0
sudo ip netns del ap0
sudo ip l del br0


sudo rm -rf /etc/netns/ap0



