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

echo "Starting docker containers..."

docker-compose up -d

while [[ `docker ps -a | grep starting | wc -l | awk '{$1=$1};1'` != "0" ]]
do
    echo "Waiting for "`docker ps -a | grep starting | wc -l | awk '{$1=$1};1'`" container(s) to start. Sleeping for 5 seconds..."
    sleep 5
done

# for convenience, let's have personal caseworker account

BIN_DIR=$(dirname "$0")

${BIN_DIR}/create-case-worker.sh "$ACCOUNT_EMAIL" "Myself" "As A Caseworker"

# in order to log in, we need user profiles present in the ccd

${BIN_DIR}/create-ccd-user-profile.sh "$ACCOUNT_EMAIL"
