#!/usr/bin/env bash
set -euo pipefail

CONFTEST_IMAGE="${CONFTEST_IMAGE:-openpolicyagent/conftest:v0.68.2}"
POLICY_DIR="${POLICY_DIR:-policies/rego}"
FAILING_FIXTURE="${FAILING_FIXTURE:-policies/fixtures/service-missing-tag.json}"
EXPECTED_MESSAGE="service must include environment tag"

set +e
OUTPUT="$(docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  "$CONFTEST_IMAGE" \
  test \
  --policy "$POLICY_DIR" \
  --namespace gaming.tags \
  "$FAILING_FIXTURE" 2>&1)"
STATUS="$?"
set -e

printf '%s\n' "$OUTPUT"

if [ "$STATUS" -eq 0 ]; then
  echo "Policy regression: failing fixture unexpectedly passed." >&2
  exit 1
fi

if ! printf '%s\n' "$OUTPUT" | grep -q "$EXPECTED_MESSAGE"; then
  echo "Policy regression: expected denial message was not found." >&2
  exit 1
fi

echo "Negative control passed: non-compliant fixture was blocked."
