#!/bin/sh

BIN_FOLDER=$(dirname "$0")

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
USER_EMAIL=`echo "$AZURE_ACCOUNT" | jq -r '.user.name'`

if echo "$SUBSCRIPTION_NAME" | grep -v -e "^.*CNP-DEV$"; then
  read -p "Enter DEV subscription ID: " SUBSCRIPTION_ID
fi

echo "Logging into the HMCTS Azure Container Registry"
az acr login --name hmcts --subscription ${SUBSCRIPTION_ID}

#####################################################################################
# Compose CCD Web
#####################################################################################

echo "Starting docker containers..."

docker-compose up ${@} -d ccd-case-management-web \
                          dm-store \
                          ccd-api-gateway \
                          idam-api \
                          authentication-web \
                          smtp-server \
                          ccd-importer \
                          idam-importer

while [[ `docker ps -a | grep starting | wc -l | awk '{$1=$1};1'` != "0" ]]
do
    echo "Waiting for $(docker ps -a | grep starting | wc -l | awk '{$1=$1};1') containers to start. Sleeping for 5 seconds..."
    sleep 5
done

#####################################################################################
# Create the CCD roles
#####################################################################################

ROLES=("caseworker-sscs")

ATTEMPTS=0

for ROLE in "${ROLES[@]}"
do
  echo "Creating role $ROLE"

  USER_TOKEN=`${BIN_FOLDER}/create-user-auth-token.sh`
  SERVICE_TOKEN=`${BIN_FOLDER}/create-service-auth-token.sh "ccd_gw"`

  until ${BIN_FOLDER}/add-ccd-role.sh "$ROLE" "PUBLIC" "$USER_TOKEN" "$SERVICE_TOKEN"
  do
    echo "Failed to create role. This might be ok - trying again in 15 seconds"
    sleep 15

    ATTEMPTS=$((ATTEMPTS+1))

    if [[ ${ATTEMPTS} == 200 ]]; then
       echo "Giving up."
       exit;
    fi
  done
done

#####################################################################################
# Create a case worker with your email address
#####################################################################################

${BIN_FOLDER}/create-case-worker.sh ${USER_EMAIL}
