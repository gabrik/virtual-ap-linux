# Virtual Access Point


This repository contains some helper script and configuration for creating a Virtual Access Point.

It leverages Linux Networking namespaces, dnsmasq and hostapd


### Usage


Configure your SSID and WPA passkey in `ap.conf` then start the Access Point using `create_ap.sh` and stop it using `destroy_ap.sh`


### TODOs

- Take WAN interface and WLAN interface as parameters
- Rename WLAN interface when moving into namespace to `wlan0`
- Add basic WebUI with information like: dhcp leases, wifi strenght
- Make DHCP and DNS Configurable