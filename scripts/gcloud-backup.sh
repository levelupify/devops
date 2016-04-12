#!/bin/bash
set -e

# ------------- CONFIG HERE ----------------
project="levelup-hosting"
backup_dir="/local/backup"


# ------------- NO CHANGES BELOW THIS LINE ---------------
datestr=$(date "+%Y-%m-%d-%H-%M-%N")
cmd="gcloud compute disks snapshot"
zone=$(curl -sH 'Metadata-Flavor: Google' 'http://metadata/computeMetadata/v1/instance/zone' | ruby -e 'puts gets.split("/").last')

hostname_short=$(hostname --short)

orig_dir=$(pwd)

cd ${backup_dir}

mkdir -p ${backup_dir}/db

# Backup MySQL
mysqldump --all-databases > ${backup_dir}/db/mysql--${datestr}.sql

# Backup Postgres
pgfile="${backup_dir}/db/postgres--${datestr}.sql"
touch "${pgfile}"
chown postgres:postgres "${pgfile}"
su postgres -c "pg_dumpall > ${pgfile}"
chown root:root "${pgfile}"

# Backup home dirs
rsync -a --exclude .git --exclude node_modules --exclude .npm --exclude .node-gyp --exclude data /home ${backup_dir}

# Backup /root
rsync -a --exclude .git --exclude node_modules --exclude .npm --exclude .node-gyp --exclude from-hetzner /root ${backup_dir}

# Backup /etc
rsync -a /etc ${backup_dir}

# Backup crontabs
rsync -a /var/spool/cron/crontabs ${backup_dir}

cd ${orig_dir}

# Make the databases as consistent as possible
su postgres -c "echo 'CHECKPOINT;' | psql"

# Create the actual snapshots
sync
/sbin/fsfreeze -f /mnt/data1
${cmd} "data-${hostname_short}"  --zone "${zone}" --snapshot-names "data-${hostname_short}--${datestr}"
/sbin/fsfreeze -u /mnt/data1
sync
/sbin/fsfreeze -f /local
${cmd} "local-${hostname_short}"  --zone "${zone}" --snapshot-names "local-${hostname_short}--${datestr}"
/sbin/fsfreeze -u /local
