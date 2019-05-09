#!/bin/sh
## Add user role in ccd
##
## Usage: ./add-ccd-role.sh role classification userToken
##
## Options:
##    - role: Name of the role. Must be an existing IDAM role.
##    - classification: Classification granted to the role;
#          one of `PUBLIC`, `PRIVATE` or `RESTRICTED`. Default to `PUBLIC`.
##    - userToken: IDAM user auth token
##    - serviceToken: IDAM service auth token
##
## Add support for an IDAM role in CCD.

role=$1
classification=$2
userToken=$3
serviceToken=$4

if [[ "$#" -ne 4 ]]
  then
    echo "Usage: ./add-ccd-role.sh role classification userToken serviceToken"
    exit 1
fi

case ${classification} in
  PUBLIC|PRIVATE|RESTRICTED)
    ;;
  *)
    echo "Classification must be one of: PUBLIC, PRIVATE or RESTRICTED"
    exit 1 ;;
esac

curl ${CURL_OPTS} -XPUT \
  http://localhost:3453/api/user-role \
  -H "Authorization: Bearer ${userToken}" \
  -H "ServiceAuthorization: Bearer ${serviceToken}" \
  -H "Content-Type: application/json" \
  -d '{"role":"'${role}'","security_classification":"'${classification}'"}'
