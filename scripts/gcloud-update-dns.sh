#/bin/bash
set -e

zone="levelup-host"
domain="levelup.host"
name="$(curl -sH 'Metadata-Flavor: Google' 'http://metadata/computeMetadata/v1/instance/hostname' | awk -F  "." '{print $1}')"
ip="$(curl -sH 'Metadata-Flavor: Google' 'http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip')"
fullname="${name}.${domain}."

current="$(gcloud dns record-sets --zone="${zone}" list --name="${fullname}" 2> /dev/null)"
current_ip_row="$(echo "${current}" | grep "${fullname}" || true)"
current_ip="$(echo ${current_ip_row} | awk '{print $4}')"
current_ttl="$(echo ${current_ip_row} | awk '{print $3}')"

(gcloud dns record-sets -z=${zone} transaction abort || true) 2> /dev/null
gcloud dns record-sets -z=${zone} transaction start
if [ "${current_ip}x" != "x" ]
then
  gcloud dns record-sets -z=${zone} transaction remove --name="${fullname}" --ttl="${current_ttl}" --type=A "${current_ip}"
fi
gcloud dns record-sets -z=${zone} transaction add --name="${fullname}" --type=A --ttl=60 "${ip}"
gcloud dns record-sets -z=${zone} transaction execute
