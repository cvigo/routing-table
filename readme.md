# Routing table simple script
This can help if:
- You need frequent access to Internet resources
- You need access to LAN resources
- Your company uses an Internet proxy for Ethernet but not for Wi-Fi
- Yoy use MacOSX or Linux, therefore not all the SW reads proxy settings (tipycally browsers do, thinks like package managers don't)

Simply edit routing.table.sh and change these lines:
```sh
#Set here the interface name you what to use for the exceptional routes
ETH_NAME="en12"

#write here your LAN DNS Server
DNS_IP="22.0.0.1"

#Exception route list. Traffic sent to $DEST_HOSTS and $DEST_NETS will go through $ETH_NAME interface
DEST_HOSTS="10.12.13.14"
DEST_NETS="192.168.0/16 23.4/16"
#you don't need to change anything else
```
- Replace `en12` by your Ethernet interface name.
- Replace `22.0.0.1` by your LAN DNS server IP address.
- Add the IP addresses and/or CIDR Netmask you want to route through the Ethernet cable to `DEST_HOSTS` and `DEST_NETS` variables. Use space as delimiter.
- In your network preferences, make sure that Wi-Fi is before Ethernet interface in the "Service Order".

As a result, all the network traffic will go through the Wi-Fi interface excepting whatever goes to `DEST_HOSTS` and `DEST_NETS`

This script works in MacOSX Sierra. As every version of UNIX is different, it needs some adaptations to make it work in Linux distributions (`netstat` command varies, for example). **I just made the minimun I needed to solve my issue :-)**.

Feel free to use at your own risk. PRs welcome.
