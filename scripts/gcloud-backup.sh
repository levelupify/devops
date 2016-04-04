#!/bin/bash
set -e

# ------------- CONFIG HERE ----------------
project="levelup-hosting"
backup_dir="/local/backup"


# ------------- NO CHANGES BELOW THIS LINE ---------------
datestr=$(date "+%Y-%b-%d-%H-%M-%N")
cmd="gcloud compute --project \"#{project}\" disks snapshot"

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
rsync -a --exclude .git --exclude node_modules --exclude .npm --exclude .node-gyp /root ${backup_dir}

# Backup /etc
rsync -a /etc ${backup_dir}

# Backup crontabs
rsync -a /var/spool/cron/crontabs ${backup_dir}

# Create the actual snapshots
#{cmd} "data-l1"  --zone "europe-west1-d" --snapshot-names "data-l1--${datestr}"
#{cmd} "data-l2"  --zone "europe-west1-c" --snapshot-names "data-l2--${datestr}"
#{cmd} "local-l1" --zone "europe-west1-d" --snapshot-names "local-l1--${datestr}"
#{cmd} "local-l2" --zone "europe-west1-c" --snapshot-names "local-l2--${datestr}"