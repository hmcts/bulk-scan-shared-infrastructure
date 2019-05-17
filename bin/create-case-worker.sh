#!/bin/bash

set -e

USER_EMAIL="${1:-bulkscan+ccd@gmail.com}"
FORENAME="${2:-Case}"
SURNAME="${3:-Worker}"
USER_GROUP="caseworker"
USER_ROLES='["caseworker","caseworker-bulkscan"]' # Role has to be present in idam and service related

$(dirname "$0")/create-user.sh "${USER_EMAIL}" "${FORENAME}" "${SURNAME}" "${USER_GROUP}" "${USER_ROLES}"
