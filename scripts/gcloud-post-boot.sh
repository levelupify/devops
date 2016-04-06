#/bin/bash

mount -t glusterfs $(hostname --short):/gv0 /shared
runurl "https://bitbucket.org/levelupify/devops/raw/master/scripts/gcloud-update-dns.sh?cachebuster=$(date '+%Y-%m-%d-%H-%M-%N')"
