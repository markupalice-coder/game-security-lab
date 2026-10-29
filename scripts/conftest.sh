
#!/usr/bin/env bash
set -euo pipefail

CONFTEST_IMAGE="${CONFTEST_IMAGE:-${CONFTST_IMAGE:-openpolicyagent/conftest:v0.68.2}}"
TARGET_FILE="${1:-${PASSING_FIXTURE:-policies/fixtures/service-with-tag.json}}"
POLICY_DIR="${2:-${POLICY_DIR:-policies/rego}}"

echo "Running Conftest"
echo "Image: ${CONFTEST_IMAGE}"
echo "Target: ${TARGET_FILE}"
echo "Policy directory: ${POLICY_DIR}"

docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  "$CONFTEST_IMAGE" \
  test \
  --policy "$POLICY_DIR" \
  --namespace gaming.tags \
  "$TARGET_FILE"
