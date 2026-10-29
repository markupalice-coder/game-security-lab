#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$PROJECT_ROOT"

EVIDENCE_ROOT="security/evidence"
BUNDLE_CONTENT="$EVIDENCE_ROOT/bundle-content"
SCANNER_OUTPUT="$BUNDLE_CONTENT/scanner-output"
BUNDLE_FILE="security/evidence-bundle.tgz"

mkdir -p "$EVIDENCE_ROOT"

# Rebuild generated evidence content.
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

copy_if_exists \
  "security/control-register.md" \
  "$BUNDLE_CONTENT/control-register.md"

copy_if_exists \
  "security/severity-policy.yml" \
  "$BUNDLE_CONTENT/severity-policy.yml"

copy_if_exists \
  "security/vulnerability-sla.yml" \
  "$BUNDLE_CONTENT/vulnerability-sla.yml"

# Include scanner outputs, including SARIF files, when available.
if [[ -d "security/out" ]]; then
  cp -R security/out/. "$SCANNER_OUTPUT/"
  echo "Collected scanner outputs from security/out"
else
  echo "No security/out directory found"
fi

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
incident reviews, and scanner rollout governance.

## Contents

- control-register.md, if available
- severity-policy.yml, if available
- vulnerability-sla.yml, if available
- scanner-output/, including available SARIF and scanner reports
- SHA256SUMS
- evidence-manifest.md

## Integrity Verification

From the extracted bundle-content directory, run:

\`sha256sum -c SHA256SUMS\`

## Artifact Retention

The CI workflow uploads the generated archive as a security evidence
artifact with a configured retention period of 30 days.
MANIFEST

# Generate checksums relative to bundle-content so verification works
# from the extracted directory.
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
)

rm -f "$BUNDLE_FILE"
tar -czf "$BUNDLE_FILE" -C "$EVIDENCE_ROOT" bundle-content

echo
echo "Evidence bundle created:"
ls -lh "$BUNDLE_FILE"
echo
echo "Evidence checksums:"
cat "$BUNDLE_CONTENT/SHA256SUMS"