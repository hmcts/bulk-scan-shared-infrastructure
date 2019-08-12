#!/bin/sh

if [[ "${1}" = "idam-importer" ]]; then
  if [[ -z "${2}" || -z "${3}" ]]; then
    echo "In order to successfully start local ccd setup please provide IDAM admin credentials"
    echo "They can be found here:\n"
    echo "    ***** https://tools.hmcts.net/confluence/display/SISM/Local+Docker+Setup *****"
    echo "\n  Re-run script \`./bin/start-specific-container.sh idam-importer username password\`\n"

    exit 1
  fi

  export IDAM_USERNAME=${2}
  export IDAM_PASSWORD=${3}
fi

docker-compose -f docker-compose.yml up -d "$@"
