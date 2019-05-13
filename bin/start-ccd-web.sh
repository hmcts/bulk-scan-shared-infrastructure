#!/bin/sh

command -v az >/dev/null 2>&1 || {
    echo "################################################################################################"
    echo >&2 "Please install Azure CLI - instructions in README.md"
    echo "################################################################################################"
    exit 1
}

command -v jq >/dev/null 2>&1 || {
    echo "################################################################################################"
    echo >&2 "Please install JQ CLI processor - instructions in README.md"
    echo "################################################################################################"
    exit 1
}

function show_account() {
  az account show
}

#####################################################################################
# Login to Azure
#####################################################################################

if show_account | grep -i "hmcts.net"; then
  echo "You are logged into HMCTS Azure Portal"
else
  echo "Logging into the HMCTS Azure Portal. Please check your web browser."
  az login >> /dev/null 2>&1
fi

AZURE_ACCOUNT=`show_account`
SUBSCRIPTION_ID=`echo "$AZURE_ACCOUNT" | jq -r '.id'`
SUBSCRIPTION_NAME=`echo "$AZURE_ACCOUNT" | jq -r '.name'`
ACCOUNT_EMAIL=`echo "$AZURE_ACCOUNT" | jq -r '.user.name'`

if echo "$SUBSCRIPTION_NAME" | grep -v -e "^.*CNP-DEV$"; then
  read -p "Enter DEV subscription ID: " SUBSCRIPTION_ID
fi

echo "Logging into the HMCTS Azure Container Registry"
az acr login --name hmcts --subscription ${SUBSCRIPTION_ID}

#####################################################################################
# Compose CCD Web
#####################################################################################

docker-compose -f docker-compose.yml up ${@} -d ccd-case-management-web \
                                                dm-store \
                                                ccd-api-gateway \
                                                idam-api \
                                                authentication-web \
                                                smtp-server \
                                                ccd-importer \
                                                idam-importer

# for convenience, let's have personal caseworker account

curl -XPOST \
  http://localhost:8080/testing-support/accounts \
  -H "Content-Type: application/json" \
  -d '{"email":"'${ACCOUNT_EMAIL}'","forename":"Myself","surname":"As A Caseworker","password":"password","levelOfAccess":1, "roles": ["caseworker-bulkscan","caseworker"], "userGroup": {"code": "caseworker"}}'

# in order to log in, we need user profiles present in the ccd

SERVICE_TOKEN="$($(dirname "$0")/create-service-auth-token.sh ccd_data)"

curl -XPUT \
  http://localhost:4453/user-profile/users \
  -H "Content-Type: application/json" \
  -H "ServiceAuthorization: Bearer $SERVICE_TOKEN" \
  -H "actionedBy: shell-script" \
  -d '[{"id":"'${ACCOUNT_EMAIL}'","jurisdictions":[{"id":"BULKSCAN"}],"work_basket_default_jurisdiction":"BULKSCAN","work_basket_default_case_type":"BULKSCAN_ExceptionRecord","work_basket_default_state":"ScannedRecordReceived"}]'
