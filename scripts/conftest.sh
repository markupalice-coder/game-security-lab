#!/usr/bin/env bash
set -euo pipefail

CONFTEST_IMAGE="${CONFTEST_IMAGE:-openpolicyagent/conftest:v0.68.2}"
POLICY_DIR="${POLICY_DIR:-policies/rego}"
PASSING_FIXTURE="${PASSING_FIXTURE:-policies/fixtures/service-with-tag.json}"

docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  "$CONFTEST_IMAGE" \
  test \
  --policy "$POLICY_DIR" \
  --namespace gaming.tags \
  "$PASSING_FIXTURE"
