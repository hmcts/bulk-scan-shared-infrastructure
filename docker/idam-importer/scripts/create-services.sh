#!/bin/sh

set -e

# BSP
/scripts/create-service.sh "BSP" "true" "bulk_scan_orchestrator" "123456" "[\"https://localhost:3000/receiver\"]" "[\"caseworker\",\"caseworker-bulkscan\",\"caseworker-bulkscan-systemupdate\"]"

# # CCD
/scripts/create-service.sh "CCDGateway" "false" "ccd_gateway" "123456" "[\"http://localhost:3451/oauth2redirect\"]" "[\"caseworker\",\"caseworker-bulkscan\"]"
