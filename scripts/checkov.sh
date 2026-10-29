#!/usr/bin/env bash

set -euo pipefail

SCAN_DIR="${1:-infra}"

HOST_DIR="$(pwd -W)"

MSYS_NO_PATHCONV=1 docker run --rm \
  -v "${HOST_DIR}:/repo:ro" \
  --workdir /repo \
  bridgecrew/checkov:latest \
  --directory "/repo/${SCAN_DIR}" \
  --quiet

