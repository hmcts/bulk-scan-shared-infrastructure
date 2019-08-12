#!/bin/sh

set -e

ROLES='[{"code":"ccd-import"}]'

/scripts/create-user.sh "ccd-importer@server.net" "CCD" "Importer" "Password12" "ccd-import" "${ROLES}"

ROLES='[{"code":"caseworker-bulkscan"},{"code":"caseworker-bulkscan-systemupdate"}]'
/scripts/create-user.sh "bulkscanorchestrator+systemupdate@gmail.com" "BSP" "SystemUser" "Password12" "caseworker" "${ROLES}"
