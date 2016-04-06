#!/bin/bash
curl -so /tmp/startup-script "https://bitbucket.org/levelupify/devops/raw/master/scripts/gcloud-post-boot.sh?cachebuster=$(date '+%Y-%m-%d-%H-%M-%N')"
chmod u+x /tmp/startup-script
/tmp/startup-script
