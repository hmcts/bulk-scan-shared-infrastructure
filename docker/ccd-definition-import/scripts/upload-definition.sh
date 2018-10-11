#!/bin/sh
set -e

chmod +x /scripts/*.sh

# create user with ccd-import role
/scripts/create-importer-user.sh

IMPORTER_USERNAME=ccd-importer@server.net
IMPORTER_PASSWORD=Password12
IDAM_URI=http://idam-api:8080
REDIRECT_URI=http://localhost:3000/receiver
CLIENT_SECRET=123456

if [ ${VERBOSE} = "true" ]; then
  export CURL_OPTS="-v"
else
  export CURL_OPTS="--fail --silent"
fi

export BULK_SCAN_ORCHESTRATOR_BASE_URL=http://bulk-scan-orchestrator:5000 # Service does not exist as of now but will be added later

for definition in /definitions/*.xlsx
do
  echo "======== PROCESSING FILE $definition ========="

  /scripts/template_ccd_definition.py "$definition" /definition.xlsx

  userToken=$(sh ./scripts/idam-authenticate.sh ${IMPORTER_USERNAME} ${IMPORTER_PASSWORD} ${IDAM_URI} ${REDIRECT_URI} ${CLIENT_SECRET})

  # add ccd role
  /scripts/add-ccd-role.sh "caseworker-bulkscan" "PUBLIC" "${userToken}"

  # upload definition files
  /scripts/import-definition.sh /definition.xlsx "${userToken}"

  echo "======== FINISHED PROCESSING $definition ========="
  echo
done
