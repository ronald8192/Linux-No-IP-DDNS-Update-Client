#!/bin/bash

# Linux-No-IP-DDNS-Update-Client
# Linux client program for update No-IP DDNS record
# https://github.com/ronald8192/Linux-No-IP-DDNS-Update-Client/
# MIT License

# ver1.1 - 2018-02-08

if [ -z $NOIPUSER ] || [ -z $PASSWORD ] || [ -z $HOSTNAME ]; then
  echo "No-IP username/password/hostname not definded"
  echo 'Please defind `USERNAME`, `PASSWORD` and `HOSTNAME` in your shell rc file:'
  echo ''
  echo '######### No-IP Update Client #########'
  echo '  export NOIPUSER="YOUR_NOIP_USER"'
  echo '  export PASSWORD="YOUR_PASSWORD"'
  echo '  export HOSTNAME="YOUR_HOSTNAME"'
  exit 1
fi

currentdns=$(host $HOSTNAME | head -n 1 | sed "s/$HOSTNAME has address //g")
publicip=$(curl 'https://api.ipify.org')
updatestatus="0"
if [ "$publicip" != "$currentdns" ]; then
  updateurl="https://$NOIPUSER:$PASSWORD@dynupdate.no-ip.com/nic/update?hostname=$HOSTNAME&myip=$publicip"
  updatestatus=$(curl -X GET $updateurl)

  if [[ "$updatestatus" == good* ]]; then
    newip=$(echo $updatestatus | cut -d " " -f 2)
    echo "DNS hostname update successful: $newip"
    exit 0
  elif [[ "$updatestatus" == nochg* ]]; then
    currentip=$(echo $updatestatus | cut -d " " -f 2)
    echo "IP address is current, no update performed ($newip)"
    exit 0
  elif [ "$updatestatus" == "nohost" ]; then
    echo "Hostname supplied does not exist under specified account, please check your login credentials."
    exit 1
  elif [ "$updatestatus" == "badauth" ]; then
    echo "Invalid username password combination"
    exit 1
  elif [ "$updatestatus" == "badagent" ]; then
    echo "Client disabled. Client should exit and not perform any more updates without user intervention."
    exit 1
  elif [ "$updatestatus" == "!donator" ]; then
    echo "An update request was sent including a feature that is not available to your user, such as offline options."
    exit 1
  elif [ "$updatestatus" == "abuse" ]; then
    echo "Username is blocked due to abuse. Either for not following our update specifications or disabled due to violation of the No-IP terms of service. Our terms of service can be viewed at https://www.noip.com/legal/tos . Client should stop sending updates."
    exit 1
  elif [ "$updatestatus" == "911" ]; then
    echo "A fatal error on our side such as a database outage. Retry the update no sooner than 30 minutes."
    exit 0
  else
    echo "Unexpected error: $updatestatus"
    exit 1
  fi
else
  echo "No change: $publicip"
fi

