#!/usr/bin/env bash

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

mkdir -p security/out security/readiness

REPORT="security/out/pre-capstone-readiness.md"
JSON_REPORT="security/out/pre-capstone-readiness.json"
REQUIRED_LIST="security/readiness/required-artifacts.txt"

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

record_pass() {
    PASS_COUNT=$((PASS_COUNT + 1))
    printf 'PASS: %s\n' "$1"
}

record_fail() {
    FAIL_COUNT=$((FAIL_COUNT + 1))
    printf 'FAIL: %s\n' "$1"
}

record_warn() {
    WARN_COUNT=$((WARN_COUNT + 1))
    printf 'WARN: %s\n' "$1"
}

{
    echo "# Lab 99 Pre-Capstone Readiness Review"
    echo
    echo "Generated UTC: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "Repository: $(basename "$ROOT")"
    echo "Commit: $(git rev-parse HEAD)"
    echo
    echo "## Required Artifact Check"
    echo
} > "$REPORT"

while IFS= read -r item; do
    [ -z "$item" ] && continue

    if [ -e "$item" ]; then
        echo "- PASS: $item" >> "$REPORT"
        record_pass "Found $item" >/dev/null
    else
        echo "- FAIL: $item" >> "$REPORT"
        record_fail "Missing $item" >/dev/null
    fi
done < "$REQUIRED_LIST"

{
    echo
    echo "## Git Working Tree"
    echo
} >> "$REPORT"

if [ -z "$(git status --short)" ]; then
    echo "- PASS: Working tree is clean." >> "$REPORT"
    record_pass "Git working tree is clean" >/dev/null
else
    echo "- WARN: Working tree has changes." >> "$REPORT"
    git status --short | sed 's/^/ - /' >> "$REPORT"
    record_warn "Git working tree has changes" >/dev/null
fi

{
    echo
    echo "## Workflow Inventory"
    echo
} >> "$REPORT"

if [ -d ".github/workflows" ]; then
    find .github/workflows -type f | sort | sed 's/^/- /' >> "$REPORT"
    record_pass "Workflow directory exists" >/dev/null
else
    echo "- FAIL: .github/workflows is missing." >> "$REPORT"
    record_fail "Workflow directory missing" >/dev/null
fi

{
    echo
    echo "## Security Document Inventory"
    echo
} >> "$REPORT"

find security -maxdepth 2 -type f | sort | sed 's/^/- /' >> "$REPORT"

{
    echo
    echo "## Local Execution Checks"
    echo
} >> "$REPORT"

if [ -x "scripts/test-api.sh" ]; then
    if ./scripts/test-api.sh >> "$REPORT" 2>&1; then
        echo "- PASS: API tests completed." >> "$REPORT"
        record_pass "API tests completed" >/dev/null
    else
        echo "- FAIL: API tests failed." >> "$REPORT"
        record_fail "API tests failed" >/dev/null
    fi
else
    echo "- FAIL: scripts/test-api.sh is missing or not executable." >> "$REPORT"
    record_fail "API test script unavailable" >/dev/null
fi

if [ -x "scripts/generate-sbom.sh" ]; then
    if ./scripts/generate-sbom.sh >> "$REPORT" 2>&1; then
        echo "- PASS: SBOM generation completed." >> "$REPORT"
        record_pass "SBOM generation completed" >/dev/null
    else
        echo "- FAIL: SBOM generation failed." >> "$REPORT"
        record_fail "SBOM generation failed" >/dev/null
    fi
else
    echo "- FAIL: scripts/generate-sbom.sh is missing or not executable." >> "$REPORT"
    record_fail "SBOM script unavailable" >/dev/null
fi

if [ -x "scripts/evidence-bundle.sh" ]; then
    if ./scripts/evidence-bundle.sh >> "$REPORT" 2>&1; then
        echo "- PASS: Evidence bundle completed." >> "$REPORT"
        record_pass "Evidence bundle completed" >/dev/null
    else
        echo "- FAIL: Evidence bundle failed." >> "$REPORT"
        record_fail "Evidence bundle failed" >/dev/null
    fi
else
    echo "- FAIL: scripts/evidence-bundle.sh is missing or not executable." >> "$REPORT"
    record_fail "Evidence bundle script unavailable" >/dev/null
fi

{
    echo
    echo "## Readiness Decision"
    echo
} >> "$REPORT"

if [ "$FAIL_COUNT" -eq 0 ]; then
    DECISION="READY_FOR_CAPSTONE"
    echo "READY_FOR_CAPSTONE" >> "$REPORT"
else
    DECISION="NOT_READY_FOR_CAPSTONE"
    echo "NOT_READY_FOR_CAPSTONE" >> "$REPORT"
fi

cat > "$JSON_REPORT" <<JSON
{
    "lab": 99,
    "decision": "$DECISION",
    "pass_count": $PASS_COUNT,
    "warn_count": $WARN_COUNT,
    "fail_count": $FAIL_COUNT,
    "commit": "$(git rev-parse HEAD)",
    "generated_utc": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "markdown_report": "$REPORT"
}
JSON

echo "Readiness report: $REPORT"
echo "Machine report: $JSON_REPORT"
echo "Decision: $DECISION"

if [ "$FAIL_COUNT" -ne 0 ]; then
    exit 1
fi
