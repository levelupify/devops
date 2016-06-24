#!/bin/bash
set -e

capfile="/tmp/capfile-$(date '+%Y-%m-%d-%H-%M-%N')"
curl -so "${capfile}" "https://github.com/levelupify/devops/raw/master/data_files/capfile?cachebuster=$(date '+%Y-%m-%d-%H-%M-%N')"
cap -f "${capfile}" $1
rm "${capfile}"
