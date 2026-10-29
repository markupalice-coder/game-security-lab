#!/usr/bin/env bash
set -euo pipefail

GUIDE="security/remediation-guide.md"

required_sections=(
  "## SAST Findings"
  "## Secrets Findings"
  "## Dependency Findings"
  "## Container Findings"
  "## Infrastructure as Code Findings"
  "## Risk Acceptance Rules"
  "## Developer Quick Decision Tree"
)

if [[ ! -f "$GUIDE" ]]; then
  echo "Missing $GUIDE"
  exit 1
fi

for section in "${required_sections[@]}"; do
  if ! grep -Fq "$section" "$GUIDE"; then
    echo "Missing required section: $section"
    exit 1
  fi
done

echo "Remediation guide validation passed."
