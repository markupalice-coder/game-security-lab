#!/usr/bin/env bash
set -euo pipefail

SCAN_DIR="${1:-infra}"
HOST_DIR="$PWD"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    HOST_DIR="$(pwd -W)"
    ;;
esac

MSYS_NO_PATHCONV=1 docker run --rm \
  -v "${HOST_DIR}:/repo:ro" \
  --workdir /repo \
  bridgecrew/checkov:latest \
  --directory "/repo/${SCAN_DIR}" \
  --quiet
