#!/bin/sh

if [[ -z "${1}" || -z "${2}" ]]; then
  echo "In order to successfully start local ccd setup please provide IDAM admin credentials"
  echo "They can be found here:\n"
  echo "    ***** https://tools.hmcts.net/confluence/display/SISM/Local+Docker+Setup *****"
  echo "\n  Re-run script \`./bin/start-ccd-web.sh username password\`\n"

  exit 1
fi

export IDAM_USERNAME=${1}
export IDAM_PASSWORD=${2}

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

DEV_ACCOUNT=`az account list | jq -r 'map(select(.name | match("^.*CNP-DEV$"))) | .[0]?'`

if [[ -z "$DEV_ACCOUNT" ]]; then
  AZURE_ACCOUNT=`show_account`
else
  AZURE_ACCOUNT=${DEV_ACCOUNT}
fi

SUBSCRIPTION_ID=`echo "$AZURE_ACCOUNT" | jq -r '.id'`
SUBSCRIPTION_NAME=`echo "$AZURE_ACCOUNT" | jq -r '.name'`
ACCOUNT_EMAIL=`echo "$AZURE_ACCOUNT" | jq -r '.user.name'`

# perhaps not needed, need to test with other subscription present
#if echo "$SUBSCRIPTION_NAME" | grep -v -e "^.*CNP-DEV$"; then
#  read -p "Enter DEV subscription ID: " SUBSCRIPTION_ID
#fi

echo "Logging into the HMCTS Azure Container Registry"
az acr login --name hmctsprivate --subscription ${SUBSCRIPTION_ID}

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
