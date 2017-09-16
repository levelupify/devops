#!/bin/bash

hash runurl 2>/dev/null || { 
  sudo add-apt-repository ppa:alestic/ppa -yy
  sudo apt-get update -qq
  sudo apt-get install -yy runurl
}

mount -t glusterfs $(hostname --short):/gv0 /shared
runurl "https://raw.githubusercontent.com/levelupify/devops/master/scripts/gcloud-update-dns.sh?cachebuster=$(date '+%Y-%m-%d-%H-%M-%N')"

/etc/init.d/nginx restart
