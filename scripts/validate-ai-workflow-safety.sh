#!/usr/bin/env bash
set -euo pipefail

echo "Checking AI-assisted workflow safety policy..."

docker run --rm \
-v "$PWD:/work" \
-w /work \
openpolicyagent/conftest:latest \
test security/ai-agent-controls.yml \
--policy policies/rego/ai-workflow-safety.rego

echo "PASS - AI-assisted workflow safety controls satisfy policy."
