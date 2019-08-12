#!/bin/sh
set -e

chmod +x /scripts/*.sh

if [ ${VERBOSE} = "true" ]; then
  export CURL_OPTS="-v"
else
  export CURL_OPTS="--fail --silent"
fi

userToken=$(sh /scripts/idam-authenticate.sh ${IMPORTER_USERNAME} ${IMPORTER_PASSWORD} ${IDAM_URI})

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
