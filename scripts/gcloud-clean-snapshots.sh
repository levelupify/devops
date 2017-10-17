#!/bin/bash
set -e

HOSTNAME_SHORT=$(hostname --short)

SNAPSHOT_LIST_LOCAL="$(gcloud compute snapshots list --regexp local-${HOSTNAME_SHORT}-.* --uri)"
SNAPSHOT_LIST_DATA="$(gcloud compute snapshots list --regexp local-${HOSTNAME_SHORT}-.* --uri)"

echo "${SNAPSHOT_LIST_LOCAL}" | while read line ; do
  
  # get the snapshot name from the uri
  SNAPSHOT_NAME=${line##*/}
  
  # get the date that the snapshot was created
  SNAPSHOT_DATETIME="$(gcloud compute snapshots describe ${SNAPSHOT_NAME} | grep "creationTimestamp" | cut -d " " -f 2 | tr -d \')"

  # format the date
  SNAPSHOT_DATETIME="$(date -d ${SNAPSHOT_DATETIME} +%Y%m%d)"

  echo "name: $SNAPSHOT_NAME Datetime: $SNAPSHOT_DATETIME"
done

# -------------- WHAT TO KEEP --------------

# First of every month
# local-l1--XXXX-XX-01-xx-XX-xxxxxxxxx
# local-l2--XXXX-XX-01-XX-XX-xxxxxxxxx
# data-l1--XXXX-XX-01-XX-XX-xxxxxxxxx
# data-l2--XXXX-XX-01-XX-XX-xxxxxxxxx

# All from the last 30 days