#!/usr/bin/env bash

set -euo pipefail

required_files=(
  "security/control-register.md"
  "security/ai-workflow-safety.md"
  "security/compliance-evidence-map.md"
  "security/compliance-evidence-map.yml"
  "scripts/evidence-bundle.sh"
)

recommended_files=(
  ".github/CODEOWNERS"
  ".github/workflows/codeql.yml"
  ".github/workflows/semgrep.yml"
  ".github/workflows/gitleaks.yml"
  ".github/workflows/osv.yml"
  ".github/workflows/dependency-review.yml"
  ".github/workflows/container-scan.yml"
  ".github/workflows/iac-scan.yml"
  "security/scanner-evaluation-scorecard.md"
  "security/secret-rotation-runbook.md"
  "security/vulnerability-sla.yml"
  "security/runtime-detection-design.md"
  "security/license-policy.yml"
  "security/cosign-design.md"
  "security/slsa-design.md"
)

fail=0

echo "# Compliance Evidence Audit"
echo

echo "## Required Evidence"

for file in "${required_files[@]}"; do
  if [[ -f "$file" ]]; then
    echo "PASS | $file"
  else
    echo "FAIL | $file"
    fail=1
  fi
done

echo

echo "## Recommended Evidence"

for file in "${recommended_files[@]}"; do
  if [[ -f "$file" ]]; then
    echo "EVIDENCE | $file"
  else
    echo "PLANNED | $file"
  fi
done

echo

if [[ "$fail" -eq 0 ]]; then
  echo "RESULT: compliance evidence map baseline is ready."
else
  echo "RESULT: required compliance evidence is missing."
fi

exit "$fail"
