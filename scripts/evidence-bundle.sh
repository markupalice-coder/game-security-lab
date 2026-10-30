
#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$PROJECT_ROOT"

EVIDENCE_ROOT="security/evidence"
BUNDLE_CONTENT="$EVIDENCE_ROOT/bundle-content"
SCANNER_OUTPUT="$BUNDLE_CONTENT/scanner-output"
BUNDLE_FILE="security/evidence-bundle.tgz"

# Start with a clean evidence directory.
mkdir -p "$EVIDENCE_ROOT"
rm -rf "$BUNDLE_CONTENT"
mkdir -p "$SCANNER_OUTPUT"

copy_if_exists() {
    local source_path="$1"
    local destination_path="$2"

    if [[ -e "$source_path" ]]; then
        mkdir -p "$(dirname "$destination_path")"
        cp -R "$source_path" "$destination_path"
        echo "Collected: $source_path"
    else
        echo "Skipped missing file: $source_path"
    fi
}

echo "Collecting security control documentation..."

# Security control documentation.
copy_if_exists \
    "security/control-register.md" \
    "$BUNDLE_CONTENT/control-register.md"

copy_if_exists \
    "security/control-review-checklist.md" \
    "$BUNDLE_CONTENT/control-review-checklist.md"

copy_if_exists \
    "security/severity-policy.yml" \
    "$BUNDLE_CONTENT/severity-policy.yml"

copy_if_exists \
    "security/vulnerability-sla.yml" \
    "$BUNDLE_CONTENT/vulnerability-sla.yml"

copy_if_exists \
    "security/sarif-retention.md" \
    "$BUNDLE_CONTENT/sarif-retention.md"

copy_if_exists \
    "security/remediation-guide.md" \
    "$BUNDLE_CONTENT/remediation-guide.md"

# Lab 91: Player data classification evidence.
copy_if_exists \
    "security/player-data-classification.md" \
    "$BUNDLE_CONTENT/player-data-classification.md"

copy_if_exists \
    "security/player-data-classification.json" \
    "$BUNDLE_CONTENT/player-data-classification.json"

copy_if_exists \
    "scripts/validate-player-data-classification.py" \
    "$BUNDLE_CONTENT/scripts/validate-player-data-classification.py"

# Lab 92: Telemetry privacy evidence.
copy_if_exists \
    "security/telemetry-privacy-rules.yml" \
    "$BUNDLE_CONTENT/telemetry-privacy-rules.yml"

copy_if_exists \
    "security/privacy-policy-tests" \
    "$BUNDLE_CONTENT/privacy-policy-tests"

copy_if_exists \
    "policies/rego/telemetry-privacy.rego" \
    "$BUNDLE_CONTENT/policies/rego/telemetry-privacy.rego"

copy_if_exists \
    "scripts/validate-telemetry-privacy.sh" \
    "$BUNDLE_CONTENT/scripts/validate-telemetry-privacy.sh"

# Collect workflow configurations.
copy_if_exists \
    ".github/workflows/security-orchestrator.yml" \
    "$BUNDLE_CONTENT/.github/workflows/security-orchestrator.yml"

copy_if_exists \
    ".github/workflows/sarif-retention-audit.yml" \
    "$BUNDLE_CONTENT/.github/workflows/sarif-retention-audit.yml"

copy_if_exists \
    ".github/workflows/control-review.yml" \
    "$BUNDLE_CONTENT/.github/workflows/control-review.yml"

copy_if_exists \
    ".github/workflows/player-data-classification.yml" \
    "$BUNDLE_CONTENT/.github/workflows/player-data-classification.yml"

copy_if_exists \
    ".github/workflows/telemetry-privacy.yml" \
    "$BUNDLE_CONTENT/.github/workflows/telemetry-privacy.yml"

# Collect Kubernetes configuration.
copy_if_exists \
    "deploy/k8s/api.yaml" \
    "$BUNDLE_CONTENT/deploy/k8s/api.yaml"

# Collect evidence-generation script.
copy_if_exists \
    "scripts/evidence-bundle.sh" \
    "$BUNDLE_CONTENT/scripts/evidence-bundle.sh"

echo "Collecting scanner outputs..."

# Collect existing scanner outputs.
if [[ -d "security/out" ]]; then
    cp -R security/out/. "$SCANNER_OUTPUT/"
    echo "Collected scanner outputs from security/out"
else
    echo "No security/out directory found."
fi

# Collect SARIF reports separately when available.
if [[ -d "security/out/sarif" ]]; then
    while IFS= read -r -d '' sarif_file; do
        echo "Found SARIF report: $sarif_file"
    done < <(
        find security/out/sarif \
            -maxdepth 1 \
            -type f \
            -name '*.sarif' \
            -print0
    )
else
    echo "No SARIF directory found."
fi

# Collect additional security reports.
copy_if_exists \
    "security/reports" \
    "$BUNDLE_CONTENT/security/reports"

# Record Git metadata.
GIT_COMMIT="$(git rev-parse HEAD 2>/dev/null || echo "unknown")"
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"
GENERATED_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

cat > "$BUNDLE_CONTENT/evidence-manifest.md" <<MANIFEST
# Security Evidence Bundle Manifest

Generated UTC: ${GENERATED_UTC}

Git Commit: ${GIT_COMMIT}

Git Branch: ${GIT_BRANCH}

Repository Root: ${PROJECT_ROOT}

## Purpose

This bundle preserves security evidence for release reviews, audits,
incident reviews, scanner rollout governance, and security control reviews.

## Contents

- Control register and control review checklist, if available
- Severity policy and vulnerability SLA documentation, if available
- SARIF retention and remediation documentation, if available
- Player data classification Markdown policy, if available
- Player data classification JSON policy, if available
- Player data classification validation script, if available
- Telemetry privacy rules and rejected policy test fixtures, if available
- Telemetry privacy Rego policy and validation script, if available
- Security orchestrator and control review workflows, if available
- Telemetry privacy workflow, if available
- Kubernetes API deployment configuration, if available
- Evidence generation script, if available
- scanner-output/, including available SARIF and scanner reports
- security/reports/, if available
- SHA256SUMS
- evidence-manifest.md

## Integrity Verification

From the extracted bundle-content directory, run:

\`sha256sum -c SHA256SUMS\`

## Artifact Retention

The CI workflow uploads the generated archive as a GitHub Actions
security evidence artifact with a configured retention period of 30 days.
MANIFEST

# Generate checksums relative to bundle-content.
(
    cd "$BUNDLE_CONTENT"

    if command -v sha256sum >/dev/null 2>&1; then
        find . -type f ! -name "SHA256SUMS" -print0 \
            | sort -z \
            | xargs -0 -r sha256sum > SHA256SUMS
    elif command -v shasum >/dev/null 2>&1; then
        find . -type f ! -name "SHA256SUMS" -print0 \
            | sort -z \
            | xargs -0 -r shasum -a 256 > SHA256SUMS
    else
        echo "Error: neither sha256sum nor shasum is available." >&2
        exit 1
    fi

    echo "Verifying evidence checksums..."

    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum -c SHA256SUMS
    else
        shasum -a 256 -c SHA256SUMS
    fi
)

# Create the generated archive.
rm -f "$BUNDLE_FILE"

tar -czf "$BUNDLE_FILE" \
    -C "$EVIDENCE_ROOT" \
    bundle-content

echo
echo "Security evidence bundle created successfully:"
ls -lh "$BUNDLE_FILE"

echo
echo "Evidence checksums:"
cat "$BUNDLE_CONTENT/SHA256SUMS"

echo
echo "Archive contents:"
tar -tzf "$BUNDLE_FILE"

echo
echo "Evidence bundle generation completed."
