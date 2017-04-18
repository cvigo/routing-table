#! /bin/bash

# Don't use a routing table record to the interface name (it does not work at least in MacOSX), you shoud use the default router
# sudo route add -host 22.0.0.1 -interface en12 DOES NOT WORK

#Set here the interface name you what to use for the exceptional routes
ETH_NAME="en12"
DNS_IP="22.0.0.1"
#Exception route list. Traffic sent to $DEST_HOSTS and $DEST_NETS will go through $ETH_NAME interface
DEST_HOSTS="10.12.13.14"
DEST_NETS="192.168.0/16 23.4/16"

DEST_HOSTS="$DNS_IP $DEST_HOSTS"

#Get default router for that interface
ETH_ROUTER=$(netstat -nr | grep default | grep $ETH_NAME | awk '{print $2}')

echo "Default router for $ETH_NAME is $ETH_ROUTER"
echo '----------------------'

for DEST_HOST in $DEST_HOSTS
do
  sudo route delete -host $DEST_HOST
  sudo route add -host $DEST_HOST $ETH_ROUTER
done

for DEST_NET in $DEST_NETS
do
  sudo route delete -net $DEST_NET
  sudo route add -net $DEST_NET $ETH_ROUTER
done

#adding dns
# echo
# echo "Adding $DNS_IP and 8.8.8.8 to the DNS table for Wi-Fi"
# sudo networksetup -setdnsservers Wi-Fi $DNS_IP 8.8.8.8

echo
echo 'Done.....'
echo 'Destination        Gateway            Flags        Refs      Use   Netif Expire'
for DEST_HOST in $DEST_HOSTS
do
  netstat -nr  | grep $DEST_HOST
done

for DEST_NET in $DEST_NETS
do
  netstat -nr  | grep $DEST_NET
done

echo "Press any key to dismiss..."
read -rn1