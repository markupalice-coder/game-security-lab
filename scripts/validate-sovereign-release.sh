#!/usr/bin/env bash

set -euo pipefail

CHECKLIST_PATH="${1:-security/sovereign-release-checklist.yml}"
POLICY_PATH="${2:-policies/rego}"

MSYS_NO_PATHCONV=1 docker run --rm \
    -v "$PWD:/project" \
    -w /project \
    openpolicyagent/conftest:latest \
    test "$CHECKLIST_PATH" \
    -p "$POLICY_PATH"

