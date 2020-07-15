#!/bin/bash

if [[ $# != 1 ]]; then
  echo "Usage: $(basename ${0}) <devhub instance URL>"
  exit 1
fi

DEVHUB_INSTANCE_URL="$1"
VERSION_A=7.63.0
VERSION_B=7.65.3

npm config set progress=false

run() {
  local VERSION=$1

  echo ""
  echo "--------------------------------"
  echo "Running for sfdx-cli@$VERSION"
  echo "--------------------------------"
  echo ""

  echo "* Installing sfdx-cli@$VERSION npm package"
  npm install --no-audit --no-package-lock sfdx-cli@$VERSION 2>&1 > log.txt

  echo "* Log in to $DEVHUB_INSTANCE_URL dev hub"
  npx sfdx force:auth:web:login \
    --setdefaultdevhubusername \
    --instanceurl "$DEVHUB_INSTANCE_URL" 2>&1 >> log.txt

  echo "* Creating scratch org"
  npx sfdx force:org:create \
    --setdefaultusername \
    --durationdays 1 \
    --setalias "sfdx-cli@$VERSION" \
    edition=Developer 2>&1 >> log.txt

  echo "* Pushing source code"
  npx sfdx force:source:push
}

run $VERSION_A
run $VERSION_B
