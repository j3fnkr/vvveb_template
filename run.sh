#!/usr/bin/env bash

set -euo pipefail

(
  export $(grep -v '^#' .env | xargs)
  envsubst < ./conf/Caddyfile.template > ./conf/Caddyfile
)

docker compose up -d
