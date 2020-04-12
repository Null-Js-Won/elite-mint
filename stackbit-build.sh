#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5e926d0d2550a600192dca1a/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e926d0d2550a600192dca1a 
fi
curl -s -X POST https://api.stackbit.com/project/5e926d0d2550a600192dca1a/webhook/build/ssgbuild > /dev/null
npm run build
./inject-netlify-identity-widget.js dist
curl -s -X POST https://api.stackbit.com/project/5e926d0d2550a600192dca1a/webhook/build/publish > /dev/null
