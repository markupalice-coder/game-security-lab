
#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$PROJECT_ROOT"

EVIDENCE_ROOT="security/evidence"
BUNDLE_CONTENT="$EVIDENCE_ROOT/bundle-content"
SCANNER_OUTPUT="$BUNDLE_CONTENT/scanner-output"
BUNDLE_FILE="security/evidence-bundle.tgz"

# Start with a clean evidence directory.
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

# Collect policy and retention documentation.
copy_if_exists \
    "security/severity-policy.yml" \
    "$BUNDLE_CONTENT/security/severity-policy.yml"

copy_if_exists \
    "security/sarif-retention.md" \
    "$BUNDLE_CONTENT/security/sarif-retention.md"

# Collect relevant workflow configuration.
copy_if_exists \
    ".github/workflows/security-orchestrator.yml" \
    "$BUNDLE_CONTENT/.github/workflows/security-orchestrator.yml"

copy_if_exists \
    ".github/workflows/sarif-retention-audit.yml" \
    "$BUNDLE_CONTENT/.github/workflows/sarif-retention-audit.yml"

# Collect the Kubernetes API manifest.
copy_if_exists \
    "deploy/k8s/api.yaml" \
    "$BUNDLE_CONTENT/deploy/k8s/api.yaml"

# Collect SARIF reports when available.
if [[ -d "security/out/sarif" ]]; then
    while IFS= read -r -d '' sarif_file; do
        cp "$sarif_file" "$SCANNER_OUTPUT/"
        echo "Collected SARIF report: $sarif_file"
    done < <(
        find security/out/sarif \
            -maxdepth 1 \
            -type f \
            -name '*.sarif' \
            -print0
    )
else
    echo "Skipped missing directory: security/out/sarif"
fi

# Collect additional security reports if present.
copy_if_exists \
    "security/reports" \
    "$BUNDLE_CONTENT/security/reports"

# Include the evidence-bundle script itself.
copy_if_exists \
    "scripts/evidence-bundle.sh" \
    "$BUNDLE_CONTENT/scripts/evidence-bundle.sh"

# Create the compressed evidence archive.
mkdir -p "$(dirname "$BUNDLE_FILE")"

tar -czf "$BUNDLE_FILE" \
    -C "$EVIDENCE_ROOT" \
    bundle-content

echo "Security evidence bundle created: $BUNDLE_FILE"
echo "Archive contents:"
tar -tzf "$BUNDLE_FILE"
