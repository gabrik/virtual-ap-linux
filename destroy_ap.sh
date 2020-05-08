#!/usr/bin/env bash

#set -e


sudo kill -2 $(cat dhcp.pid)
sudo kill -2 $(cat dhcp_wlan.pid)
sudo kill -2 $(cat hostapd.pid)

sudo rm -rf dhcp.pid
sudo rm -rf dhcp_wlan.pid
sudo rm -rf hostapd.pid

sudo ip netns exec ap0 iw phy phy0 set netns 1

sudo iptables -t nat -D POSTROUTING -s 192.168.100.0/24  -j MASQUERADE --random

sudo iptables -D FORWARD -s 192.168.100.0/24 -o eth0 -j ACCEPT
sudo iptables -D FORWARD -m state --state ESTABLISHED,RELATED -d 192.168.100.0/24 -i eth0 -j ACCEPT

sudo ip l del vap0
sudo ip netns del ap0
sudo ip l del br0


sudo rm -rf /etc/netns/ap0



