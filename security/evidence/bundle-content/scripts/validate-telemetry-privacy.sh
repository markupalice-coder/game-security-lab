#!/usr/bin/env bash
set -euo pipefail

POLICY_DIR="policies/rego"
VALID_RULES="security/telemetry-privacy-rules.yml"
REJECTED_FIXTURE="security/privacy-policy-tests/rejected-raw-chat-policy.yml"
CONFTEST_IMAGE="openpolicyagent/conftest:latest"

echo "Checking approved telemetry privacy rules..."

docker run --rm -v "$PWD:/project" -w /project "$CONFTEST_IMAGE" test "$VALID_RULES" --policy "$POLICY_DIR"

echo "Checking that unsafe telemetry fixture is rejected..."

if docker run --rm -v "$PWD:/project" -w /project "$CONFTEST_IMAGE" test "$REJECTED_FIXTURE" --policy "$POLICY_DIR"; then
    echo "ERROR: Unsafe telemetry fixture unexpectedly passed."
    exit 1
else
    echo "Expected failure confirmed: unsafe telemetry fixture was rejected."
fi

echo "Telemetry privacy validation completed."
