#!/bin/bash

hash xrunurl 2>/dev/null || { 
  sudo add-apt-repository ppa:alestic/ppa -yy
  sudo apt-get update -qq
  sudo apt-get install -yy runurl
}

mount -t glusterfs $(hostname --short):/gv0 /shared
runurl "https://bitbucket.org/levelupify/devops/raw/master/scripts/gcloud-update-dns.sh?cachebuster=$(date '+%Y-%m-%d-%H-%M-%N')"
