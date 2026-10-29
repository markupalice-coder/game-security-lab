#!/usr/bin/env bash
set -euo pipefail

CONFTST_IMAGE="${CONFTST_IMAGE:-openpolicyagent/conftest:v0.68.2}"
TARGET_FILE="${1:-policies/fixtures/service-missing-tag.json}"
POLICY_DIR="${2:-policies/rego}"

echo "Running Conftest"
echo "Image: ${CONFTST_IMAGE}"
echo "Target: ${TARGET_FILE}"
echo "Policy directory: ${POLICY_DIR}"

docker run --rm \
-v "$PWD:/work" \
-w /work \
"${CONFTST_IMAGE}" \
test "${TARGET_FILE}" \
--policy "${POLICY_DIR}" \
--all-namespaces
