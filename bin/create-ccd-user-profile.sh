#!/bin/bash

set -e

USER_EMAIL="${1:-bulkscan+ccd@gmail.com}"

SERVICE_TOKEN="$($(dirname "$0")/create-service-auth-token.sh ccd_data)"

curl -XPUT \
  http://localhost:4453/user-profile/users \
  -H "Content-Type: application/json" \
  -H "ServiceAuthorization: Bearer $SERVICE_TOKEN" \
  -H "actionedBy: shell-script" \
  -d '[{"id":"'${USER_EMAIL}'","jurisdictions":[{"id":"BULKSCAN"}],"work_basket_default_jurisdiction":"BULKSCAN","work_basket_default_case_type":"BULKSCAN_ExceptionRecord","work_basket_default_state":"ScannedRecordReceived"}]'
