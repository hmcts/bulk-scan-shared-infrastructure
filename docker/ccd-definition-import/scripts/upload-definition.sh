#!/bin/sh
set -e

chmod +x /scripts/*.sh

CREATE_IMPORTER_USER=yes
IMPORTER_USERNAME=ccd-importer@server.net
IMPORTER_PASSWORD=Password12
IDAM_URI=http://idam-api:8080
REDIRECT_URI=http://localhost:3000/receiver
CLIENT_ID=bsp
CLIENT_SECRET=123456
CCD_ROLE=caseworker-bulkscan
BULK_SCAN_ORCHESTRATOR_BASE_URL=http://host.docker.internal:8582


if [ ${VERBOSE} = "true" ]; then
  export CURL_OPTS="-v"
else
  export CURL_OPTS="--fail --silent"
fi

[ "_${CREATE_IMPORTER_USER}" = "_yes" ] && /scripts/create-importer-user.sh ${IMPORTER_USERNAME} ${IMPORTER_PASSWORD}

userToken=$(sh ./scripts/idam-authenticate.sh ${IMPORTER_USERNAME} ${IMPORTER_PASSWORD} ${IDAM_URI} ${REDIRECT_URI} ${CLIENT_ID} ${CLIENT_SECRET})

# add ccd role
/scripts/add-ccd-role.sh "${CCD_ROLE}" "PUBLIC" "${userToken}"

for definition in /definitions/C*.xlsx # use C to not process excel temp files that start with ~
do
  echo "======== PROCESSING FILE $definition ========="

  /scripts/template_ccd_definition.py "$definition" /definition.xlsx "${BULK_SCAN_ORCHESTRATOR_BASE_URL}"

  # upload definition files
  /scripts/import-definition.sh /definition.xlsx "${userToken}"

  echo "======== FINISHED PROCESSING $definition ========="
  echo
done
