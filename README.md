# Linux No-IP DDNS Update Client
Linux client program for update No-IP DDNS record

* Install
  * wget `https://raw.githubusercontent.com/ronald8192/Linux-No-IP-DDNS-Update-Client/master/noip-dns-update.sh`
  * Defind `USERNAME`, `PASSWORD` and `HOSTNAME` in shell rc file:
      ```
      ######### No-IP Update Client #########
      export NOIPUSER="YOUR_NOIP_USER"
      export PASSWORD="YOUR_PASSWORD"
      export HOSTNAME="YOUR_HOSTNAME"
* Usage:
  * Add cron job: `*/5 * * * * bash /path/to/noip-dns-update.sh` (Run every 5 minutes)
