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

if echo "$SUBSCRIPTION_NAME" | grep -v -e "^.*CNP-DEV$"; then
  read -p "Enter DEV subscription ID: " SUBSCRIPTION_ID
fi

echo "Logging into the HMCTS Azure Container Registry"
az acr login --name hmcts --subscription ${SUBSCRIPTION_ID}

#####################################################################################
# Compose CCD Web
#####################################################################################

COMPOSE_FILES="-f docker-compose.yml"
docker-compose ${COMPOSE_FILES} up ${@} -d ccd-case-management-web \
                                           dm-store \
                                           ccd-api-gateway \
                                           idam-api \
                                           authentication-web \
                                           smtp-server \
                                           ccd-importer \
                                           idam-importer
