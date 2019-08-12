#!/bin/sh

set -e

USER_EMAIL="bulkscan+ccd@gmail.com"
FORENAME=BulkScan
SURNAME=CaseWorker
PASSWORD=Password12
USER_GROUP="caseworker"
USER_ROLES='[{"code":"caseworker-bulkscan"}]'

/scripts/create-user.sh "${USER_EMAIL}" "${FORENAME}" "${SURNAME}" "${PASSWORD}" "${USER_GROUP}" "${USER_ROLES}"
