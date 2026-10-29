#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${1:-policies/fixtures/service-missing-tag.json}"
POLICY_DIR="${2:-policies/rego}"
QUERY="${3:-data.gaming.tags.deny}"

MSYS_NO_PATHCONV=1 docker run --rm \
-v "$(pwd -W):/work" \
-w /work \
openpolicyagent/opa:latest \
eval \
--format pretty \
-i "$INPUT_FILE" \
-d "$POLICY_DIR" \
"$QUERY"
