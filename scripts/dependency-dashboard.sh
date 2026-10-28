
#!/usr/bin/env bash

set -euo pipefail



OUT_DIR="security/out"

DASHBOARD="$OUT_DIR/dependency-dashboard.md"

SBOM="$OUT_DIR/repo-sbom.cdx.json"



mkdir -p "$OUT_DIR"



run_gate() {

local name="$1"

local command="$2"

local log_file="$OUT_DIR/${name}.log"



if bash -lc "$command" >"$log_file" 2>&1; then

echo "PASS"

else

echo "REVIEW"

fi

}



if [ -x scripts/generate-sbom.sh ]; then

SBOM_STATUS="$(run_gate "sbom-generation" "./scripts/generate-sbom.sh")"

else

SBOM_STATUS="MISSING"

fi



if [ -x scripts/scan-sbom.sh ]; then

GRYPE_STATUS="$(run_gate "grype-sbom" "./scripts/scan-sbom.sh")"

else

GRYPE_STATUS="MISSING"

fi



if [ -x scripts/npm-audit-api.sh ]; then

NPM_AUDIT_STATUS="$(run_gate "npm-audit" "./scripts/npm-audit-api.sh")"

else

NPM_AUDIT_STATUS="MISSING"

fi



SBOM_COMPONENTS="unknown"



if [ -f "$SBOM" ]; then

SBOM_COMPONENTS="$(

node -e '

const fs = require("fs");

const path = "security/out/repo-sbom.cdx.json";

const bom = JSON.parse(fs.readFileSync(path, "utf8"));

console.log((bom.components || []).length);

' 2>/dev/null || echo "unreadable"

)"

fi



OSV_WORKFLOW="missing"

if [ -f ".github/workflows/osv.yml" ]; then

OSV_WORKFLOW="configured"

fi



DEPENDENCY_REVIEW_WORKFLOW="missing"

if [ -f ".github/workflows/dependency-review.yml" ]; then

DEPENDENCY_REVIEW_WORKFLOW="configured"

fi



RELEASE_DECISION="Needs security review before release"



if [ "$SBOM_STATUS" = "PASS" ] \

&& [ "$GRYPE_STATUS" = "PASS" ] \

&& [ "$NPM_AUDIT_STATUS" = "PASS" ] \

&& [ "$OSV_WORKFLOW" = "configured" ] \

&& [ "$DEPENDENCY_REVIEW_WORKFLOW" = "configured" ]; then

RELEASE_DECISION="Dependency evidence is ready for release review"

fi



{

echo "# Dependency Risk Dashboard"

echo

echo "**Generated UTC:** $(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo

echo "## Executive Summary"

echo

echo "| Signal | Status | Evidence |"

echo "|---|---:|---|"

echo "| SBOM generation | $SBOM_STATUS | $SBOM |"

echo "| SBOM component count | $SBOM_COMPONENTS | Parsed from CycloneDX JSON |"

echo "| Grype SBOM vulnerability gate | $GRYPE_STATUS | $OUT_DIR/grype-sbom.log |"

echo "| npm audit high-severity gate | $NPM_AUDIT_STATUS | $OUT_DIR/npm-audit.log |"

echo "| OSV workflow | $OSV_WORKFLOW | .github/workflows/osv.yml |"

echo "| Dependency Review workflow | $DEPENDENCY_REVIEW_WORKFLOW | .github/workflows/dependency-review.yml |"

echo

echo "## Release Decision"

echo

echo "**$RELEASE_DECISION**"

echo

echo "## How to Interpret This Dashboard"

echo

echo "- **PASS** means the command completed successfully."

echo "- **REVIEW** means the command found a problem or returned a non-zero exit code."

echo "- **MISSING** means the expected script or workflow does not exist."

echo "- **configured** means the workflow file exists in the repository."

echo

echo "## Evidence Files"

echo

echo "| Evidence | Purpose |"

echo "|---|---|"

echo "| security/out/repo-sbom.cdx.json | Machine-readable SBOM generated from the repository |"

echo "| security/out/sbom-generation.log | SBOM generation log |"

echo "| security/out/grype-sbom.log | SBOM vulnerability scan log |"

echo "| security/out/npm-audit.log | npm audit vulnerability log |"

echo "| .github/workflows/osv.yml | OSV dependency scanner workflow |"

echo "| .github/workflows/dependency-review.yml | Pull-request dependency review workflow |"

echo

echo "## Operator Notes"

echo

echo "- Review any **REVIEW** status before merging a release branch."

echo "- Do not treat this dashboard as a replacement for scanner logs."

echo "- Treat this dashboard as the human-readable cover page for dependency evidence."

echo "- Regenerate this file in CI so timestamps and scan results stay current."

} > "$DASHBOARD"



echo "Dashboard written to $DASHBOARD"

