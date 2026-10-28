#!/usr/bin/env bash
set -euo pipefail

GITLEAKS_IMAGE="${GITLEAKS_IMAGE:-ghcr.io/gitleaks/gitleaks:v8.30.1}"

cd "$(dirname "$0")/.."

mkdir -p security/out

REPO_PATH="$(pwd -W)"

MSYS_NO_PATHCONV=1 docker run --rm \
  -v "$REPO_PATH:/repo:ro" \
  -v "$REPO_PATH/security/out:/out" \
  "$GITLEAKS_IMAGE" \
  git /repo \
  --redact \
  --report-format=json \
  --report-path=/out/gitleaks-report.json
