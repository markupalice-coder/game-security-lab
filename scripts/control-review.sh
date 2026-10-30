#!/usr/bin/env bash
set -euo pipefail

mkdir -p security/out

REPORT="security/out/control-review.md"

COMMIT_SHA="$(git rev-parse HEAD)"
BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD)"
GENERATED_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

{
echo "# Full Security Control Review"
echo
echo "Generated: ${GENERATED_AT}"
echo
echo "Branch: ${BRANCH_NAME}"
echo
echo "Commit: ${COMMIT_SHA}"
echo
echo "## Control Files"
echo

for file in \
security/control-register.md \
security/severity-policy.yml \
security/vulnerability-sla.yml \
security/sarif-retention.md \
security/remediation-guide.md \
security/control-review-checklist.md
do
if [ -f "$file" ]; then
echo "- PASS: $file exists"
else
echo "- FAIL: $file is missing"
fi
done

echo
echo "## Required Scripts"
echo

for script in \
scripts/test-api.sh \
scripts/generate-sbom.sh \
scripts/scan-sbom.sh \
scripts/checkov.sh \
scripts/evidence-bundle.sh
do
if [ -x "$script" ]; then
echo "- PASS: $script exists and is executable"
elif [ -f "$script" ]; then
echo "- WARN: $script exists but is not executable"
else
echo "- FAIL: $script is missing"
fi
done

echo
echo "## Evidence Outputs"
echo

if [ -f security/evidence-bundle.tgz ]; then
echo "- PASS: security/evidence-bundle.tgz exists"
else
echo "- WARN: security/evidence-bundle.tgz does not exist yet"
fi

if [ -d security/out ]; then
echo "- PASS: security/out directory exists"
else
echo "- WARN: security/out directory missing"
fi

echo
echo "## Release Review Decision"
echo
echo "Decision: REVIEW_REQUIRED"
echo
echo "Reason: Lab 90 produces evidence. A human reviewer must still inspect scanner output, exceptions, and release risk."

} > "$REPORT"

echo "Control review report written to $REPORT"
