#!/bin/bash

# Linux-No-IP-DDNS-Update-Client
# Linux client program for update No-IP DDNS record
# https://github.com/ronald8192/Linux-No-IP-DDNS-Update-Client/
# MIT License

# ver1 - 2018-02-06

USERNAME=""
PASSWORD=""
HOSTNAME=""

dnsrecord=$(host $HOSTNAME | head -n 1 | sed "s/$HOSTNAME has address //g")
publicip=$(curl 'https://api.ipify.org')

if [ "$publicip" != "$dnsrecord" ]; then
  updateurl="https://$USERNAME:$PASSWORD@dynupdate.no-ip.com/nic/update?hostname=$HOSTNAME&myip=$publicip"
  curl -X GET $updateurl
fi
