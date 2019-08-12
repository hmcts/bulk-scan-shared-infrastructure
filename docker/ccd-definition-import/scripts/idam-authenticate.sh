#!/bin/bash

IMPORTER_USERNAME=$1
IMPORTER_PASSWORD=$2
IDAM_URI=$3

curl ${CURL_OPTS} -H "Content-Type: application/x-www-form-urlencoded" -H 'Accept: application/json' -d "username=${IMPORTER_USERNAME}&password=${IMPORTER_PASSWORD}" "${IDAM_URI}/loginUser" | jq -r .access_token
