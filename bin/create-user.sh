#!/bin/sh

set -e

USER_EMAIL="${1:-me@server.net}"
FORENAME="${2:-John}"
SURNAME="${3:-Smith}"
PASSWORD="Password12"
USER_GROUP="${4:-bsp-systemupdate}"
USER_ROLES="${5:-[]}"

echo "Creating user $USER_EMAIL"

RESPONSE=$(curl --silent -XPOST \
  http://localhost:8080/testing-support/accounts \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "'${USER_EMAIL}'",
    "forename": "'"$FORENAME"'",
    "surname": "'"$SURNAME"'",
    "levelOfAccess": 0,
    "userGroup": {
      "code": "'${USER_GROUP}'"
    },
    "activationDate": "",
    "lastAccess": "",
    "roles": '${USER_ROLES}',
    "password": "'${PASSWORD}'"
}')

if echo "$RESPONSE" | grep "already exists"; then
  echo "" # For some reason, $RESPONSE ^ gets echoed, but in other script it did not ¯\_(ツ)_/¯
else
  echo "Created user with:"
  echo "Username: ${USER_EMAIL}"
  echo "Password: ${PASSWORD}"
  echo "Firstname: ${FORENAME}"
  echo "Surname: ${SURNAME}"
  echo "User group: ${USER_GROUP}"
  echo "Roles: ${USER_ROLES}"
fi
