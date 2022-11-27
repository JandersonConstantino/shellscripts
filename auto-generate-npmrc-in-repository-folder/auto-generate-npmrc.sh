# /bin/bash

PACKAGE_JSON="${PWD}/package.json"

if ! (test -f "$PACKAGE_JSON" )
then
    exit 0;
fi

python ${AUTO_GENERATE_NPMRC_PATH}/gen-npmrc-if-necessary.py $PACKAGE_JSON $PWD
