#!/bin/bash
set -e

HOSTNAME_SHORT=$(hostname --short)

# Get a list of all discs with prefix "local-"
SNAPSHOT_LIST_LOCAL="$(gcloud compute snapshots list --regexp local-${HOSTNAME_SHORT}-.* --uri)"

#Get a list of all discs with prefix "data-"
SNAPSHOT_LIST_DATA="$(gcloud compute snapshots list --regexp data-${HOSTNAME_SHORT}-.* --uri)"

# loop trough local list
echo "${SNAPSHOT_LIST_LOCAL}" | while read line ; do
  
  # get the snapshot name from the uri
  SNAPSHOT_NAME=${line##*/}
  
  # get the date that the snapshot was created
  SNAPSHOT_DATETIME="$(gcloud compute snapshots describe ${SNAPSHOT_NAME} | grep "creationTimestamp" | cut -d " " -f 2 | tr -d \')"

  # format the date
  SNAPSHOT_DATETIME="$(date -d ${SNAPSHOT_DATETIME} +%Y%m%d)"

  #echo "name: $SNAPSHOT_NAME Datetime: $SNAPSHOT_DATETIME"

  # Get date to delete from
  SNAPSHOT_EXPIRY="$(date -d "-30 days" +"%Y%m%d")"

  # Make sure it's older than 30 days
  if [ $SNAPSHOT_EXPIRY -ge $SNAPSHOT_DATETIME ];
    then
    # Make sure its not first day in month
    if [ $(date -d $SNAPSHOT_DATETIME +%d) != "01" ]
      then
      #Delete snapshot
      echo "$(gcloud compute snapshots delete ${SNAPSHOT_NAME} --quiet)"
    fi
  fi
done

# loop trough data list
echo "${SNAPSHOT_LIST_DATA}" | while read line ; do
  
  # get the snapshot name from the uri
  SNAPSHOT_NAME=${line##*/}
  
  # get the date that the snapshot was created
  SNAPSHOT_DATETIME="$(gcloud compute snapshots describe ${SNAPSHOT_NAME} | grep "creationTimestamp" | cut -d " " -f 2 | tr -d \')"

  # format the date
  SNAPSHOT_DATETIME="$(date -d ${SNAPSHOT_DATETIME} +%Y%m%d)"

  #echo "name: $SNAPSHOT_NAME Datetime: $SNAPSHOT_DATETIME"

  # Get date to delete from
  SNAPSHOT_EXPIRY="$(date -d "-30 days" +"%Y%m%d")"

  # Make sure it's older than 30 days
  if [ $SNAPSHOT_EXPIRY -ge $SNAPSHOT_DATETIME ];
    then
    # Make sure its not first day in month
    if [ $(date -d $SNAPSHOT_DATETIME +%d) != "01" ]
      then
      # Delete snapshot
      echo "$(gcloud compute snapshots delete ${SNAPSHOT_NAME} --quiet)"
    fi
  fi
done
