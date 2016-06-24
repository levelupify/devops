#!/bin/bash
set -e

capfile="/tmp/capfile-$(date '+%Y-%m-%d-%H-%M-%N')"
curl -so "${capfile}" "https://raw.githubusercontent.com/levelupify/devops/master/data_files/capfile?cachebuster=$(date '+%Y-%m-%d-%H-%M-%N')"
cap -f "${capfile}" $1
rm "${capfile}"
