#!/bin/bash

USERNAME=""
PASSWORD=""
HOSTNAME=""

dnsrecord=$(host $HOSTNAME | head -n 1 | sed "s/$HOSTNAME has address //g")
publicip=$(curl 'https://api.ipify.org')

if [ "$publicip" != "$dnsrecord" ]; then
  updateurl="https://$USERNAME:$PASSWORD@dynupdate.no-ip.com/nic/update?hostname=$HOSTNAME&myip=$publicip"
  curl -X GET $updateurl
fi
