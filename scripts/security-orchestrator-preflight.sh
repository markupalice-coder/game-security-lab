#!/usr/bin/env bash
set -euo pipefail

required_files=(
".github/workflows/security-reusable.yml"
".github/workflows/semgrep.yml"
".github/workflows/gitleaks.yml"
".github/workflows/osv.yml"
".github/workflows/container-scan.yml"
".github/workflows/iac-scan.yml"
"security/runtime-detection-design.md"
)

mkdir -p security/out

report="security/out/security-orchestrator-preflight.md"

{
echo "# Security Orchestrator Preflight"
echo
echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo
echo "| File | Status |"
echo "|---|---|"
} > "$report"

missing=0

for file in "${required_files[@]}"; do
if [[ -f "$file" ]]; then
echo "| \`$file\` | present |" >> "$report"
else
echo "| \`$file\` | missing |" >> "$report"
missing=1
fi
done

cat "$report"

if [[ "$missing" -ne 0 ]]; then
echo "One or more expected security controls are missing. Complete earlier labs or adjust required_files." >&2
exit 1
fi
