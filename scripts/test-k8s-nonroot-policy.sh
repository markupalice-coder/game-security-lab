#!/usr/bin/env bash
set -euo pipefail

POLICY_DIR="policies/rego"
NAMESPACE="k8s.security"
PASS_FIXTURE="policies/fixtures/k8s-nonroot-pass.yaml"
FAIL_FIXTURE="policies/fixtures/k8s-nonroot-fail.yaml"

MOUNT_DIR="$(pwd)"
case "$(uname -s)" in
  MINGW*|MSYS*)
    MOUNT_DIR="$(pwd -W)"
    ;;
esac

echo "Testing compliant Kubernetes fixture..."

MSYS_NO_PATHCONV=1 docker run --rm \
  -v "$MOUNT_DIR:/work" \
  -w /work \
  openpolicyagent/conftest:latest \
  test "$PASS_FIXTURE" \
  --policy "$POLICY_DIR" \
  --namespace "$NAMESPACE"

echo "Testing intentionally unsafe Kubernetes fixture..."

if MSYS_NO_PATHCONV=1 docker run --rm \
  -v "$MOUNT_DIR:/work" \
  -w /work \
  openpolicyagent/conftest:latest \
  test "$FAIL_FIXTURE" \
  --policy "$POLICY_DIR" \
  --namespace "$NAMESPACE"; then
  echo "ERROR: unsafe fixture passed, but it should have failed."
  exit 1
else
  echo "Expected denial observed for unsafe fixture."
fi

echo "Kubernetes non-root policy behaves correctly."
