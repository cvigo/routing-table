#!/bin/bash

if (( EUID != 0 )); then
  echo "Please, run this command with sudo" 1>&2
  exit 1
fi

#These might be different in your system
WIRELESS_INTERFACE=en0
TUNNEL_INTERFACE=ppp0

#this might need to be changed in Linux
GATEWAY=$(netstat -nrf inet | grep default | grep $WIRELESS_INTERFACE | awk '{print $2}')

# Request to IPs within the following network masks are routed through the VPN interface. Add as many as you need.
DEST_NETS="192.168/16 23.4/16 22.17/16 10.48/16 10.51/16 10.111/16"

# Default router is set to use the WiFi interface
echo "Resetting routes with gateway => $GATEWAY"
echo
route -n delete default -ifscope $WIRELESS_INTERFACE
route -n delete -net default -interface $TUNNEL_INTERFACE
route -n add -net default $GATEWAY
# route -n add -net default -interface $WIRELESS_INTERFACE

for subnet in $DEST_NETS
do
  route -n add -net $subnet -interface $TUNNEL_INTERFACE
done

for DEST_NET in $DEST_NETS
do
  netstat -nr  | grep $DEST_NET
done

#setting up the name resolvers for well known domain suffix
for suffix in es com net org be co au edu biz io tv eu nz uk ie bbva gl gal nl
do
    echo 'nameserver 8.8.8.8' | tee /etc/resolver/$suffix
done

echo "Press any key to dismiss..."
read -rn1
